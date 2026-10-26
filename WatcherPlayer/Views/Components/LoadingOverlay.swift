//
//  LoadingOverlay.swift
//  WatcherPlayer
//

import SwiftUI

struct LoadingOverlay: View {
    let isLoading: Bool

    var body: some View {
        if isLoading {
            ProgressView("Loading videos…")
                .padding(32)
                .glassBackgroundEffect()
                .allowsHitTesting(false)
        }
    }
}
