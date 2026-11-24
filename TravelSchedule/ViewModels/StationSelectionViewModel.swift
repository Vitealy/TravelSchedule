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
    var stations: [Station] = []
    
    var filteredStations: [Station] {
        searchText.isEmpty ? stations : stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    // MARK: - Dependencies
    
    init(city: String, stations: [Station]) {
        self.stations = stations
    }
}
