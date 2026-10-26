//
//  WatchPresenter.swift
//  WatcherPlayer
//

import Foundation
import Observation

@MainActor
@Observable
final class WatchPresenter {
    enum Action {
        case load
        case refresh
        case selectVideo(id: String)
    }

    private(set) var model = WatchModel()

    private let service: YouTubeServicing
    private weak var router: WatchRouter?
    private var hasLoaded = false

    init(service: YouTubeServicing = YouTubeService(), router: WatchRouter? = nil) {
        self.service = service
        self.router = router
    }

    func action(_ action: Action) async {
        switch action {
        case .load:
            guard !hasLoaded else { return }
            hasLoaded = true
            await load()
        case .refresh:
            await load()
        case .selectVideo(let id):
            selectVideo(withID: id)
        }
    }
}

private extension WatchPresenter {
    func load() async {
        router?.showLoading()
        model.errorMessage = nil
        defer { router?.hideLoading() }

        do {
            let channel = try await service.fetchChannel(channelID: AppConfiguration.channelID)
            let playlistItems = try await service.fetchPlaylistItems(
                playlistID: channel.contentDetails.relatedPlaylists.uploads
            )
            apply(playlistItems, channelTitle: channel.snippet.title)
        } catch {
            model.videos = []
            model.selectedVideo = nil
            model.hasSelection = false
            model.errorMessage = error.localizedDescription
        }
    }

    func apply(_ playlistItems: [YouTubePlaylistItemDTO], channelTitle: String) {
        let videos = playlistItems.map(makeVideo(from:))

        model.videos = videos
        model.selectedVideo = videos.first
        model.hasSelection = !videos.isEmpty
        router?.setNavigationTitle(channelTitle)
    }

    func selectVideo(withID id: String) {
        guard let video = model.videos.first(where: { $0.id == id }) else { return }
        model.selectedVideo = video
        model.hasSelection = true
    }

    func makeVideo(from item: YouTubePlaylistItemDTO) -> WatchVideo {
        let thumbnails = item.snippet.thumbnails
        let thumbnailURL = thumbnails.high?.url ?? thumbnails.medium?.url ?? thumbnails.default?.url

        return WatchVideo(
            id: item.contentDetails.videoId,
            title: item.snippet.title,
            channelTitle: item.snippet.channelTitle,
            publishedAt: item.snippet.publishedAt,
            thumbnailURL: URL(string: thumbnailURL ?? "")
        )
    }
}
