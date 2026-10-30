//
//  CitySelectionView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

struct CitySelectionView: View {
    let isFrom: Bool
    // Замыкание, которое вернет итоговую строку (Город + Станция)
    let onSelectionComplete: (String) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    // Моковые данные (позже заменим на запрос к API)
    let cities = ["Москва", "Санкт-Петербург", "Сочи", "Горный воздух", "Краснодар", "Казань", "Омск"]
    
    // Фильтрация списка по поиску
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
                    // Заглушка, если ничего не найдено
                    Spacer()
                    Text("Город не найден")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color("YPBlack"))
                    Spacer()
                } else {
                    // Список городов
                    List(filteredCities, id: \.self) { city in
                        NavigationLink(destination: StationSelectionView(city: city, onStationSelected: { station in
                            // Когда станция выбрана, мы возвращаем "Город (Станция)" и закрываем всё окно
                            onSelectionComplete("\(city) (\(station))")
                            dismiss()
                        })) {
                            HStack {
                                Text(city)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle(isFrom ? "Откуда" : "Куда")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("YPBackground").ignoresSafeArea())
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


