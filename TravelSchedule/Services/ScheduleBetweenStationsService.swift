//
//  ScheduleBetweenStationsService.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 13.10.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleResponse = Components.Schemas.ScheduleResponse

protocol ScheduleBetweenStationsServiceProtocol {
    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String?,
        transportTypes: String?,
        transfers: Bool?
    ) async throws -> ScheduleResponse
}

final class ScheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String? = nil,
        transportTypes: String? = nil,
        transfers: Bool? = nil
    ) async throws -> ScheduleResponse {
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: date,
            transport_types: transportTypes,
            transfers: transfers
        ))
        return try response.ok.body.json
    }
}
