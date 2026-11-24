//
//  CarriersView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

internal import SwiftUI

struct CarriersView: View {
    let fromCode: String
    let toCode: String
    let fromName: String
    let toName: String
    
    @State private var viewModel: CarriersViewModel
    
    init(fromCode: String, toCode: String, fromName: String, toName: String) {
        self.fromCode = fromCode
        self.toCode = toCode
        self.fromName = fromName
        self.toName = toName
        self._viewModel = State(initialValue: CarriersViewModel(fromCode: fromCode, toCode: toCode))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color("YPBackground").ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                ErrorView(errorType: error) {
                    Task { await viewModel.loadCarriers() }
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Используем переданные имена
                        Text("\(fromName) → \(toName)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color("YPBlack"))
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        
                        if viewModel.filteredCarriers.isEmpty {
                            Text("Вариантов нет")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color("YPBlack"))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 100)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredCarriers) { carrier in
                                    // Передаем название перевозчика в детали
                                    NavigationLink(destination: CarrierDetailView(carrierCode: carrier.carrierCode ?? "")) {
                                        CarrierCardView(carrier: carrier)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 100)
                        }
                    }
                }
                
                // Кнопка фильтров
                NavigationLink(destination: FiltersView(filter: $viewModel.filter)) {
                    HStack(spacing: 4) {
                        Text("Уточнить время")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                        
                        if viewModel.filter.isActive {
                            Circle()
                                .fill(Color("YPRed"))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color("YPBlue"))
                    .clipShape(.rect(cornerRadius: 16))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.loadCarriers()
        }
    }
}

private struct CarrierCardView: View {
    let carrier: CarrierMock
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                // Умная загрузка логотипа
                let name = carrier.name.lowercased()
                let localImageName: String? = {
                    if name.contains("ржд") || name.contains("фпк") { return "RR" }
                    if name.contains("урал") { return "UL" }
                    if name.contains("фгк") { return "FGK" }
                    return nil
                }()
                
                if let imageName = localImageName {
                    // Если есть локальная картинка из Assets
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38, height: 38)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    // Заглушка для остальных перевозчиков
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("YPBackground"))
                            .frame(width: 38, height: 38)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("YPBlue").opacity(0.3), lineWidth: 1)
                            )
                        
                        Image(systemName: "tram.fill")
                            .foregroundColor(Color("YPBlue"))
                            .font(.system(size: 20))
                    }
                }
                
                Text(carrier.name)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color.black)
                
                if let transferText = carrier.transferText {
                    Text(transferText)
                        .font(.system(size: 12))
                        .foregroundColor(Color(.ypRed))
                }
                
                Spacer()
                
                Text(carrier.date)
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
            }
            
            HStack {
                Text(carrier.departureTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color.black)
                
                Rectangle()
                    .fill(Color(.ypGray))
                    .frame(height: 1)
                
                Text(carrier.duration)
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                
                Rectangle()
                    .fill(Color(.ypGray))
                    .frame(height: 1)
                
                Text(carrier.arrivalTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color.black)
            }
        }
        .padding(16)
        .background(Color(.ypLightGray))
        .cornerRadius(16)
    }
}
