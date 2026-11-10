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
    @State private var currentError: AppErrorType? = nil
    
    // Данные для Stories
    @State private var stories: [Story] = Story.mockStories
    @State private var selectedStory: Story? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 1. ЛЕНТА STORIES
                StoriesCollectionView(stories: stories) { story in
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
                            Text(fromCity.isEmpty ? "Откуда" : fromCity)
                                .font(.system(size: 17))
                                .foregroundColor(fromCity.isEmpty ? Color(.ypGray) : Color.black)
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
                            Text(toCity.isEmpty ? "Куда" : toCity)
                                .font(.system(size: 17))
                                .foregroundColor(toCity.isEmpty ? Color(.ypGray) : Color.black)
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
                    Button(action: swapCities) {
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
                if !fromCity.isEmpty && !toCity.isEmpty {
                    NavigationLink(destination: CarriersView(fromCity: fromCity, toCity: toCity)) {
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
                
                // ВРЕМЕННЫЕ КНОПКИ ДЛЯ ПРОВЕРКИ Экранов Ошибки
                HStack(spacing: 16) {
                    Button("Нет интернета") {
                        currentError = .noInternet
                    }
                    .foregroundColor(.red)
                    
                    Button("Ошибка сервера") {
                        currentError = .serverError
                    }
                    .foregroundColor(.red)
                }
                .padding(.bottom, 20)
                
            }
            .padding(.top, 20)
            .background(Color(.ypBackground).ignoresSafeArea())
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
            
            .fullScreenCover(item: $selectedStory) { story in
                StoriesView(
                    stories: stories,
                    startIndex: stories.firstIndex(of: story) ?? 0
                ) { viewedStory in
                    // Находим историю и помечаем ее просмотренной
                    if let index = stories.firstIndex(where: { $0.id == viewedStory.id }) {
                        stories[index].isViewed = true
                    }
                }
            }
            .showErrorOverlay(errorType: currentError) {
                currentError = nil
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
