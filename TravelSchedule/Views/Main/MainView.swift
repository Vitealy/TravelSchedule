//
//  MainView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

struct MainView: View {
    // Состояние: выбранные города
    @State private var fromCity: String = ""
    @State private var toCity: String = ""
    
    // Состояние для открытия экрана выбора города
    @State private var showingCitySelection = false
    @State private var isSelectingFromCity = true // true = Откуда, false = Куда
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Поле "Откуда"
                        Button(action: {
                            isSelectingFromCity = true
                            showingCitySelection = true
                        }) {
                            Text(fromCity.isEmpty ? "Откуда" : fromCity)
                                .font(.system(size: 17))
                                .foregroundColor(fromCity.isEmpty ? Color("YPGray") : Color("YPBlack")) // Серый цвет из ассетов (пункт 3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16) // Отступ внутри белого прямоугольника
                                .padding(.top, 16)
                        }
                        
                        Spacer()
                        
                        // Поле "Куда"
                        Button(action: {
                            isSelectingFromCity = false
                            showingCitySelection = true
                        }) {
                            Text(toCity.isEmpty ? "Куда" : toCity)
                                .font(.system(size: 17))
                                .foregroundColor(toCity.isEmpty ? Color("YPGray") : Color("YPBlack"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                        }
                    }
                    .frame(height: 96)
                    .background(Color("YPBackground")) // Белый фон
                    .cornerRadius(20)
                    .padding(.vertical, 16) // Отступ сверху и снизу внутри синего
                    .padding(.leading, 16) // Отступ слева внутри синего
                    
                    // Кнопка Swap
                    Button(action: swapCities) {
                            Image(systemName: "arrow.2.squarepath")
                                .foregroundColor(Color("YPBlue"))
                                .padding()
                                .background(Color("YPBackground"))
                                .clipShape(Circle())
                    }
                    .padding(.trailing, 16) // Отступ справа
                }
                .background(Color("YPBlue"))
                .cornerRadius(20)
                .padding(.horizontal, 16) // Отступы синего прямоугольника от краев экрана
                .padding(.top, 16)
                
                // Кнопка "Найти"
                if !fromCity.isEmpty && !toCity.isEmpty {
                    NavigationLink(destination: CarriersView(fromCity: fromCity, toCity: toCity)) {
                        Text("Найти")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color("YPBackground"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color("YPBlue"))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 112.5)
                }
                
                Spacer()
            }
            .background(Color("YPBackground").ignoresSafeArea())
            .navigationTitle("")
            .fullScreenCover(isPresented: $showingCitySelection) {
                CitySelectionView(isFrom: isSelectingFromCity) { selectedCity in
                    if isSelectingFromCity {
                        fromCity = selectedCity
                    } else {
                        toCity = selectedCity
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
