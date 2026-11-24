//
//  LocationModels.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 19.11.2026.
//

import Foundation

// Удобная модель для города
struct City: Identifiable, Hashable, Sendable, Codable {
    var id: String { name } // Используем имя как ID
    let name: String
    let stations: [Station]
}

// Удобная модель для станции (вокзала)
struct Station: Identifiable, Hashable, Sendable, Codable {
    var id: String { code } // Используем код как ID
    let name: String
    let code: String
}
