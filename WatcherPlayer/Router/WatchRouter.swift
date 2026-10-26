//
//  WatchRouter.swift
//  WatcherPlayer
//

import Foundation
import Observation

@MainActor
@Observable
final class WatchRouter {
    var navigationTitle: String = "WatcherPlayer"
    var isLoading: Bool = false

    func showLoading() {
        isLoading = true
    }

    func hideLoading() {
        isLoading = false
    }

    func setNavigationTitle(_ title: String) {
        guard !title.isEmpty else { return }
        navigationTitle = title
    }
}
