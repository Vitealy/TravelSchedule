//
//  CarriersView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

internal import SwiftUI

struct CarriersView: View {
    let fromCity: String
    let toCity: String
    
    @State private var viewModel: CarriersViewModel
    
    init(fromCity: String, toCity: String) {
        self.fromCity = fromCity
        self.toCity = toCity
        self._viewModel = State(initialValue: CarriersViewModel(fromCity: fromCity, toCity: toCity))
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
                        Text("\(fromCity) → \(toCity)")
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
                                    NavigationLink(destination: CarrierDetailView(carrierCode: "63438")) {
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
                
                // Плавающая кнопка фильтров
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
                // Заглушка логотипа
                RoundedRectangle(cornerRadius: 8)
                    .fill(carrier.logoColor)
                    .frame(width: 38, height: 38)
                
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
