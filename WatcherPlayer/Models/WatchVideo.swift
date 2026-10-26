//
//  WatchVideo.swift
//  WatcherPlayer
//

import Foundation

/// Model-specific representation of a video. Independent from the YouTube API DTOs.
nonisolated struct WatchVideo: Identifiable, Hashable {
    let id: String
    let title: String
    let channelTitle: String
    let publishedAt: String
    let thumbnailURL: URL?
}
