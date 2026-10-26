//
//  WatchView.swift
//  WatcherPlayer
//

import SwiftUI

struct WatchView: View {
    @State private var router: WatchRouter
    @State private var presenter: WatchPresenter

    init() {
        let router = WatchRouter()
        _router = State(initialValue: router)
        _presenter = State(initialValue: WatchPresenter(router: router))
    }

    var body: some View {
        NavigationSplitView {
            ScrollView {
                if presenter.model.videos.isEmpty {
                    ContentUnavailableView(
                        "No videos",
                        systemImage: "film.stack",
                        description: Text(
                            presenter.model.errorMessage ?? "Choose refresh to load the channel videos again."
                        )
                    )
                    .padding()
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(presenter.model.videos) { video in
                            Button {
                                Task { await presenter.action(.selectVideo(id: video.id)) }
                            } label: {
                                WatchVideoRow(
                                    video: video,
                                    isSelected: video.id == presenter.model.selectedVideo?.id
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(router.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        Task { await presenter.action(.refresh) }
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
            }
        } detail: {
            VStack(spacing: 16) {
                if presenter.model.hasSelection {
                    Text(presenter.model.selectedVideo?.title ?? "")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    YouTubePlayerView(videoID: presenter.model.selectedVideo?.id ?? "")
                        .aspectRatio(16.0 / 9.0, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .padding(.horizontal)
                } else {
                    ContentUnavailableView(
                        "No video selected",
                        systemImage: "play.rectangle",
                        description: Text(
                            presenter.model.errorMessage ?? "Select a video from the list to start watching."
                        )
                    )
                }
            }
        }
        .task {
            await presenter.action(.load)
        }
        .overlay {
            LoadingOverlay(isLoading: router.isLoading)
        }
        .ornament(attachmentAnchor: .scene(.bottom)) {
            Text("Subscribe on YouTube for more content 📺")
                .padding()
                .frame(width: 400, height: 60)
                .glassBackgroundEffect()
        }
    }
}
