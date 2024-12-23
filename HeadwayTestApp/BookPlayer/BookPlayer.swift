//
//  BookPlayer.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 21.12.2024.
//

import ComposableArchitecture
import NonEmpty
import AudioPlayer

@Reducer
struct BookPlayer {
    var body: some Reducer<State, Action> {
        Scope(state: \.player, action: \.player) {
            AudioPlayer()
        }
        
        Reduce { state, action in
            switch action {
            case let .view(action):
                handleViewAction(action, state: &state)
                
            case .player: .none
            }
        }
    }
    
    func handleViewAction(_ action: Action.View, state: inout State) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
            
        case .onDisappear:
            return .none
        }
    }
}
