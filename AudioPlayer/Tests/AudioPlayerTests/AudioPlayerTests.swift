//
//  AudioPlayerTests.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 22.12.2024.
//

import ComposableArchitecture
import XCTest
import AVFoundation
@testable import AudioPlayer
@testable import AudioPlayerClient

@MainActor
final class AudioPlayerTests: XCTestCase {
    func testOnAppear() async throws {
        let clock = TestClock()
        let state = AudioPlayer.State(urls: [URL(fileURLWithPath: "")])
        let store = TestStore(initialState: state) {
            AudioPlayer()
        } withDependencies: {
            $0.audioPlayer.duration = { @Sendable _ in
                try await clock.sleep(for: .milliseconds(50))
                return 1
            }
            $0.audioPlayer.play = { @Sendable _, _, _ in
                try await clock.sleep(for: .seconds(1))
                return true
            }
            $0.continuousClock = clock
        }
        
        await store.send(.view(.onAppear))
        await clock.advance(by: .milliseconds(50))
        await store.receive(\.local.updateTotalTimes) {
            $0.totalTimes = [1]
        }
        await store.receive(\.local.play) {
            $0.isPlaying = true
        }
        await clock.advance(by: .milliseconds(500))
        await store.receive(\.local.updateCurrentTime) {
            $0.currentTime = 0.5
        }
        await clock.advance(by: .milliseconds(500))
        await store.receive(\.local.played.success) {
            $0.isPlaying = false
        }
    }
    
    func testPlay() async {
        let clock = TestClock()
        var state = AudioPlayer.State(urls: [URL(fileURLWithPath: "")])
        state.totalTimes = [1]
        let store = TestStore(initialState: state) {
            AudioPlayer()
        } withDependencies: {
            $0.audioPlayer.duration = { @Sendable _ in
                try await clock.sleep(for: .milliseconds(50))
                return 1
            }
            $0.audioPlayer.play = { @Sendable _, _, _ in
                try await clock.sleep(for: .seconds(1))
                return true
            }
            $0.continuousClock = clock
        }

        await store.send(.view(.playTapped)) {
            $0.isPlaying = true
        }
        await clock.advance(by: .milliseconds(500))
        await store.receive(\.local.updateCurrentTime) {
            $0.currentTime = 0.5
        }
        await clock.advance(by: .milliseconds(500))
        await store.receive(\.local.played.success) {
            $0.isPlaying = false
        }
    }
    
    func testPause() async {
        let state = AudioPlayer.State(urls: [URL(fileURLWithPath: "")])
        let store = TestStore(initialState: state) {
            AudioPlayer()
        }
        
        await store.send(.view(.pauseTapped))
    }
}
