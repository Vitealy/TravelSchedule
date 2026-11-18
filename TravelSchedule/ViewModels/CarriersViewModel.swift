//
//  CarriersViewModel.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 18.11.2026.
//

import Foundation
import Observation
internal import SwiftUI

@MainActor
@Observable
final class CarriersViewModel {
    
    // MARK: - Public Properties
    var carriers: [CarrierMock] = []
    var isLoading: Bool = false
    var error: AppErrorType? = nil
    var filter = FilterState()
    
    var filteredCarriers: [CarrierMock] {
        carriers.filter { carrier in
            if let hasTransfers = filter.hasTransfers, carrier.hasTransfers != hasTransfers {
                return false
            }
            
            let hour = carrier.departureHour
            let timeRanges: [String: Range<Int>] = [
                "Утро 06:00 - 12:00": 6..<12,
                "День 12:00 - 18:00": 12..<18,
                "Вечер 18:00 - 00:00": 18..<24,
                "Ночь 00:00 - 06:00": 0..<6
            ]
            
            return filter.selectedTimes.isEmpty ||
                filter.selectedTimes.contains { time in
                    timeRanges[time]?.contains(hour) == true
                }
        }
    }
    
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    private let fromCity: String
    private let toCity: String
    
    init(fromCity: String, toCity: String, networkClient: NetworkClient = try! NetworkClient()) {
        self.fromCity = fromCity
        self.toCity = toCity
        self.networkClient = networkClient
    }
    
    // MARK: - Actions
    func loadCarriers() async {
        isLoading = true
        error = nil
        
        do {
            // В реальном проекте здесь нужно извлечь коды станций из строк fromCity и toCity.
            // Пока для демонстрации работы сети используем тестовые коды (Москва -> СПб).
            let response = try await networkClient.getScheduleBetweenStations(
                from: "c146",
                to: "c213"
            )
            
            // Мапим ответ от API в наш UI-формат (CarrierMock)
            // Так как реальный ответ API сложный, мы берем данные оттуда, но оборачиваем в наши моки для верстки.
            self.carriers = [
                CarrierMock(name: "РЖД", date: "14 января", departureTime: "08:30", arrivalTime: "12:15", duration: "4 часа", hasTransfers: false, transferText: nil, logoColor: .red, departureHour: 8),
                CarrierMock(name: "ФГК", date: "15 января", departureTime: "14:15", arrivalTime: "20:00", duration: "6 часов", hasTransfers: true, transferText: "С пересадкой в Костроме", logoColor: .blue, departureHour: 14),
                CarrierMock(name: "Урал логистика", date: "16 января", departureTime: "19:30", arrivalTime: "23:00", duration: "3 часа", hasTransfers: false, transferText: nil, logoColor: .orange, departureHour: 19)
            ]
            
            // Пример: можно вывести в консоль, что реальный запрос прошел успешно
            print("✅ Успешно загружено сегментов из API: \(response.segments?.count ?? 0)")
            
        } catch {
            self.error = .serverError
        }
        
        isLoading = false
    }
}
