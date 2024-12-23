//
//  AudioPlayerView.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 18.12.2024.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: AudioPlayer.self)
public struct AudioPlayerView: View {
    @Bindable public var store: StoreOf<AudioPlayer>
    
    public init(store: StoreOf<AudioPlayer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 48) {
            if !store.isShowError {
                VStack(spacing: 16) {
                    Group {
                        Text("KEY POINT ")
                        + Text(store.index + 1, format: .number)
                        + Text(" OF ")
                        + Text(store.urls.count, format: .number)
                    }
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    
                    TimelineSlider(value: $store.currentTime, total: store.totalTimes?.reduce(0, +)) { focused in
                        send(.timelineSliderOnEditingChanged(focused))
                    }
                    
                    Button {
                        send(.openPlaybackSpeedSheetTapped)
                    } label: {
                        Group {
                            Text(
                                store.rate,
                                format: .number.precision(.fractionLength(0...1))
                            ) + Text("x speed")
                        }
                        .font(.system(size: 16))
                    }
                    .buttonStyle(.bordered)
                }
                
                HStack(spacing: 32) {
                    Button {
                        send(.previousTapped)
                    } label: {
                        Image(systemName: "backward.end.fill")
                            .font(.system(size: 24))
                    }
                    .disabled(!store.isExistsPrevious)
                    .opacity(store.isExistsPrevious ? 1 : 0.3)
                    
                    Button {
                        send(.fastRewindTapped)
                    } label: {
                        Image(systemName: "gobackward.5")
                            .font(.system(size: 32))
                    }
                    
                    if store.isPlaying {
                        Button {
                            send(.pauseTapped)
                        } label: {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 40))
                        }
                    } else {
                        Button {
                            send(.playTapped)
                        } label: {
                            Image(systemName: "play.fill")
                                .font(.system(size: 40))
                        }
                    }
                    
                    Button {
                        send(.fastForwardTapped)
                    } label: {
                        Image(systemName: "goforward.5")
                            .font(.system(size: 32))
                    }
                    
                    Button {
                        send(.nextTapped)
                    } label: {
                        Image(systemName: "forward.end.fill")
                            .font(.system(size: 24))
                    }
                    .disabled(!store.isExistsNext)
                    .opacity(store.isExistsNext ? 1 : 0.3)
                }
            } else {
                Text("Something went wrong!")
                    .bold()
                    .font(.system(size: 24))
                    .foregroundStyle(.primary)
                
                Text("Try again later")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(.primary)
        .sheet(isPresented: $store.isPresentedRateSheet, content: rateSheet)
        .onAppear { send(.onAppear) }
        .onAppear { send(.onDisappear) }
    }
    
    private func rateSheet() -> some View {
        VStack(spacing: 16) {
            Text("Playback speed")
                .bold()
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SpeedStepper(value: $store.rate, range: store.rangeRates)
            
            SpeedSlider(value: $store.rate, range: store.rangeRates)
                .padding(.vertical, 16)
            
            SpeedPicker(value: $store.rate, values: store.fastRates)
            
            Button {
                send(.dismissPlaybackSpeedSheetTapped)
            } label: {
                Text("Continue")
                    .bold()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .presentationDetents([.height(320)])
        .presentationDragIndicator(.hidden)
        .padding(16)
    }
}
