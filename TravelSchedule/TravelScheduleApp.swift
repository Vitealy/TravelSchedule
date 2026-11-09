//
//  TravelScheduleApp.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 06.10.2026.
//

import SwiftUI

@main
struct TravelScheduleApp: App {
    @State private var appSettings = AppSettings()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(appSettings)
                .preferredColorScheme(appSettings.isDarkMode ? .dark : .light)
        }
    }
}
