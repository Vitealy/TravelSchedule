//
//  CarriersView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

struct CarriersView: View {
    let fromCity: String
    let toCity: String
    
    // Состояние фильтра
    @State private var filter = FilterState()
    
    // Моковые данные (появятся, когда подключим API)
    // Моковые данные (добавим время в часах для удобной фильтрации)
    let allCarriers: [CarrierMock] = [
        // Утренний рейс
        CarrierMock(name: "РЖД", date: "14 января", departureTime: "08:30", arrivalTime: "12:15", duration: "4 часа", hasTransfers: false, transferText: nil, logoColor: .red, departureHour: 8),
        // Дневной рейс с пересадкой
        CarrierMock(name: "ФГК", date: "15 января", departureTime: "14:15", arrivalTime: "20:00", duration: "6 часов", hasTransfers: true, transferText: "С пересадкой в Костроме", logoColor: .blue, departureHour: 14),
        // Вечерний рейс
        CarrierMock(name: "Урал логистика", date: "16 января", departureTime: "19:30", arrivalTime: "23:00", duration: "3 часа", hasTransfers: false, transferText: nil, logoColor: .orange, departureHour: 19)
    ]
    
    // Отфильтрованный список
    var filteredCarriers: [CarrierMock] {
        allCarriers.filter { carrier in
            // 1. Фильтр по пересадкам
            if let hasTransfersFilter = filter.hasTransfers {
                if carrier.hasTransfers != hasTransfersFilter {
                    return false
                }
            }
            
            // 2. Фильтр по времени
            if !filter.selectedTimes.isEmpty {
                var matchesTime = false
                let hour = carrier.departureHour
                
                if filter.selectedTimes.contains("Утро 06:00 - 12:00") && (6..<12).contains(hour) { matchesTime = true }
                if filter.selectedTimes.contains("День 12:00 - 18:00") && (12..<18).contains(hour) { matchesTime = true }
                if filter.selectedTimes.contains("Вечер 18:00 - 00:00") && (18..<24).contains(hour) { matchesTime = true }
                if filter.selectedTimes.contains("Ночь 00:00 - 06:00") && (0..<6).contains(hour) { matchesTime = true }
                
                if !matchesTime { return false }
            }
            
            return true
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(fromCity) → \(toCity)")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    if filteredCarriers.isEmpty {
                        Text("Вариантов нет")
                            .font(.system(size: 24, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredCarriers) { carrier in
                                NavigationLink(destination: CarrierDetailView(carrierName: carrier.name)) {
                                    CarrierCardView(carrier: carrier)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
            
            // Плавающая кнопка "Уточнить время"
            NavigationLink(destination: FiltersView(filter: $filter)) {
                HStack(spacing: 4) { // Отступ 4 между текстом и кружком
                    Text("Уточнить время")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color("YPBackground"))
                    
                    // ПУНКТ 4: Красный индикатор, если фильтры активны
                    if filter.isActive {
                        Circle()
                            .fill(Color("YPRed"))
                            .frame(width: 8, height: 8)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color("YPBlue"))
                .cornerRadius(16)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar) // Скрываем таббар на внутренних экранах
    }
}

// Отдельная вью для карточки, чтобы код был чище
struct CarrierCardView: View {
    let carrier: CarrierMock
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                // Заглушка логотипа
                RoundedRectangle(cornerRadius: 8)
                    .fill(carrier.logoColor)
                    .frame(width: 38, height: 38)
                
                Text(carrier.name)
                    .font(.system(size: 17, weight: .regular))
                
                if let transferText = carrier.transferText {
                    Text(transferText)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Text(carrier.date)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text(carrier.departureTime)
                    .font(.system(size: 20, weight: .regular))
                
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 1)
                
                Text(carrier.duration)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 1)
                
                Text(carrier.arrivalTime)
                    .font(.system(size: 20, weight: .regular))
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}
