//
//  ThreadStationsService.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 13.10.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias ThreadResponse = Components.Schemas.ThreadResponse

protocol ThreadStationsServiceProtocol {
    func getThreadStations(uid: String, date: String?) async throws -> ThreadResponse
}

final class ThreadStationsService: ThreadStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getThreadStations(uid: String, date: String? = nil) async throws -> ThreadResponse {
        let response = try await client.getThreadStations(query: .init(
            apikey: apikey,
            uid: uid,
            date: date
        ))
        return try response.ok.body.json
    }
}
