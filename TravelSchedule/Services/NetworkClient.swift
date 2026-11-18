//
//  NetworkClient.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 18.11.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

/// Сетевой клиент-актор для безопасного выполнения запросов.
/// Инкапсулирует в себе OpenAPI Client и все сервисы.
actor NetworkClient {
    private let client: Client
    private let apiKey: String
    
    init() throws {
        self.client = Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        self.apiKey = AppConfig.yandexRaspAPIKey
    }
    
    // MARK: - Сервисы
    func getNearestSettlement(lat: Double, lng: Double, distance: Int? = nil) async throws -> Settlement {
        let service = await NearestSettlementService(client: client, apikey: apiKey)
        return try await service.getNearestSettlement(lat: lat, lng: lng, distance: distance)
    }
    
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        let service = await NearestStationsService(client: client, apikey: apiKey)
        return try await service.getNearestStations(lat: lat, lng: lng, distance: distance)
    }
    
    func getScheduleBetweenStations(from: String, to: String, date: String? = nil) async throws -> ScheduleResponse {
        let service = await ScheduleBetweenStationsService(client: client, apikey: apiKey)
        return try await service.getScheduleBetweenStations(from: from, to: to, date: date)
    }
    
    func getScheduleOnStation(station: String, date: String? = nil) async throws -> ScheduleOnStationResponse {
        let service = await ScheduleOnStationService(client: client, apikey: apiKey)
        return try await service.getScheduleOnStation(station: station, date: date)
    }
    
    func getStationsList() async throws -> StationsListResponse {
        let service = await StationsListService(client: client, apikey: apiKey)
        return try await service.getStationsList()
    }
    
    func getCarrierInfo(code: String) async throws -> CarrierResponse {
        let service = await CarrierService(client: client, apikey: apiKey)
        return try await service.getCarrierInfo(code: code, system: "yandex")
    }
    
    func getThreadStations(uid: String) async throws -> ThreadResponse {
        let service = await ThreadStationsService(client: client, apikey: apiKey)
        return try await service.getThreadStations(uid: uid)
    }
    
    func getCopyright() async throws -> Copyright {
        let service = await CopyrightService(client: client, apikey: apiKey)
        return try await service.getCopyright()
    }
}
