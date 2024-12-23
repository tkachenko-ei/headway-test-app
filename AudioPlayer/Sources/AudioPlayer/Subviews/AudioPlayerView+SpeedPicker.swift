//
//  AudioPlayerView+SpeedPicker.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 20.12.2024.
//

import SwiftUI
import NonEmpty

extension AudioPlayerView {
    struct SpeedPicker: View {
        @Binding var value: Float
        let values: NonEmptyArray<Float>
        
        var body: some View {
            HStack(spacing: 8) {
                ForEach(values, id: \.self) { newValue in
                    Button {
                        value = newValue
                    } label: {
                        Group {
                            if newValue == 1 {
                                Text("Normal")
                            } else {
                                Text(newValue, format: .number.precision(.fractionLength(0...1))) + Text("x")
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.primary)
                }
            }
            .buttonStyle(.bordered)
            .font(.system(size: 16))
        }
    }
}
