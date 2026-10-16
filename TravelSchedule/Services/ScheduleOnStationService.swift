//
//  ScheduleOnStationService.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 13.10.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleOnStationResponse = Components.Schemas.ScheduleOnStationResponse

protocol ScheduleOnStationServiceProtocol {
    func getScheduleOnStation(
        station: String,
        date: String?,
        transportTypes: String?,
        direction: String?
    ) async throws -> ScheduleOnStationResponse
}

final class ScheduleOnStationService: ScheduleOnStationServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleOnStation(
        station: String,
        date: String? = nil,
        transportTypes: String? = nil,
        direction: String? = nil
    ) async throws -> ScheduleOnStationResponse {
        let response = try await client.getScheduleOnStation(query: .init(
            apikey: apikey,
            station: station,
            date: date,
            transport_types: transportTypes,
            direction: direction
        ))
        return try response.ok.body.json
    }
}
