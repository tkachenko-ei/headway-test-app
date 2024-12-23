//
//  BookPlayer+State.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 21.12.2024.
//

import ComposableArchitecture
import Foundation
import NonEmpty
import AudioPlayer

extension BookPlayer {
    @ObservableState
    struct State {
        let image: NonEmptyString
        var player: AudioPlayer.State
        
        init(image: NonEmptyString, audios urls: NonEmptyArray<URL>) {
            self.image = image
            self.player = AudioPlayer.State(urls: urls)
        }
    }
}
