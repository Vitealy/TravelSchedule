//
//  CitySelectionViewModel.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 18.11.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class CitySelectionViewModel {
    
    // MARK: - Public Properties (для View)
    var searchText: String = ""
    var cities: [String] = []
    var isLoading: Bool = false
    var error: AppErrorType? = nil
    
    // Вычисляемые данные для списка
    var filteredCities: [String] {
        searchText.isEmpty ? cities : cities.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = try! NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - Actions
    func loadCities() async {
        isLoading = true
        error = nil
        
        do {
            // В идеале тут нужно использовать getStationsList и парсить города
            // Для примера используем моки, чтобы не грузить 40 МБ при каждом запуске
            let mockCities = ["Москва", "Санкт-Петербург", "Сочи", "Горный воздух", "Краснодар", "Казань", "Омск"]
            self.cities = mockCities
            
            // ЗАКОММЕНТИРОВАННЫЙ ПРИМЕР С СЕТЬЮ:
            // let response = try await networkClient.getStationsList()
            // self.cities = parseCities(from: response)
            
        } catch {
            self.error = .serverError // Твой Enum ошибки
        }
        
        isLoading = false
    }
}
