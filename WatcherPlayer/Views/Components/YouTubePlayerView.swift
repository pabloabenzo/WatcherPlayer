//
//  YouTubePlayerView.swift
//  WatcherPlayer
//

import SwiftUI
import WebKit

struct YouTubePlayerView: UIViewRepresentable {
    let videoID: String

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard context.coordinator.loadedVideoID != videoID else { return }
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(videoID)") else { return }

        context.coordinator.loadedVideoID = videoID
        uiView.load(URLRequest(url: url))
    }

    final class Coordinator {
        var loadedVideoID: String?
    }
}
