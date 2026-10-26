//
//  AppConfiguration.swift
//  WatcherPlayer
//

import Foundation

nonisolated enum AppConfiguration {
    /// YouTube Data API key, injected through `Info.plist` so it is not hardcoded in source.
    static let youTubeAPIKey: String = Bundle.main.object(forInfoDictionaryKey: "YouTubeAPIKey") as? String ?? ""

    static let channelID: String = "UCfM3zsQsOnfWNUppiycmBuw"
}
