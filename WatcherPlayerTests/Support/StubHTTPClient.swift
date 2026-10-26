//
//  StubHTTPClient.swift
//  WatcherPlayerTests
//

import Foundation
@testable import WatcherPlayer

struct StubResponse {
    let data: Data
    let statusCode: Int

    init(data: Data, statusCode: Int = 200) {
        self.data = data
        self.statusCode = statusCode
    }
}

@MainActor
final class StubHTTPClient: HTTPClient {
    var responses: [StubResponse]
    var error: Error?
    private(set) var requestedURLs: [URL] = []

    init(responses: [StubResponse] = []) {
        self.responses = responses
    }

    func data(from url: URL) async throws -> (Data, HTTPURLResponse) {
        requestedURLs.append(url)

        if let error {
            throw error
        }

        guard !responses.isEmpty else {
            throw URLError(.badServerResponse)
        }

        let stub = responses.removeFirst()
        guard let response = HTTPURLResponse(
            url: url,
            statusCode: stub.statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        ) else {
            throw URLError(.badServerResponse)
        }

        return (stub.data, response)
    }
}
