//
//  FiltersView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var filter: FilterState
    
    // Состояния для фильтров
    @State private var selectedTimes: Set<String> = []
    @State private var hasTransfers: Bool? = nil // nil = не выбрано, true = да, false = нет
    
    let timeOptions = [
        "Утро 06:00 - 12:00",
        "День 12:00 - 18:00",
        "Вечер 18:00 - 00:00",
        "Ночь 00:00 - 06:00"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Время отправления")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top, 16)
                    
                    ForEach(timeOptions, id: \.self) { option in
                        HStack {
                            Text(option)
                                .font(.system(size: 17))
                            Spacer()
                            
                            Button(action: {
                                if filter.selectedTimes.contains(option) {
                                    filter.selectedTimes.remove(option)
                                } else {
                                    filter.selectedTimes.insert(option)
                                }
                            }) {
                                Image(systemName: filter.selectedTimes.contains(option) ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 24))
                                    .foregroundColor(filter.selectedTimes.contains(option) ? Color("YPBlack") : .gray)
                            }
                        }
                    }
                    
                    Text("Показывать варианты с пересадками")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top, 16)
                    
                    HStack {
                        Text("Да").font(.system(size: 17))
                        Spacer()
                        Button(action: { filter.hasTransfers = true }) {
                            Image(systemName: filter.hasTransfers == true ? "largecircle.fill.circle" : "circle")
                                .font(.system(size: 24))
                                .foregroundColor(Color("YPBlack"))
                        }
                    }
                    
                    HStack {
                        Text("Нет").font(.system(size: 17))
                        Spacer()
                        Button(action: { filter.hasTransfers = false }) {
                            Image(systemName: filter.hasTransfers == false ? "largecircle.fill.circle" : "circle")
                                .font(.system(size: 24))
                                .foregroundColor(Color("YPBlack"))
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
            if filter.isActive {
                Button(action: {
                    dismiss()
                }) {
                    Text("Применить")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color("YPBlue"))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.opacity) // Плавное появление
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("YPBackground").ignoresSafeArea())
        .toolbar(.hidden, for: .tabBar)
        
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
