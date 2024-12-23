//
//  AudioPlayerView+SpeedSlider.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 20.12.2024.
//

import SwiftUI

extension AudioPlayerView {
    struct SpeedSlider: View {
        @Binding var value: Float
        let range: ClosedRange<Float>
        
        var body: some View {
            ZStack(alignment: .bottom) {
                HStack {
                    Text(
                        range.lowerBound,
                        format: .number.precision(.fractionLength(0...1))
                    ) + Text("x")
                    
                    Spacer()
                    
                    Text(
                        range.upperBound,
                        format: .number.precision(.fractionLength(0...1))
                    ) + Text("x")
                }
                .monospacedDigit()
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .offset(y: 8)
                
                Slider(value: $value, in: range, step: 0.1)
                    .tint(.gray)
                    .padding([.horizontal, .bottom], 8)
                    .animation(.default, value: value)
            }
        }
    }
}
