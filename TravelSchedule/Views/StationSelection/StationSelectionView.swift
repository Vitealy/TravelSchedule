//
//  StationSelectionView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

internal import SwiftUI

struct StationSelectionView: View {
    let city: City
    let onStationSelected: (String, Station) -> Void
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: StationSelectionViewModel
    
    init(city: City, onStationSelected: @escaping (String, Station) -> Void) {
        self.city = city
        self.onStationSelected = onStationSelected
        self._viewModel = State(initialValue: StationSelectionViewModel(city: city.name, stations: city.stations))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $viewModel.searchText)
            
            if viewModel.filteredStations.isEmpty {
                Spacer()
                Text("Станция не найдена")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("YPBlack"))
                Spacer()
            } else {
                List(viewModel.filteredStations) { station in
                    Button(action: {
                        onStationSelected(city.name, station)
                    }) {
                        HStack {
                            Text(station.name)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(Color("YPBlack"))
                            Spacer()
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
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("YPBackground").ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
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
