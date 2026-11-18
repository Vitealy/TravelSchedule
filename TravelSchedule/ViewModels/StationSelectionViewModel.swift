//
//  StationSelectionViewModel.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 18.11.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class StationSelectionViewModel {
    
    // MARK: - Public Properties
    var searchText: String = ""
    var stations: [String] = []
    var isLoading: Bool = false
    var error: AppErrorType? = nil
    
    var filteredStations: [String] {
        searchText.isEmpty ? stations : stations.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    private let city: String
    
    init(city: String, networkClient: NetworkClient = try! NetworkClient()) {
        self.city = city
        self.networkClient = networkClient
    }
    
    // MARK: - Actions
    func loadStations() async {
        isLoading = true
        error = nil
        
        do {
            // В будущем здесь мы будем парсить getStationsList() и фильтровать по городу.
            // Пока используем моки для UI, чтобы не грузить 40МБ данных на каждом шаге.
            self.stations = ["Киевский вокзал", "Курский вокзал", "Ярославский вокзал", "Белорусский вокзал", "Савеловский вокзал", "Ленинградский вокзал"]
        } catch {
            self.error = .serverError
        }
        
        isLoading = false
    }
}
