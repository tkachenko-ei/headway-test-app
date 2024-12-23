//
//  BookPlayer+Action.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 21.12.2024.
//

import ComposableArchitecture
import AudioPlayer

extension BookPlayer {
    @CasePathable
    enum Action: ViewAction {
        case view(View)
        case player(AudioPlayer.Action)

        enum View {
            case onAppear, onDisappear
        }
    }
}
