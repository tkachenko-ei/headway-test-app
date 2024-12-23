//
//  AudioPlayer+Action.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 18.12.2024.
//

import ComposableArchitecture
import Foundation
import NonEmpty

extension AudioPlayer {
    @CasePathable
    public enum Action: BindableAction, ViewAction {
        case binding(BindingAction<State>)
        case view(View)
        case local(Local)
        
        @CasePathable
        public enum View {
            case onAppear, onDisappear
            case openPlaybackSpeedSheetTapped,
                 dismissPlaybackSpeedSheetTapped
            case timelineSliderOnEditingChanged(Bool)
            case playTapped, pauseTapped
            case fastRewindTapped, fastForwardTapped
            case previousTapped, nextTapped
        }
        
        @CasePathable
        public enum Local {
            case updateCurrentTime(TimeInterval)
            case updateTotalTimes(NonEmptyArray<TimeInterval>)
            case play
            case played(Result<Bool, Error>)
            case showError
        }
    }
}
