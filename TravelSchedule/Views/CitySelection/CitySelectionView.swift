//
//  CitySelectionView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

struct CitySelectionView: View {
    let isFrom: Bool
    let onSelectionComplete: (String) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    // Состояние для программной навигации
    @State private var cityToNavigate: String?
    
    let cities = ["Москва", "Санкт-Петербург", "Сочи", "Горный воздух", "Краснодар", "Казань", "Омск"]
    
    var filteredCities: [String] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                
                if filteredCities.isEmpty {
                    Spacer()
                    Text("Город не найден")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color("YPBlack"))
                    Spacer()
                } else {
                    List(filteredCities, id: \.self) { city in
                        // Используем Button вместо NavigationLink, чтобы убрать системную серую стрелку
                        Button(action: {
                            cityToNavigate = city // Запускаем навигацию
                        }) {
                            HStack {
                                Text(city)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color("YPBlack"))
                                Spacer()
                                // Наша единственная стрелочка
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Color("YPBlack"))
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Выбор города")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("YPBackground").ignoresSafeArea())
            // Программный переход на экран станции (доступно с iOS 17)
            .navigationDestination(item: $cityToNavigate) { city in
                StationSelectionView(city: city, onStationSelected: { station in
                    onSelectionComplete("\(city) (\(station))")
                    dismiss()
                })
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("YPBlack"))
                    }
                }
            }
        }
    }
}


