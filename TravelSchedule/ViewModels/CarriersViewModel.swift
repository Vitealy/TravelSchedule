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
            return filter.selectedTimes.isEmpty || filter.selectedTimes.contains { time in
                timeRanges[time]?.contains(hour) == true
            }
        }
    }
    
    // MARK: - Dependencies
    
    private let networkClient: NetworkClient
    private let fromCode: String
    private let toCode: String
    
    init(fromCode: String, toCode: String, networkClient: NetworkClient = try! NetworkClient()) {
        self.fromCode = fromCode
        self.toCode = toCode
        self.networkClient = networkClient
    }
    
    // MARK: - Actions
    
    func loadCarriers() async {
        isLoading = true
        error = nil
        
        do {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            let dateString = formatter.string(from: tomorrow)
            
            // ЗАПРАШИВАЕМ РЕЙСЫ С ПЕРЕСАДКАМИ
            let response = try await networkClient.getScheduleBetweenStations(
                from: fromCode,
                to: toCode,
                date: dateString,
                transfers: true
            )
            
            let segments = response.segments ?? []
            self.carriers = segments.compactMap { segment in
                mapToCarrierMock(segment: segment)
            }.sorted { $0.departureTime < $1.departureTime }
            
        } catch {
            print("❌ Ошибка загрузки рейсов: \(error)")
            self.error = .serverError
        }
        
        isLoading = false
    }
    
    private func mapToCarrierMock(segment: Components.Schemas.Segment) -> CarrierMock? {
        guard let thread = segment.thread,
              let departureStr = segment.departure,
              let arrivalStr = segment.arrival else {
            return nil
        }
        
        let carrierName = thread.carrier?.title ?? "Неизвестный перевозчик"
        let carrierCode = thread.carrier?.code != nil ? String(thread.carrier!.code!) : nil
        
        let logoURL = thread.carrier?.logo
        
        let isoFormatter = ISO8601DateFormatter()
        
        guard let departureDate = isoFormatter.date(from: departureStr),
              let arrivalDate = isoFormatter.date(from: arrivalStr) else {
            return nil
        }
        
        // Форматируем время (HH:mm)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let departureTime = timeFormatter.string(from: departureDate)
        let arrivalTime = timeFormatter.string(from: arrivalDate)
        
        // Форматируем дату (d MMMM, например "20 ноября")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM"
        let dateString = dateFormatter.string(from: departureDate)
        
        // Считаем время в пути
        let durationInSeconds = arrivalDate.timeIntervalSince(departureDate)
        let hours = Int(durationInSeconds) / 3600
        let minutes = (Int(durationInSeconds) % 3600) / 60
        let durationString = hours > 0 ? "\(hours) ч \(minutes) мин" : "\(minutes) мин"
        
        // Час отправления для фильтра
        let calendar = Calendar.current
        let departureHour = calendar.component(.hour, from: departureDate)
        
        // Проверяем пересадки
        let hasTransfers = !(segment.transfers?.isEmpty ?? true)
        let transferText: String? = hasTransfers ? "С пересадкой" : nil
        
        return CarrierMock(
            name: carrierName,
            date: dateString,
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            duration: durationString,
            hasTransfers: hasTransfers,
            transferText: transferText,
            logoURL: logoURL,
            logoColor: .red,
            departureHour: departureHour,
            carrierCode: carrierCode
        )
    }
}
