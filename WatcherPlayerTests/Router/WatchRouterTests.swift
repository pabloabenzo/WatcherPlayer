//
//  WatchRouterTests.swift
//  WatcherPlayerTests
//

import Testing
@testable import WatcherPlayer

@MainActor
struct WatchRouterTests {
    @Test func startsNotLoadingAndWithDefaultTitle() {
        let router = WatchRouter()

        #expect(router.isLoading == false)
        #expect(router.navigationTitle == "WatcherPlayer")
    }

    @Test func showLoadingTurnsLoadingOn() {
        let router = WatchRouter()

        router.showLoading()

        #expect(router.isLoading == true)
    }

    @Test func hideLoadingTurnsLoadingOff() {
        let router = WatchRouter()
        router.showLoading()

        router.hideLoading()

        #expect(router.isLoading == false)
    }

    @Test func setNavigationTitleUpdatesTitle() {
        let router = WatchRouter()

        router.setNavigationTitle("Eminem")

        #expect(router.navigationTitle == "Eminem")
    }

    @Test func setNavigationTitleIgnoresEmptyTitle() {
        let router = WatchRouter()
        router.setNavigationTitle("Eminem")

        router.setNavigationTitle("")

        #expect(router.navigationTitle == "Eminem")
    }
}
