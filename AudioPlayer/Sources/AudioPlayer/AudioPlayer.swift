//
//  AudioPlayer.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 18.12.2024.
//

import ComposableArchitecture
import AudioPlayerClient
import AVFoundation
import NonEmpty

@Reducer
public struct AudioPlayer {
    enum CancelID {
        case play, timeline
    }
    
    public init() {}
    
    @Dependency(\.audioPlayer) var audioPlayer
    @Dependency(\.continuousClock) var clock
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .binding(action): 
                handleBindingAction(action, state: &state)
                
            case let .view(action):
                handleViewAction(action, state: &state)
                
            case let .local(action):
                handleLocalAction(action, state: &state)
            }
        }
    }

    func handleBindingAction(_ action: BindingAction<State>, state: inout State) -> Effect<Action> {
        switch action {
        case \.currentTime:
            state.currentTime = .minimum(state.currentTime, state.totalTimes?.reduce(0, +) ?? .infinity)
            return .none
            
        case \.rate:
            var newRate: Float = .maximum(state.rangeRates.lowerBound, state.rate)
            newRate = .minimum(newRate, state.rangeRates.upperBound)
            state.rate = newRate
            return .merge(
                play(state: &state),
                timeline(state: &state)
            )
            
        default:
            return .none
        }
    }

    func handleViewAction(_ action: Action.View, state: inout State) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isExistsPrevious = state.index > .zero
            state.isExistsNext = state.index < state.urls.count - 1
            return .run { [urls = state.urls] send in
                var seconds = [Double]()
                for url in urls {
                    let duration = try await audioPlayer.duration(url: url)
                    seconds.append(duration)
                }
                if let newTotalTimes = NonEmptyArray<Double>(seconds) {
                    await send(.local(.updateTotalTimes(newTotalTimes)))
                }
                
                await send(.local(.play))
            } catch: { _, send in
                await send(.local(.showError), animation: .default)
            }
            
        case .onDisappear:
            return .merge(
                .cancel(id: CancelID.play),
                .cancel(id: CancelID.timeline)
            )
            
        case .openPlaybackSpeedSheetTapped:
            state.isPresentedRateSheet = true
            return .none
            
        case .dismissPlaybackSpeedSheetTapped:
            state.isPresentedRateSheet = false
            return .none
            
        case .timelineSliderOnEditingChanged(let focused):
            guard !focused, let totalTimes = state.totalTimes else {
                return .cancel(id: CancelID.timeline)
            }
            var index = 0
            while
                index < totalTimes.count,
                state.currentTime > totalTimes.prefix(index + 1).reduce(0, +)
            { index += 1 }
            state.index = index
            state.isExistsPrevious = state.index > .zero
            state.isExistsNext = state.index < state.urls.count - 1
            if state.currentTime.rounded(.down) < totalTimes.reduce(0, +).rounded(.down) {
                return .merge(
                    play(state: &state),
                    timeline(state: &state)
                )
            } else {
                return pause(state: &state)
            }
            
        case .playTapped:
            guard let totalTimes = state.totalTimes else { return .none }
            if state.currentTime.rounded(.down) >= totalTimes.reduce(0, +).rounded(.down) {
                state.index = 0
                state.currentTime = 0
                state.isExistsPrevious = state.index > .zero
                state.isExistsNext = state.index < state.urls.count - 1
            }
            return .merge(
                play(state: &state),
                timeline(state: &state)
            )
            
        case .pauseTapped:
            return .merge(
                pause(state: &state),
                .cancel(id: CancelID.timeline)
            )
            
        case .fastRewindTapped:
            guard let totalTimes = state.totalTimes else { return .none }
            state.currentTime = .maximum(0, state.currentTime - 5)
            var index = 0
            while
                index < totalTimes.count,
                state.currentTime > totalTimes.prefix(index + 1).reduce(0, +)
            { index += 1 }
            state.index = index
            state.isExistsPrevious = state.index > .zero
            state.isExistsNext = state.index < state.urls.count - 1
            guard state.isPlaying else { return .none }
            return .merge(
                play(state: &state),
                timeline(state: &state)
            )
            
        case .fastForwardTapped:
            guard let totalTimes = state.totalTimes else { return .none }
            state.currentTime = .minimum(state.currentTime + 5, totalTimes.reduce(0, +))
            var index = 0
            while
                index < totalTimes.count,
                state.currentTime > totalTimes.prefix(index + 1).reduce(0, +)
            { index += 1 }
            state.index = index
            state.isExistsPrevious = state.index > .zero
            state.isExistsNext = state.index < state.urls.count - 1
            guard state.isPlaying else { return .none }
            return .merge(
                play(state: &state),
                timeline(state: &state)
            )
            
        case .previousTapped:
            guard 
                let totalTimes = state.totalTimes,
                state.index > 0 
            else { return .none }
            state.index -= 1
            state.currentTime = totalTimes.prefix(state.index).reduce(0, +)
            state.isExistsPrevious = state.index > .zero
            state.isExistsNext = state.index < state.urls.count - 1
            state.isPlaying = true
            guard state.isPlaying else { return .none }
            return .merge(
                play(state: &state),
                timeline(state: &state)
            )
            
        case .nextTapped:
            guard 
                let totalTimes = state.totalTimes,
                state.index < state.urls.count - 1
            else { return .none }
            state.index += 1
            state.currentTime = totalTimes.prefix(state.index).reduce(0, +)
            state.isExistsPrevious = state.index > .zero
            state.isExistsNext = state.index < state.urls.count - 1
            state.isPlaying = true
            guard state.isPlaying else { return .none }
            return .merge(
                play(state: &state),
                timeline(state: &state)
            )
        }
    }
    
    func handleLocalAction(_ action: Action.Local, state: inout State) -> Effect<Action> {
        switch action {
        case let .updateCurrentTime(value):
            state.currentTime = value
            return .none
            
        case let .updateTotalTimes(value):
            state.totalTimes = value
            return .none
            
        case .play:
            guard !state.isPlaying else { return .none }
            return .merge(
                play(state: &state),
                timeline(state: &state)
            )
            
        case let .played(.success(finished)):
            guard finished, state.index < state.urls.count - 1 else {
                state.isPlaying = false
                return .cancel(id: CancelID.play)
            }
            state.index += 1
            state.isExistsPrevious = state.index > .zero
            state.isExistsNext = state.index < state.urls.count - 1
            state.isPlaying = true
            return .merge(
                play(state: &state),
                timeline(state: &state)
            )
            
        case .played(.failure):
            state.isShowError = true
            return pause(state: &state)
            
        case .showError:
            state.isShowError = true
            return .none
        }
    }
    
    private func play(state: inout State) -> Effect<Action> {
        guard let totalTimes = state.totalTimes else { return .none }
        state.isPlaying = true
        let url = state.urls[state.index]
        let currentTime = state.currentTime - totalTimes.prefix(state.index).reduce(0, +)
        return .run { [url = url, currentTime = currentTime, rate = state.rate] send in
            let resultPlayed = await Result {
                try await audioPlayer.play(url: url, currentTime: currentTime, rate: rate)
            }
            await send(.local(.played(resultPlayed)))
        }
        .cancellable(id: CancelID.play, cancelInFlight: true)
    }
    
    private func pause(state: inout State) -> Effect<Action> {
        state.isPlaying = false
        return .merge(
            .cancel(id: CancelID.play),
            .cancel(id: CancelID.timeline)
        )
    }
    
    private func timeline(state: inout State) -> Effect<Action> {
        return .run { [currentTime = state.currentTime, totalTimes = state.totalTimes, rate = state.rate] send in
            var newTime: TimeInterval = currentTime
            for await _ in clock.timer(interval: .milliseconds(500)) {
                newTime += 0.5 * Double(rate)
                guard let totalTimes, newTime < totalTimes.reduce(0, +) else { return }
                await send(.local(.updateCurrentTime(newTime)), animation: .default)
            }
        }
        .cancellable(id: CancelID.timeline, cancelInFlight: true)
    }
}
