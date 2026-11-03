//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Экран настроек (в разработке)")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(.ypBlack))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color(.ypBackground).ignoresSafeArea())
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
