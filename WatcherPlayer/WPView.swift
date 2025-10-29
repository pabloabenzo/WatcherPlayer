//
//  WPView.swift
//  WatcherPlayer
//
//  Created by Pablo Benzo on 25/06/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct WPView: View {
    @State var viewModel = WPViewModel()
    
    var body: some View {
        NavigationSplitView {
            List(viewModel.videos?.items ?? [], selection: $viewModel.videoIDs) { video in
                LazyVStack {
                    AsyncImage(url: .init(string: video.snippet.thumbnails.high!.url), scale: 1.0) { image in
                        image.resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                    } placeholder: {
                        ProgressView()
                    }
                    Text(video.snippet.title)
                        .font(.title)
                        .padding(.top, 2)
                }
                .padding()
            }
            .padding()
            .navigationTitle("Eminem")
        } detail: {
            VStack {
                if !viewModel.isVideoIdsEmpty() {
                    VStack {
                        Text(viewModel.getSelectedVideoTitle())
                            .font(.largeTitle)
                            .padding()
                        YouTubeView(videoID: viewModel.getSelectedVideoId())
                            .padding()
                    }
                }
            }
        }
        .ornament(attachmentAnchor: .scene(.bottom)) {
            VStack {
                Text("Suscribe on YouTube App for more content 📺")
            }
            .frame(width: 400, height: 60)
            .glassBackgroundEffect()
        }
    }
}
