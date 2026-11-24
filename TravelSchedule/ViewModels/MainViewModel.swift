//
//  MainViewModel.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 18.11.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MainViewModel {
    var fromCityName: String = ""
    var fromStation: Station? = nil
    var toCityName: String = ""
    var toStation: Station? = nil
    var stories: [Story] = Story.mockStories
    
    // Вычисляемое свойство: показывать ли кнопку "Найти"
    var isFindButtonVisible: Bool {
        fromStation != nil && toStation != nil
    }
    
    // Логика смены городов местами
    func swapCities() {
        swap(&fromCityName, &toCityName)
        swap(&fromStation, &toStation)
    }
    
    // Обновление статуса просмотренной истории
    func markStoryAsViewed(_ viewedStory: Story) {
        if let index = stories.firstIndex(where: { $0.id == viewedStory.id }) {
            stories[index].isViewed = true
        }
    }
    
    // Вспомогательный метод: формирует строку "Город (Станция)"
    func formatDisplayString(city: String, station: Station?) -> String {
        guard let station = station else { return "" }
        let stationName = station.name
        
        // Если название станции полностью совпадает с городом
        if stationName.lowercased() == city.lowercased() {
            return city
        }
        
        // Если название станции УЖЕ содержит город
        if stationName.lowercased().contains(city.lowercased()) {
            return stationName
        }
        
        // Если станция не содержит город, оборачиваем
        return "\(city) (\(stationName))"
    }
}
