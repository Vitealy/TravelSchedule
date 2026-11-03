//
//  FilterState.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 30.10.2026.
//

import Foundation

struct FilterState {
    // Выбранные периоды времени
    var selectedTimes: Set<String> = []
    // Пересадки: nil = не важно, true = только с пересадками, false = только без пересадок
    var hasTransfers: Bool? = nil
    
    // Проверка, активны ли вообще какие-то фильтры (для логики)
    var isActive: Bool {
        !selectedTimes.isEmpty || hasTransfers != nil
    }
}
