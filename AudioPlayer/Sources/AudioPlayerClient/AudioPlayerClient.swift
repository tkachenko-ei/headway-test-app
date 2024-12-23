//
//  AudioPlayerClient.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 18.12.2024.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct AudioPlayerClient {
    public var duration: @Sendable (_ url: URL) async throws -> TimeInterval
    public var play: @Sendable (_ url: URL, _ currentTime: TimeInterval, _ rate: Float) async throws -> Bool
}

extension DependencyValues {
    public var audioPlayer: AudioPlayerClient {
        get { self[AudioPlayerClient.self] }
        set { self[AudioPlayerClient.self] = newValue }
    }
}
