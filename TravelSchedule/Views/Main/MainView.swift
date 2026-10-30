//
//  MainView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

struct MainView: View {
    // Состояние: выбранные города (пока строки, позже заменим на модели)
    @State private var fromCity: String = ""
    @State private var toCity: String = ""
    
    // Состояние для открытия экрана выбора города
    @State private var showingCitySelection = false
    @State private var isSelectingFromCity = true // true = Откуда, false = Куда
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // 1. Плашка с выбором городов
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("YPBlue"))
                        .frame(height: 128)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 20) {
                            // Поле "Откуда"
                            Button(action: {
                                isSelectingFromCity = true
                                showingCitySelection = true
                            }) {
                                Text(fromCity.isEmpty ? "Откуда" : fromCity)
                                    .foregroundColor(fromCity.isEmpty ? .white.opacity(0.5) : .white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Поле "Куда"
                            Button(action: {
                                isSelectingFromCity = false
                                showingCitySelection = true
                            }) {
                                Text(toCity.isEmpty ? "Куда" : toCity)
                                    .foregroundColor(toCity.isEmpty ? .white.opacity(0.5) : .white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.leading, 16)
                        
                        // Кнопка смены направления (Swap)
                        Button(action: swapCities) {
                            Image(systemName: "arrow.left.arrow.right")
                                .foregroundColor(Color("YPBlue"))
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 16)
                    }
                }
                
                // 2. Кнопка "Найти" (появляется только если оба поля заполнены)
                if !fromCity.isEmpty && !toCity.isEmpty {
                    NavigationLink(destination: CarriersView(fromCity: fromCity, toCity: toCity)) {
                        Text("Найти")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color("YPBlue"))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 16)
                }
                
                Spacer() // Прижимает контент к верху
            }
            .padding(.top, 20)
            .navigationTitle("") // Убираем заголовок, как в макете
            .background(Color("YPBackground").ignoresSafeArea())
            
            // 3. Полноэкранный показ выбора города (перекрывает TabBar)
            .fullScreenCover(isPresented: $showingCitySelection) {
                CitySelectionView(isFrom: isSelectingFromCity) { selectionResult in
                    if isSelectingFromCity {
                        fromCity = selectionResult // Сюда придет "Москва (Курский вокзал)"
                    } else {
                        toCity = selectionResult
                    }
                    showingCitySelection = false
                }
            }
        }
    }
    
    // Логика смены городов местами
    private func swapCities() {
        let temp = fromCity
        fromCity = toCity
        toCity = temp
    }
}

#Preview {
    MainView()
}
