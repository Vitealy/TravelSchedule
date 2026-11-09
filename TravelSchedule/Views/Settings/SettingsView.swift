//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppSettings.self) var appSettings
    
    var body: some View {
        @Bindable var settings = appSettings
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                // Переключатель темы
                HStack {
                    Text("Тёмная тема")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(.ypBlack))
                    Spacer()
                    Toggle("", isOn: $settings.isDarkMode)
                        .tint(Color(.ypBlue))
                        .labelsHidden()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .padding(.top, 24)
                
                // Переход к соглашению
                NavigationLink(destination: UserAgreementView()) {
                    HStack {
                        Text("Пользовательское соглашение")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color(.ypBlack))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(.ypBlack))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                }
                
                Spacer()
                
                // Футер с версией
                VStack(spacing: 4) {
                    Text("Приложение использует API «Яндекс.Расписания»")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(.ypBlack))
                        .padding(.bottom, 16)
                    Text("Версия 1.0 (beta)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(.ypBlack))
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.ypBackground).ignoresSafeArea())
        }
    }
}

#Preview {
    SettingsView()
}
