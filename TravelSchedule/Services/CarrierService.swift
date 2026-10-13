//
//  CarrierService.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 13.10.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrierInfo(code: String, system: String?) async throws -> CarrierResponse
}

final class CarrierService: CarrierServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCarrierInfo(code: String, system: String? = nil) async throws -> CarrierResponse {
        let response = try await client.getCarrierInfo(query: .init(
            apikey: apikey,
            code: code,
            system: system
        ))
        return try response.ok.body.json
    }
}
