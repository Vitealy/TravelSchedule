//
//  MainTabView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

struct MainTabView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        // Фон таббара
        appearance.backgroundColor = UIColor(Color(.ypBackground))
        // Линия сверху над таббаром
        appearance.shadowColor = UIColor(Color(.ypGray).opacity(0.3))
        
        // Цвет невыбранных иконок
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color(.ypGray))
        
        // Цвет выбранной иконки.
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color(.ypIcon))
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            // Вкладка 1: Главный экран
            MainView()
                .tabItem {
                    Image(systemName: "arrow.up.message")
                }
            // Вкладка 2: Настройки
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }
        }
        .tint(Color(.ypIcon))
    }
}

#Preview {
    MainTabView()
}
