//
//  StationsListService.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 13.10.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias StationsListResponse = Components.Schemas.StationsListResponse

protocol StationsListServiceProtocol {
    func getStationsList() async throws -> StationsListResponse
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getStationsList() async throws -> StationsListResponse {
        let response = try await client.getStationsList(query: .init(
            apikey: apikey
        ))
        return try response.ok.body.json
    }
}
