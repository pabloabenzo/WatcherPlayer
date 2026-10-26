//
//  WatchModel.swift
//  WatcherPlayer
//

import Foundation

/// Passive state container for the watch screen. Only stored properties, mutated by `WatchPresenter`.
nonisolated struct WatchModel {
    var videos: [WatchVideo] = []
    var selectedVideo: WatchVideo?
    var hasSelection: Bool = false
    var errorMessage: String?
}
