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
    var cities: [City] = []
    var isLoading: Bool = false
    var error: AppErrorType? = nil
    
    // Вычисляемые данные для списка
    var filteredCities: [City] {
        searchText.isEmpty ? cities : cities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
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
            self.cities = try await networkClient.fetchAllCities()
        } catch {
            self.error = .serverError
        }
        isLoading = false
    }
}
