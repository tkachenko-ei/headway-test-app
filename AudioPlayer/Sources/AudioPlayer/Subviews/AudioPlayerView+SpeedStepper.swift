//
//  AudioPlayerView+SpeedStepper.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 20.12.2024.
//

import SwiftUI

extension AudioPlayerView {
    struct SpeedStepper: View {
        @Binding var value: Float
        let range: ClosedRange<Float>
        
        var body: some View {
            HStack(spacing: 8) {
                Button {
                    value -= 0.1
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 16))
                        .frame(width: 24, height: 24)
                }
                .opacity(value >= range.lowerBound ? 1 : 0)
                
                Group {
                    Text(
                        value,
                        format: .number.precision(.fractionLength(0...1))
                    ) + Text("x")
                }
                .font(.system(size: 32, weight: .heavy))
                .foregroundStyle(.blue)
                .frame(width: 72)
                .contentTransition(.numericText(value: Double(value)))
                .animation(.default, value: value)
                
                Button {
                    value += 0.1
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16))
                        .frame(width: 24, height: 24)
                }
                .opacity(value <= range.upperBound ? 1 : 0)
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.primary)
        }
    }
}
