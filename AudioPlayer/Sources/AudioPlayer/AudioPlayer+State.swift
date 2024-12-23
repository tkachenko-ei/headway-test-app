//
//  AudioPlayer+State.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 18.12.2024.
//

import ComposableArchitecture
import Foundation
import NonEmpty

extension AudioPlayer {
    @ObservableState
    public struct State: Equatable {
        let urls: NonEmptyArray<URL>
        var index: NonEmptyArray<URL>.Index = 0
        var totalTimes: NonEmptyArray<TimeInterval>?
        var currentTime: TimeInterval = 0.0
        var rate: Float = 1.0
        let rangeRates: ClosedRange<Float> = 0.5...2.0
        let fastRates: NonEmptyArray<Float> = [0.8, 1, 1.2, 1.5]
        var isPlaying: Bool = false
        var isExistsPrevious: Bool = false
        var isExistsNext: Bool = false
        var isPresentedRateSheet: Bool = false
        var isShowError: Bool = false
        
        public init(urls: NonEmptyArray<URL>) {
            self.urls = urls
        }
    }
}
