//
//  StationSelectionView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

internal import SwiftUI

struct StationSelectionView: View {
    let city: String
    let onStationSelected: (String) -> Void
    @Environment(\.dismiss) var dismiss
    
    // Используем нашу ViewModel
    @State private var viewModel: StationSelectionViewModel
    
    // Инициализируем ViewModel с городом
    init(city: String, onStationSelected: @escaping (String) -> Void) {
        self.city = city
        self.onStationSelected = onStationSelected
        self._viewModel = State(initialValue: StationSelectionViewModel(city: city))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $viewModel.searchText)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 50)
                Spacer()
            } else if viewModel.filteredStations.isEmpty {
                Spacer()
                Text("Станция не найдена")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("YPBlack"))
                Spacer()
            } else {
                List(viewModel.filteredStations, id: \.self) { station in
                    Button(action: {
                        onStationSelected(station)
                    }) {
                        HStack {
                            Text(station)
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
        .task {
            await viewModel.loadStations()
        }
    }
}
