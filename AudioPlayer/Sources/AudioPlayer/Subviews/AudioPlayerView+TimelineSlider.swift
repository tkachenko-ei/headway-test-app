//
//  AudioPlayerView+TimelineSlider.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 20.12.2024.
//

import SwiftUI

extension AudioPlayerView {
    struct TimelineSlider: View {
        @Binding var value: Double
        let total: Double?
        let onEditingChanged: (Bool) -> Void
        
        var body: some View {
            HStack(spacing: 8) {
                Text(.seconds(value), format: .time(pattern: .minuteSecond(padMinuteToLength: 2)))
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .frame(width: 40, alignment: .center)
                
                if let total {
                    Slider(value: $value, in: 0...total, onEditingChanged: onEditingChanged)
                } else {
                    Capsule()
                        .fill(Color(uiColor: .tertiarySystemBackground))
                        .frame(height: 4)
                }
                
                Text(.seconds(total ?? 0), format: .time(pattern: .minuteSecond(padMinuteToLength: 2)))
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .frame(width: 40, alignment: .center)
            }
        }
    }
}
