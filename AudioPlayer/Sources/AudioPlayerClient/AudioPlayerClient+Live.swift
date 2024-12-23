//
//  AudioPlayerClient+Live.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 18.12.2024.
//

import Dependencies
import AVFoundation

extension AudioPlayerClient: DependencyKey {
    public static let liveValue = Self { url in
        let asset = AVURLAsset(url: url)
        let duration = try await asset.load(.duration)
        return duration.seconds
    } play: { url, currentTime, rate in
        let stream = AsyncThrowingStream<Bool, any Error> { continuation in
            do {
                let delegate = try Delegate(
                    url: url,
                    currentTime: currentTime,
                    rate: rate,
                    didFinishPlaying: { successful in
                        continuation.yield(successful)
                        continuation.finish()
                    },
                    decodeErrorDidOccur: { error in
                        continuation.finish(throwing: error)
                    }
                )
                delegate.player.play()
                
                continuation.onTermination = { _ in
                    delegate.player.stop()
                }
            } catch {
                continuation.finish(throwing: error)
            }
        }
        return try await stream.first(where: { _ in true }) ?? false
    }

    private final class Delegate: NSObject, AVAudioPlayerDelegate {
        let player: AVAudioPlayer
        private let didFinishPlaying: @Sendable (Bool) -> Void
        private let decodeErrorDidOccur: @Sendable (Error?) -> Void
        
        init(
            url: URL,
            currentTime: TimeInterval,
            rate: Float,
            didFinishPlaying: @escaping @Sendable (Bool) -> Void,
            decodeErrorDidOccur: @escaping @Sendable (Error?) -> Void
        ) throws {
            self.didFinishPlaying = didFinishPlaying
            self.decodeErrorDidOccur = decodeErrorDidOccur
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player.currentTime = currentTime
            self.player.enableRate = true
            self.player.rate = rate
            super.init()
            self.player.delegate = self
        }
        
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            didFinishPlaying(flag)
        }
        
        func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: (any Error)?) {
            decodeErrorDidOccur(error)
        }
    }
}
