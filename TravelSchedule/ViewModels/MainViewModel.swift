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
    var fromCity: String = ""
    var toCity: String = ""
    var stories: [Story] = Story.mockStories
    
    // Вычисляемое свойство: показывать ли кнопку "Найти"
    var isFindButtonVisible: Bool {
        !fromCity.isEmpty && !toCity.isEmpty
    }
    
    // Логика смены городов местами
    func swapCities() {
        let temp = fromCity
        fromCity = toCity
        toCity = temp
    }
    
    // Обновление статуса просмотренной истории
    func markStoryAsViewed(_ viewedStory: Story) {
        if let index = stories.firstIndex(where: { $0.id == viewedStory.id }) {
            stories[index].isViewed = true
        }
    }
}
