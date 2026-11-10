//
//  AppSettings.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 08.11.2026.
//

import SwiftUI
import Observation

@Observable
final class AppSettings {
    // По умолчанию берем значение из UserDefaults или ставим светлую
    var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
}
