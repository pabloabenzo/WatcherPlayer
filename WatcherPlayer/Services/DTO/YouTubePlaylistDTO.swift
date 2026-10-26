//
//  YouTubePlaylistDTO.swift
//  WatcherPlayer
//

import Foundation

nonisolated struct YouTubePlaylistItemsResponseDTO: Decodable {
    let kind: String
    let etag: String
    let nextPageToken: String?
    let pageInfo: YouTubePlaylistPageInfoDTO
    let items: [YouTubePlaylistItemDTO]
}

nonisolated struct YouTubePlaylistPageInfoDTO: Decodable {
    let totalResults: Int
    let resultsPerPage: Int
}

nonisolated struct YouTubePlaylistItemDTO: Decodable {
    let id: String
    let snippet: YouTubePlaylistSnippetDTO
    let contentDetails: YouTubePlaylistContentDetailsDTO
}

nonisolated struct YouTubePlaylistSnippetDTO: Decodable {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: YouTubePlaylistThumbnailsDTO
    let channelTitle: String
    let playlistId: String
    let position: Int
    let resourceId: YouTubePlaylistResourceIDDTO
}

nonisolated struct YouTubePlaylistThumbnailsDTO: Decodable {
    let `default`: YouTubePlaylistThumbnailDTO?
    let medium: YouTubePlaylistThumbnailDTO?
    let high: YouTubePlaylistThumbnailDTO?
}

nonisolated struct YouTubePlaylistThumbnailDTO: Decodable {
    let url: String
    let width: Int?
    let height: Int?
}

nonisolated struct YouTubePlaylistResourceIDDTO: Decodable {
    let kind: String
    let videoId: String
}

nonisolated struct YouTubePlaylistContentDetailsDTO: Decodable {
    let videoId: String
    let videoPublishedAt: String
}
