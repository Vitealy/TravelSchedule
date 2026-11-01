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
        appearance.backgroundColor = UIColor(Color("YPBackground"))
        // Линия сверху над таббаром
        appearance.shadowColor = UIColor(Color("YPGray").opacity(0.3))
        
        // Цвет невыбранных иконок
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color("YPGray"))
        
        // Цвет выбранной иконки.
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color("YPIcon"))
        
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
        .tint(Color("YPIcon"))
    }
}

#Preview {
    MainTabView()
}
