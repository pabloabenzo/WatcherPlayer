//
//  YouTubeServiceTests.swift
//  WatcherPlayerTests
//

import Foundation
import Testing
@testable import WatcherPlayer

@MainActor
struct YouTubeServiceTests {
    @Test func fetchChannelSendsExpectedRequest() async throws {
        let client = StubHTTPClient(responses: [
            StubResponse(data: try YouTubeJSONFixtures.channelList(title: "Eminem"))
        ])
        let service = YouTubeService(apiKey: "test-key", httpClient: client)

        _ = try await service.fetchChannel(channelID: "UC-test")

        let url = try #require(client.requestedURLs.first)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.host == "www.googleapis.com")
        #expect(components.path == "/youtube/v3/channels")
        #expect(query("part", in: components) == "snippet,contentDetails,statistics")
        #expect(query("id", in: components) == "UC-test")
        #expect(query("key", in: components) == "test-key")
    }

    @Test func fetchChannelDecodesChannel() async throws {
        let client = StubHTTPClient(responses: [
            StubResponse(data: try YouTubeJSONFixtures.channelList(title: "Eminem", uploadsPlaylistID: "UU-999"))
        ])
        let service = YouTubeService(apiKey: "test-key", httpClient: client)

        let channel = try await service.fetchChannel(channelID: "UC-test")

        #expect(channel.snippet.title == "Eminem")
        #expect(channel.contentDetails.relatedPlaylists.uploads == "UU-999")
    }

    @Test func fetchChannelThrowsWhenAPIKeyIsMissing() async {
        let client = StubHTTPClient()
        let service = YouTubeService(apiKey: "", httpClient: client)

        await #expect(throws: YouTubeServiceError.missingAPIKey) {
            try await service.fetchChannel(channelID: "UC-test")
        }
        #expect(client.requestedURLs.isEmpty)
    }

    @Test func fetchChannelThrowsWhenThereAreNoItems() async throws {
        let client = StubHTTPClient(responses: [
            StubResponse(data: try YouTubeJSONFixtures.channelList(channelCount: 0))
        ])
        let service = YouTubeService(apiKey: "test-key", httpClient: client)

        await #expect(throws: YouTubeServiceError.emptyChannel) {
            try await service.fetchChannel(channelID: "UC-test")
        }
    }

    @Test func fetchChannelThrowsOnServerError() async throws {
        let client = StubHTTPClient(responses: [
            StubResponse(data: try YouTubeJSONFixtures.channelList(), statusCode: 500)
        ])
        let service = YouTubeService(apiKey: "test-key", httpClient: client)

        await #expect(throws: YouTubeServiceError.invalidResponse) {
            try await service.fetchChannel(channelID: "UC-test")
        }
    }

    @Test func fetchPlaylistItemsAccumulatesAllPages() async throws {
        let client = StubHTTPClient(responses: [
            StubResponse(
                data: try YouTubeJSONFixtures.playlistItems(
                    videoIDs: ["video-1", "video-2"],
                    nextPageToken: "page-2"
                )
            ),
            StubResponse(data: try YouTubeJSONFixtures.playlistItems(videoIDs: ["video-3"]))
        ])
        let service = YouTubeService(apiKey: "test-key", httpClient: client)

        let items = try await service.fetchPlaylistItems(playlistID: "UU-test")

        #expect(items.map(\.contentDetails.videoId) == ["video-1", "video-2", "video-3"])
        #expect(client.requestedURLs.count == 2)

        let firstURL = try #require(client.requestedURLs.first)
        let firstRequest = try #require(URLComponents(url: firstURL, resolvingAgainstBaseURL: false))
        #expect(query("playlistId", in: firstRequest) == "UU-test")
        #expect(query("maxResults", in: firstRequest) == "50")
        #expect(query("pageToken", in: firstRequest) == nil)

        let secondURL = try #require(client.requestedURLs.last)
        let secondRequest = try #require(URLComponents(url: secondURL, resolvingAgainstBaseURL: false))
        #expect(query("pageToken", in: secondRequest) == "page-2")
    }

    @Test func fetchPlaylistItemsStopsAfterSinglePage() async throws {
        let client = StubHTTPClient(responses: [
            StubResponse(data: try YouTubeJSONFixtures.playlistItems(videoIDs: ["video-1"]))
        ])
        let service = YouTubeService(apiKey: "test-key", httpClient: client)

        let items = try await service.fetchPlaylistItems(playlistID: "UU-test")

        #expect(items.count == 1)
        #expect(client.requestedURLs.count == 1)
    }

    @Test func fetchPlaylistItemsThrowsWhenAPIKeyIsMissing() async {
        let client = StubHTTPClient()
        let service = YouTubeService(apiKey: "", httpClient: client)

        await #expect(throws: YouTubeServiceError.missingAPIKey) {
            try await service.fetchPlaylistItems(playlistID: "UU-test")
        }
        #expect(client.requestedURLs.isEmpty)
    }
}

private extension YouTubeServiceTests {
    func query(_ name: String, in components: URLComponents) -> String? {
        components.queryItems?.first(where: { $0.name == name })?.value
    }
}
