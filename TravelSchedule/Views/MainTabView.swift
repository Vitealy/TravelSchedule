//
//  MainTabView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Вкладка 1: Главный экран
            MainView()
                .tabItem {
                    Image(systemName: "arrow.up.message") // Иконка по Figma
                    Text("Главная")
                }
            
            // Вкладка 2: Настройки (заглушка)
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill") // Иконка по Figma
                    Text("Настройки")
                }
        }
        .tint(.blue) // Цвет активной вкладки (можно заменить на кастомный из Figma)
    }
}

#Preview {
    MainTabView()
}
