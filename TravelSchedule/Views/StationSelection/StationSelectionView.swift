//
//  StationSelectionView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

struct StationSelectionView: View {
    let city: String
    let onStationSelected: (String) -> Void
    
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    // Моковые станции (для примера)
    let stations = ["Киевский вокзал", "Курский вокзал", "Ярославский вокзал", "Белорусский вокзал", "Савеловский вокзал", "Ленинградский вокзал"]
    
    var filteredStations: [String] {
        searchText.isEmpty ? stations : stations.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $searchText)
            
            if filteredStations.isEmpty {
                Spacer()
                Text("Станция не найдена")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.ypBlack))
                Spacer()
            } else {
                List(filteredStations, id: \.self) { station in
                    Button(action: {
                        onStationSelected(station)
                    }) {
                        HStack {
                            Text(station)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(Color(.ypBlack))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color(.ypBlack))
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
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
        // Кастомная кнопка "Назад" (свайп назад тоже будет работать)
        .background(Color(.ypBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        // 2. Добавляем свою кастомную стрелочку
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Закрываем текущий экран и возвращаемся к списку городов
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(.ypBlack))
                }
            }
        }
    }
}
