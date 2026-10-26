//
//  FakeYouTubeService.swift
//  WatcherPlayerTests
//

import Foundation
@testable import WatcherPlayer

@MainActor
final class FakeYouTubeService: YouTubeServicing {
    var channel: YouTubeChannelDTO
    var playlistItems: [YouTubePlaylistItemDTO]
    var channelError: Error?
    var playlistError: Error?
    private(set) var requestedChannelIDs: [String] = []
    private(set) var requestedPlaylistIDs: [String] = []

    init(
        channel: YouTubeChannelDTO = YouTubeDTOFixtures.channel(),
        playlistItems: [YouTubePlaylistItemDTO] = []
    ) {
        self.channel = channel
        self.playlistItems = playlistItems
    }

    func fetchChannel(channelID: String) async throws -> YouTubeChannelDTO {
        requestedChannelIDs.append(channelID)

        if let channelError {
            throw channelError
        }

        return channel
    }

    func fetchPlaylistItems(playlistID: String) async throws -> [YouTubePlaylistItemDTO] {
        requestedPlaylistIDs.append(playlistID)

        if let playlistError {
            throw playlistError
        }

        return playlistItems
    }
}
