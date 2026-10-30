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
    
    // Моковые станции (для примера)
    let stations = ["Киевский вокзал", "Курский вокзал", "Ярославский вокзал", "Белорусский вокзал", "Савеловский вокзал", "Ленинградский вокзал"]
    
    var filteredStations: [String] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $searchText)
            
            if filteredStations.isEmpty {
                Spacer()
                Text("Станция не найдена")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            } else {
                List(filteredStations, id: \.self) { station in
                    Button(action: {
                        onStationSelected(station)
                    }) {
                        HStack {
                            Text(station)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(Color("YPBlack"))
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
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
        // Кастомная кнопка "Назад" (свайп назад тоже будет работать)
        .background(Color("YPBackground").ignoresSafeArea())
    }
}
