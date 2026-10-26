//
//  WatchVideoRow.swift
//  WatcherPlayer
//

import SwiftUI

struct WatchVideoRow: View {
    let video: WatchVideo
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 12) {
            AsyncImage(url: video.thumbnailURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 320, height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Text(video.title)
                .font(.title3)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            Text(video.channelTitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(isSelected ? .white : .clear, lineWidth: 2)
        }
    }
}
