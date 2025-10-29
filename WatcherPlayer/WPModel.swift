//
//  WPModel.swift
//  WatcherPlayer
//
//  Created by Pablo Benzo on 25/06/2025.
//

import Foundation

// MARK: - channel
struct ChannelListResponse: Codable {
    let kind: String
    let etag: String
    let pageInfo: PageInfo
    let items: [YouTubeChannel]
}

struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
}

struct YouTubeChannel: Codable {
    let kind: String
    let etag: String
    let id: String
    let snippet: Snippet
    let contentDetails: ContentDetails
    let statistics: Statistics
}

struct Snippet: Codable {
    let title: String
    let description: String
    let customURL: String?
    let publishedAt: String
    let thumbnails: Thumbnails
    let defaultLanguage: String?
    let localized: Localized
    let country: String?

    enum CodingKeys: String, CodingKey {
        case title, description, publishedAt, thumbnails, defaultLanguage, localized, country
        case customURL = "customUrl"
    }
}

struct Thumbnails: Codable {
    let `default`: Thumbnail?
    let medium: Thumbnail?
    let high: Thumbnail?
}

struct Thumbnail: Codable {
    let url: String
    let width: Int?
    let height: Int?
}

struct Localized: Codable {
    let title: String
    let description: String
}

struct ContentDetails: Codable {
    let relatedPlaylists: RelatedPlaylists
}

struct RelatedPlaylists: Codable {
    let likes: String?
    let uploads: String
}

struct Statistics: Codable {
    let viewCount: String
    let subscriberCount: String
    let hiddenSubscriberCount: Bool
    let videoCount: String
}

// MARK: - playlist
struct PlaylistItemsResponse: Codable {
    let kind: String
    let etag: String
    let nextPageToken: String?
    let pageInfo: PlaylistPageInfo
    let items: [PlaylistItem]
}

struct PlaylistPageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
}

struct PlaylistItem: Codable, Identifiable {
    let id: String
    let snippet: PlaylistSnippet
    let contentDetails: PlaylistContentDetails
}

struct PlaylistSnippet: Codable {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: PlaylistThumbnails
    let channelTitle: String
    let playlistId: String
    let position: Int
    let resourceId: PlaylistResourceID
}

struct PlaylistThumbnails: Codable {
    let `default`: PlaylistThumbnail?
    let medium: PlaylistThumbnail?
    let high: PlaylistThumbnail?
}

struct PlaylistThumbnail: Codable {
    let url: String
    let width: Int?
    let height: Int?
}

struct PlaylistResourceID: Codable {
    let kind: String
    let videoId: String
}

struct PlaylistContentDetails: Codable {
    let videoId: String
    let videoPublishedAt: String
}
