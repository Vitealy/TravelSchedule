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
    
    func getScheduleBetweenStations(from: String, to: String, date: String? = nil, transfers: Bool = false) async throws -> ScheduleResponse {
        let service = await ScheduleBetweenStationsService(client: client, apikey: apiKey)
        return try await service.getScheduleBetweenStations(from: from, to: to, date: date, transfers: transfers)
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
    
    // MARK: - Парсинг городов и кэширование

    func fetchAllCities() async throws -> [City] {
        // 1. Проверяем, есть ли сохраненный файл с городами
        if let cachedCities = loadCitiesFromCache() {
            print("📦 Города загружены из кэша. Всего: \(cachedCities.count)")
            return cachedCities
        }
        
        // 2. Если кэша нет, качаем из сети (40 МБ)
        print("🌐 Начинаем загрузку списка станций (может занять время)...")
        let response = try await getStationsList()
        
        // 3. Парсим только Россию
        let cities = parseCities(from: response)
        
        // 4. Сохраняем в кэш
        saveCitiesToCache(cities)
        print("✅ Список станций загружен и сохранен. Городов: \(cities.count)")
        
        return cities
    }
    
    private func parseCities(from response: StationsListResponse) -> [City] {
        var parsedCities: [City] = []
        
        // Ищем только Россию
        guard let russia = response.countries?.first(where: { $0.title == "Россия" }) else {
            return []
        }
        
        for region in russia.regions ?? [] {
            for settlement in region.settlements ?? [] {
                // 1. ИГНОРИРУЕМ ПУСТЫЕ НАЗВАНИЯ
                guard let cityName = settlement.title?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !cityName.isEmpty else {
                    continue
                }
                
                var cityStations: [Station] = []
                for stationItem in settlement.stations ?? [] {
                    if let code = stationItem.codes?.yandex_code,
                       let title = stationItem.title,
                       !title.contains("по требованию") {
                        
                        // Добавляем станцию, только если такой еще нет в списке
                        if !cityStations.contains(where: { $0.name == title }) {
                            cityStations.append(Station(name: title, code: code))
                        }
                    }
                }
                
                if !cityStations.isEmpty {
                    let sortedStations = cityStations.sorted { $0.name < $1.name }
                    parsedCities.append(City(name: cityName, stations: sortedStations))
                }
            }
        }
        
        // Убираем дубликаты
        let uniqueCities = Dictionary(grouping: parsedCities, by: { $0.name })
            .compactMap { $0.value.first }
        
        // 2. ПРАВИЛЬНАЯ СОРТИРОВКА
        return uniqueCities.sorted { city1, city2 in
            let isNumber1 = city1.name.first?.isNumber ?? false
            let isNumber2 = city2.name.first?.isNumber ?? false
            
            // Если один начинается с цифры, а другой с буквы, буквы идут первыми
            if isNumber1 != isNumber2 {
                return !isNumber1
            }
            
            // Используем localizedStandardCompare для правильной расстановки буквы "Ё"
            return city1.name.localizedStandardCompare(city2.name) == .orderedAscending
        }
    }
    
    // MARK: - Кэширование (Файловая система)
    
    private var cacheFileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("cached_cities.json")
    }
    
    private func saveCitiesToCache(_ cities: [City]) {
        do {
            let data = try JSONEncoder().encode(cities)
            try data.write(to: cacheFileURL)
        } catch {
            print("❌ Ошибка сохранения кэша: \(error)")
        }
    }
    
    private func loadCitiesFromCache() -> [City]? {
        do {
            let data = try Data(contentsOf: cacheFileURL)
            return try JSONDecoder().decode([City].self, from: data)
        } catch {
            return nil
        }
    }
}
