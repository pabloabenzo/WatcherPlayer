//
//  WPViewModel.swift
//  WatcherPlayer
//
//  Created by Pablo Benzo on 25/06/2025.
//

import Foundation
import Observation

@Observable
class WPViewModel {
    var channel: ChannelListResponse?
    var channelID = "UCfM3zsQsOnfWNUppiycmBuw"
    var playlistID: String = ""
    var videos: PlaylistItemsResponse?
    let youTubeAPIKey = "AIzaSyAQ7wFWpG10Q4bjZPBlo30nm5XFpffeDLY"
    var videoIDs: Set<String> = []
    
    init() {
        getVideos()
    }
    
    func getVideos() {
        Task {
            do {
                guard let url = URL(string: "https://www.googleapis.com/youtube/v3/channels?part=snippet,contentDetails,statistics&id=\(channelID)&key=\(youTubeAPIKey)") else { return }
                let (data, _) = try await URLSession.shared.data(from: url)
                channel = try JSONDecoder().decode(ChannelListResponse.self, from: data)
                playlistID = channel?.items.first?.contentDetails.relatedPlaylists.uploads ?? ""
                if playlistID != "" {
                    let playlistURL = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails&playlistId=\(playlistID)&key=\(youTubeAPIKey)"
                    guard let url = URL(string: playlistURL) else { return }
                    let (data, _) = try await URLSession.shared.data(from: url)
                    videos = try JSONDecoder().decode(PlaylistItemsResponse.self, from: data)
                    while let _ = videos?.nextPageToken {
                        let playlistURL = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails&playlistId=\(playlistID)&maxResults=50&pageToken=\(videos!.nextPageToken!)&key=\(youTubeAPIKey)"
                        guard let url = URL(string: playlistURL) else { return }
                        let (data, _) = try await URLSession.shared.data(from: url)
                        videos = try JSONDecoder().decode(PlaylistItemsResponse.self, from: data)
                        if let items = videos?.items {
                            videoIDs = Set(items.map { $0.contentDetails.videoId })
                        }
                    }
                }
            } catch {
                print("❌ Error: \(error)")
                videos = nil
            }
        }
    }
    
// MARK: - WKWebView
    
    func isVideoIdsEmpty() -> Bool {
        videoIDs.isEmpty
    }
    
    func getSelectedVideoId() -> String {
        videos?.items.first(where: { $0.id == videoIDs.first })?.contentDetails.videoId ?? "YVkUvmDQ3HY&list=RDEMASZzAB4N6PSfsOwzAhxYyQ&start_radio=1"
    }
    
    func getSelectedVideoTitle() -> String {
        videos?.items.first(where: { $0.id == videoIDs.first })?.snippet.title ?? "Eminem Radio"
    }
    
}
