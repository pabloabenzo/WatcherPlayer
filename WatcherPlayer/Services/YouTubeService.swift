//
//  YouTubeService.swift
//  WatcherPlayer
//

import Foundation

enum YouTubeServiceError: LocalizedError {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case emptyChannel

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            "The YouTube API key is missing from the app configuration."
        case .invalidURL:
            "The YouTube request could not be built."
        case .invalidResponse:
            "The YouTube server returned an unexpected response."
        case .emptyChannel:
            "The YouTube channel could not be found."
        }
    }
}

protocol YouTubeServicing {
    func fetchChannel(channelID: String) async throws -> YouTubeChannelDTO
    func fetchPlaylistItems(playlistID: String) async throws -> [YouTubePlaylistItemDTO]
}

struct YouTubeService: YouTubeServicing {
    private let apiKey: String
    private let session: URLSession
    private let decoder: JSONDecoder

    init(apiKey: String = AppConfiguration.youTubeAPIKey, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
        self.decoder = JSONDecoder()
    }

    func fetchChannel(channelID: String) async throws -> YouTubeChannelDTO {
        let url = try makeURL(
            path: "channels",
            queryItems: [
                URLQueryItem(name: "part", value: "snippet,contentDetails,statistics"),
                URLQueryItem(name: "id", value: channelID)
            ]
        )
        let response: YouTubeChannelListResponseDTO = try await fetch(url)
        guard let channel = response.items.first else {
            throw YouTubeServiceError.emptyChannel
        }
        return channel
    }

    func fetchPlaylistItems(playlistID: String) async throws -> [YouTubePlaylistItemDTO] {
        var items: [YouTubePlaylistItemDTO] = []
        var pageToken: String?

        repeat {
            var queryItems = [
                URLQueryItem(name: "part", value: "snippet,contentDetails"),
                URLQueryItem(name: "playlistId", value: playlistID),
                URLQueryItem(name: "maxResults", value: "50")
            ]
            if let pageToken {
                queryItems.append(URLQueryItem(name: "pageToken", value: pageToken))
            }

            let url = try makeURL(path: "playlistItems", queryItems: queryItems)
            let response: YouTubePlaylistItemsResponseDTO = try await fetch(url)
            items.append(contentsOf: response.items)
            pageToken = response.nextPageToken
        } while pageToken != nil

        return items
    }
}

private extension YouTubeService {
    func makeURL(path: String, queryItems: [URLQueryItem]) throws -> URL {
        guard !apiKey.isEmpty else {
            throw YouTubeServiceError.missingAPIKey
        }

        var components = URLComponents(string: "https://www.googleapis.com/youtube/v3/\(path)")
        components?.queryItems = queryItems + [URLQueryItem(name: "key", value: apiKey)]

        guard let url = components?.url else {
            throw YouTubeServiceError.invalidURL
        }
        return url
    }

    func fetch<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw YouTubeServiceError.invalidResponse
        }

        return try decoder.decode(T.self, from: data)
    }
}
