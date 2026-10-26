//
//  WatchPresenterTests.swift
//  WatcherPlayerTests
//

import Testing
@testable import WatcherPlayer

@MainActor
struct WatchPresenterTests {
    @Test func loadPopulatesModelFromService() async {
        let service = FakeYouTubeService(
            channel: YouTubeDTOFixtures.channel(title: "Eminem Channel", uploadsPlaylistID: "UU-123"),
            playlistItems: [
                YouTubeDTOFixtures.video(videoID: "video-1", title: "Mockingbird"),
                YouTubeDTOFixtures.video(videoID: "video-2", title: "Stan")
            ]
        )
        let router = WatchRouter()
        let presenter = WatchPresenter(service: service, router: router)

        await presenter.action(.load)

        #expect(presenter.model.videos.count == 2)
        #expect(presenter.model.selectedVideo?.id == "video-1")
        #expect(presenter.model.hasSelection == true)
        #expect(presenter.model.errorMessage == nil)
        #expect(router.navigationTitle == "Eminem Channel")
        #expect(router.isLoading == false)
        #expect(service.requestedChannelIDs == [AppConfiguration.channelID])
        #expect(service.requestedPlaylistIDs == ["UU-123"])
    }

    @Test func loadMapsDTOIntoModelVideo() async throws {
        let service = FakeYouTubeService(
            playlistItems: [
                YouTubeDTOFixtures.video(
                    videoID: "abc123",
                    title: "Lose Yourself",
                    channelTitle: "EminemVEVO",
                    publishedAt: "2024-05-01T10:00:00Z",
                    highThumbnailURL: "https://img.example/high.jpg"
                )
            ]
        )
        let presenter = WatchPresenter(service: service, router: WatchRouter())

        await presenter.action(.load)

        let video = try #require(presenter.model.videos.first)
        #expect(video.id == "abc123")
        #expect(video.title == "Lose Yourself")
        #expect(video.channelTitle == "EminemVEVO")
        #expect(video.publishedAt == "2024-05-01T10:00:00Z")
        #expect(video.thumbnailURL?.absoluteString == "https://img.example/high.jpg")
    }

    @Test func loadFallsBackToMediumThumbnail() async throws {
        let service = FakeYouTubeService(
            playlistItems: [
                YouTubeDTOFixtures.video(
                    videoID: "abc123",
                    highThumbnailURL: nil,
                    mediumThumbnailURL: "https://img.example/medium.jpg"
                )
            ]
        )
        let presenter = WatchPresenter(service: service, router: WatchRouter())

        await presenter.action(.load)

        let video = try #require(presenter.model.videos.first)
        #expect(video.thumbnailURL?.absoluteString == "https://img.example/medium.jpg")
    }

    @Test func loadFallsBackToDefaultThumbnail() async throws {
        let service = FakeYouTubeService(
            playlistItems: [
                YouTubeDTOFixtures.video(
                    videoID: "abc123",
                    highThumbnailURL: nil,
                    mediumThumbnailURL: nil,
                    defaultThumbnailURL: "https://img.example/default.jpg"
                )
            ]
        )
        let presenter = WatchPresenter(service: service, router: WatchRouter())

        await presenter.action(.load)

        let video = try #require(presenter.model.videos.first)
        #expect(video.thumbnailURL?.absoluteString == "https://img.example/default.jpg")
    }

    @Test func loadWithoutThumbnailsLeavesURLEmpty() async throws {
        let service = FakeYouTubeService(
            playlistItems: [
                YouTubeDTOFixtures.video(
                    videoID: "abc123",
                    highThumbnailURL: nil,
                    mediumThumbnailURL: nil,
                    defaultThumbnailURL: nil
                )
            ]
        )
        let presenter = WatchPresenter(service: service, router: WatchRouter())

        await presenter.action(.load)

        let video = try #require(presenter.model.videos.first)
        #expect(video.thumbnailURL == nil)
    }

    @Test func loadOnlyFetchesOnce() async {
        let service = FakeYouTubeService(playlistItems: [YouTubeDTOFixtures.video(videoID: "video-1")])
        let presenter = WatchPresenter(service: service, router: WatchRouter())

        await presenter.action(.load)
        await presenter.action(.load)

        #expect(service.requestedChannelIDs.count == 1)
        #expect(service.requestedPlaylistIDs.count == 1)
    }

    @Test func refreshFetchesAgain() async {
        let service = FakeYouTubeService(playlistItems: [YouTubeDTOFixtures.video(videoID: "video-1")])
        let presenter = WatchPresenter(service: service, router: WatchRouter())

        await presenter.action(.load)
        await presenter.action(.refresh)

        #expect(service.requestedChannelIDs.count == 2)
        #expect(service.requestedPlaylistIDs.count == 2)
    }

    @Test func selectVideoUpdatesSelection() async {
        let service = FakeYouTubeService(
            playlistItems: [
                YouTubeDTOFixtures.video(videoID: "video-1"),
                YouTubeDTOFixtures.video(videoID: "video-2")
            ]
        )
        let presenter = WatchPresenter(service: service, router: WatchRouter())
        await presenter.action(.load)

        await presenter.action(.selectVideo(id: "video-2"))

        #expect(presenter.model.selectedVideo?.id == "video-2")
        #expect(presenter.model.hasSelection == true)
    }

    @Test func selectUnknownVideoKeepsCurrentSelection() async {
        let service = FakeYouTubeService(
            playlistItems: [
                YouTubeDTOFixtures.video(videoID: "video-1"),
                YouTubeDTOFixtures.video(videoID: "video-2")
            ]
        )
        let presenter = WatchPresenter(service: service, router: WatchRouter())
        await presenter.action(.load)

        await presenter.action(.selectVideo(id: "unknown-video"))

        #expect(presenter.model.selectedVideo?.id == "video-1")
    }

    @Test func emptyPlaylistLeavesNoSelection() async {
        let service = FakeYouTubeService(playlistItems: [])
        let presenter = WatchPresenter(service: service, router: WatchRouter())

        await presenter.action(.load)

        #expect(presenter.model.videos.isEmpty)
        #expect(presenter.model.selectedVideo == nil)
        #expect(presenter.model.hasSelection == false)
        #expect(presenter.model.errorMessage == nil)
    }

    @Test func channelFailureExposesErrorMessageAndHidesLoading() async {
        let service = FakeYouTubeService()
        service.channelError = YouTubeServiceError.emptyChannel
        let router = WatchRouter()
        let presenter = WatchPresenter(service: service, router: router)

        await presenter.action(.load)

        #expect(presenter.model.videos.isEmpty)
        #expect(presenter.model.selectedVideo == nil)
        #expect(presenter.model.hasSelection == false)
        #expect(presenter.model.errorMessage == YouTubeServiceError.emptyChannel.localizedDescription)
        #expect(router.isLoading == false)
    }

    @Test func playlistFailureExposesErrorMessage() async {
        let service = FakeYouTubeService()
        service.playlistError = YouTubeServiceError.invalidResponse
        let presenter = WatchPresenter(service: service, router: WatchRouter())

        await presenter.action(.load)

        #expect(presenter.model.videos.isEmpty)
        #expect(presenter.model.hasSelection == false)
        #expect(presenter.model.errorMessage == YouTubeServiceError.invalidResponse.localizedDescription)
    }

    @Test func failedRefreshClearsPreviousVideosAndSelection() async {
        let service = FakeYouTubeService(playlistItems: [YouTubeDTOFixtures.video(videoID: "video-1")])
        let presenter = WatchPresenter(service: service, router: WatchRouter())
        await presenter.action(.load)

        service.channelError = YouTubeServiceError.invalidResponse
        await presenter.action(.refresh)

        #expect(presenter.model.videos.isEmpty)
        #expect(presenter.model.selectedVideo == nil)
        #expect(presenter.model.hasSelection == false)
        #expect(presenter.model.errorMessage != nil)
    }
}
