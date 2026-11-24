//
//  MainView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

internal import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()
    
    @State private var showingCitySelection = false
    @State private var isSelectingFromCity = true // true = Откуда, false = Куда
    @State private var currentError: AppErrorType? = nil
    
    @State private var selectedStory: Story? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 1. ЛЕНТА STORIES
                StoriesCollectionView(stories: viewModel.stories) { story in
                    selectedStory = story
                }
                .padding(.top, 0)
                .padding(.bottom, 24)
                // 2. СИНЯЯ КАРТОЧКА
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Поле "Откуда"
                        Button(action: {
                            isSelectingFromCity = true
                            showingCitySelection = true
                        }) {
                            Text(viewModel.fromStation == nil
                                 ? "Откуда"
                                 : viewModel.formatDisplayString(city: viewModel.fromCityName, station: viewModel.fromStation))
                                .font(.system(size: 17))
                                .foregroundColor(viewModel.fromCityName.isEmpty ? Color(.ypGray) : Color("YPOnlyBlack"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .contentShape(Rectangle())
                        }
                        
                        Spacer()
                        
                        // Поле "Куда"
                        Button(action: {
                            isSelectingFromCity = false
                            showingCitySelection = true
                        }) {
                            Text(viewModel.toStation == nil
                                 ? "Куда"
                                 : viewModel.formatDisplayString(city: viewModel.toCityName, station: viewModel.toStation))
                                .font(.system(size: 17))
                                .foregroundColor(viewModel.toCityName.isEmpty ? Color(.ypGray) : Color("YPOnlyBlack"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                                .contentShape(Rectangle())
                        }
                    }
                    .frame(height: 96)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.vertical, 16)
                    .padding(.leading, 16)
                    
                    // Кнопка Swap
                    Button(action: viewModel.swapCities) {
                        Image(systemName: "arrow.2.squarepath")
                            .foregroundColor(Color(.ypBlue))
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 16)
                }
                .background(Color(.ypBlue))
                .cornerRadius(20)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // 3. КНОПКА "НАЙТИ"
                if viewModel.isFindButtonVisible {
                    NavigationLink(destination: CarriersView(
                        fromCode: viewModel.fromStation?.code ?? "",
                        toCode: viewModel.toStation?.code ?? "",
                        fromName: viewModel.formatDisplayString(city: viewModel.fromCityName, station: viewModel.fromStation),
                        toName: viewModel.formatDisplayString(city: viewModel.toCityName, station: viewModel.toStation)
                    )) {
                        Text("Найти")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color(.ypBlue))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 112.5)
                    .padding(.top, 16)
                }
                
                Spacer()
                
            }
            .padding(.top, 20)
            .background(Color(.ypBackground).ignoresSafeArea())
            .navigationTitle("")
            .fullScreenCover(isPresented: $showingCitySelection) {
                CitySelectionView(isFrom: isSelectingFromCity) { cityName, station in
                    if isSelectingFromCity {
                        viewModel.fromCityName = cityName
                        viewModel.fromStation = station
                    } else {
                        viewModel.toCityName = cityName
                        viewModel.toStation = station
                    }
                    showingCitySelection = false
                }
            }
            
            .fullScreenCover(item: $selectedStory) { story in
                StoriesView(
                    stories: viewModel.stories,
                    startIndex: viewModel.stories.firstIndex(of: story) ?? 0
                ) { viewedStory in
                    // Находим историю и помечаем ее просмотренной
                    viewModel.markStoryAsViewed(viewedStory)
                }
            }
            .showErrorOverlay(errorType: currentError) {
                currentError = nil
            }
        }
    }
}
