//
//  YouTubeChannelDTO.swift
//  WatcherPlayer
//

import Foundation

nonisolated struct YouTubeChannelListResponseDTO: Decodable {
    let kind: String
    let etag: String
    let pageInfo: YouTubePageInfoDTO
    let items: [YouTubeChannelDTO]
}

nonisolated struct YouTubePageInfoDTO: Decodable {
    let totalResults: Int
    let resultsPerPage: Int
}

nonisolated struct YouTubeChannelDTO: Decodable {
    let kind: String
    let etag: String
    let id: String
    let snippet: YouTubeChannelSnippetDTO
    let contentDetails: YouTubeChannelContentDetailsDTO
    let statistics: YouTubeChannelStatisticsDTO
}

nonisolated struct YouTubeChannelSnippetDTO: Decodable {
    let title: String
    let description: String
    let customURL: String?
    let publishedAt: String
    let thumbnails: YouTubeThumbnailsDTO
    let defaultLanguage: String?
    let localized: YouTubeLocalizedDTO
    let country: String?

    enum CodingKeys: String, CodingKey {
        case title, description, publishedAt, thumbnails, defaultLanguage, localized, country
        case customURL = "customUrl"
    }
}

nonisolated struct YouTubeThumbnailsDTO: Decodable {
    let `default`: YouTubeThumbnailDTO?
    let medium: YouTubeThumbnailDTO?
    let high: YouTubeThumbnailDTO?
}

nonisolated struct YouTubeThumbnailDTO: Decodable {
    let url: String
    let width: Int?
    let height: Int?
}

nonisolated struct YouTubeLocalizedDTO: Decodable {
    let title: String
    let description: String
}

nonisolated struct YouTubeChannelContentDetailsDTO: Decodable {
    let relatedPlaylists: YouTubeRelatedPlaylistsDTO
}

nonisolated struct YouTubeRelatedPlaylistsDTO: Decodable {
    let likes: String?
    let uploads: String
}

nonisolated struct YouTubeChannelStatisticsDTO: Decodable {
    let viewCount: String
    let subscriberCount: String
    let hiddenSubscriberCount: Bool
    let videoCount: String
}
