//
//  BookPlayerView.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 21.12.2024.
//

import ComposableArchitecture
import SwiftUI
import AudioPlayer

@ViewAction(for: BookPlayer.self)
struct BookPlayerView: View {
    @Bindable var store: StoreOf<BookPlayer>
    
    var body: some View {
        VStack(spacing: 48) {
            Image(store.image.rawValue)
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { size, axis in
                    size * 0.5
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            AudioPlayerView(store: store.scope(state: \.player, action: \.player))
                .padding(.horizontal, 16)
        }
    }
}
