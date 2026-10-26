//
//  YouTubeDTOFixtures.swift
//  WatcherPlayerTests
//

import Foundation
@testable import WatcherPlayer

enum YouTubeDTOFixtures {
    static func channel(
        title: String = "Eminem",
        uploadsPlaylistID: String = "UU-uploads"
    ) -> YouTubeChannelDTO {
        YouTubeChannelDTO(
            kind: "youtube#channel",
            etag: "etag",
            id: "UC-channel",
            snippet: YouTubeChannelSnippetDTO(
                title: title,
                description: "Description",
                customURL: nil,
                publishedAt: "2006-01-01T00:00:00Z",
                thumbnails: YouTubeThumbnailsDTO(
                    default: YouTubeThumbnailDTO(url: "https://img.example/default.jpg", width: 88, height: 88),
                    medium: nil,
                    high: nil
                ),
                defaultLanguage: "en",
                localized: YouTubeLocalizedDTO(title: title, description: "Description"),
                country: "US"
            ),
            contentDetails: YouTubeChannelContentDetailsDTO(
                relatedPlaylists: YouTubeRelatedPlaylistsDTO(likes: nil, uploads: uploadsPlaylistID)
            ),
            statistics: YouTubeChannelStatisticsDTO(
                viewCount: "1",
                subscriberCount: "2",
                hiddenSubscriberCount: false,
                videoCount: "3"
            )
        )
    }

    static func video(
        videoID: String,
        title: String? = nil,
        channelTitle: String = "Eminem",
        publishedAt: String = "2025-01-01T00:00:00Z",
        highThumbnailURL: String? = "https://img.example/high.jpg",
        mediumThumbnailURL: String? = nil,
        defaultThumbnailURL: String? = nil
    ) -> YouTubePlaylistItemDTO {
        YouTubePlaylistItemDTO(
            id: "playlist-item-\(videoID)",
            snippet: YouTubePlaylistSnippetDTO(
                publishedAt: publishedAt,
                channelId: "UC-channel",
                title: title ?? "Video \(videoID)",
                description: "Description",
                thumbnails: YouTubePlaylistThumbnailsDTO(
                    default: thumbnail(defaultThumbnailURL),
                    medium: thumbnail(mediumThumbnailURL),
                    high: thumbnail(highThumbnailURL)
                ),
                channelTitle: channelTitle,
                playlistId: "UU-uploads",
                position: 0,
                resourceId: YouTubePlaylistResourceIDDTO(kind: "youtube#video", videoId: videoID)
            ),
            contentDetails: YouTubePlaylistContentDetailsDTO(
                videoId: videoID,
                videoPublishedAt: publishedAt
            )
        )
    }
}

private extension YouTubeDTOFixtures {
    static func thumbnail(_ url: String?) -> YouTubePlaylistThumbnailDTO? {
        guard let url else { return nil }
        return YouTubePlaylistThumbnailDTO(url: url, width: 480, height: 360)
    }
}
