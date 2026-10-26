//
//  YouTubeJSONFixtures.swift
//  WatcherPlayerTests
//

import Foundation

enum YouTubeJSONFixtures {
    static func channelList(
        title: String = "Eminem",
        uploadsPlaylistID: String = "UU-uploads",
        channelCount: Int = 1
    ) throws -> Data {
        let items: [[String: Any]] = (0..<channelCount).map { index in
            [
                "kind": "youtube#channel",
                "etag": "etag",
                "id": "UC-channel-\(index)",
                "snippet": [
                    "title": title,
                    "description": "Description",
                    "publishedAt": "2006-01-01T00:00:00Z",
                    "thumbnails": [
                        "default": [
                            "url": "https://img.example/default.jpg",
                            "width": 88,
                            "height": 88
                        ]
                    ],
                    "localized": [
                        "title": title,
                        "description": "Description"
                    ]
                ] as [String: Any],
                "contentDetails": [
                    "relatedPlaylists": [
                        "uploads": uploadsPlaylistID
                    ]
                ],
                "statistics": [
                    "viewCount": "1",
                    "subscriberCount": "2",
                    "hiddenSubscriberCount": false,
                    "videoCount": "3"
                ]
            ]
        }

        return try json([
            "kind": "youtube#channelListResponse",
            "etag": "etag",
            "pageInfo": [
                "totalResults": items.count,
                "resultsPerPage": 5
            ],
            "items": items
        ])
    }

    static func playlistItems(videoIDs: [String], nextPageToken: String? = nil) throws -> Data {
        let items: [[String: Any]] = videoIDs.map { videoID in
            [
                "id": "playlist-item-\(videoID)",
                "snippet": [
                    "publishedAt": "2025-01-01T00:00:00Z",
                    "channelId": "UC-channel",
                    "title": "Video \(videoID)",
                    "description": "Description",
                    "thumbnails": [
                        "high": [
                            "url": "https://img.example/\(videoID).jpg",
                            "width": 480,
                            "height": 360
                        ]
                    ],
                    "channelTitle": "Eminem",
                    "playlistId": "UU-uploads",
                    "position": 0,
                    "resourceId": [
                        "kind": "youtube#video",
                        "videoId": videoID
                    ]
                ] as [String: Any],
                "contentDetails": [
                    "videoId": videoID,
                    "videoPublishedAt": "2025-01-01T00:00:00Z"
                ]
            ]
        }

        var payload: [String: Any] = [
            "kind": "youtube#playlistItemListResponse",
            "etag": "etag",
            "pageInfo": [
                "totalResults": items.count,
                "resultsPerPage": 50
            ],
            "items": items
        ]
        payload["nextPageToken"] = nextPageToken

        return try json(payload)
    }
}

private extension YouTubeJSONFixtures {
    static func json(_ object: Any) throws -> Data {
        try JSONSerialization.data(withJSONObject: object)
    }
}
