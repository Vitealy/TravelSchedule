//
//  CitySelectionView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

internal import SwiftUI

struct CitySelectionView: View {
    let isFrom: Bool
    let onSelectionComplete: (String) -> Void
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel = CitySelectionViewModel()
    @State private var cityToNavigate: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 50)
                    Spacer()
                } else if viewModel.filteredCities.isEmpty {
                    Spacer()
                    Text("Город не найден")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color("YPBlack"))
                    Spacer()
                } else {
                    List(viewModel.filteredCities, id: \.self) { city in
                        Button(action: { cityToNavigate = city }) {
                            HStack {
                                Text(city).foregroundColor(Color("YPBlack"))
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
            .navigationTitle("Выбор города")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("YPBackground").ignoresSafeArea())
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
            .task {
                await viewModel.loadCities()
            }
        }
    }
}

