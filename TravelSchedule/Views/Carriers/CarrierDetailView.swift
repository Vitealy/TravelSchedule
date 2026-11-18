//
//  CarrierDetailView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 30.10.2026.
//

internal import SwiftUI

struct CarrierDetailView: View {
    let carrierCode: String
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: CarrierDetailViewModel
    
    init(carrierCode: String) {
        self.carrierCode = carrierCode
        self._viewModel = State(initialValue: CarrierDetailViewModel(carrierCode: carrierCode))
    }
    
    var body: some View {
        ZStack {
            Color("YPBackground").ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                ErrorView(errorType: error) {
                    Task { await viewModel.loadCarrierInfo() }
                }
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    carrierLogo
                    carrierTitle
                    emailSection
                    phoneSection
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
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
        .task {
            await viewModel.loadCarrierInfo()
        }
    }
    
    // MARK: - Subviews
    
    private var carrierLogo: some View {
        Group {
            if let logoURLString = viewModel.carrierLogoURL,
               let url = URL(string: logoURLString.hasPrefix("//") ? "https:\(logoURLString)" : logoURLString) {
                // Если API вернул ссылку, грузим её из сети
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView() // Крутилка, пока картинка грузится
                }
            } else {
                // Если ссылки нет (или она битая), показываем заглушку из Assets
                Image("Image")
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 104)
        .padding(.top, 24)
    }
    
    private var carrierTitle: some View {
        Text(viewModel.carrierTitle)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(Color("YPBlack"))
    }
    
    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("E-mail")
                .font(.system(size: 17))
                .foregroundColor(Color("YPBlack"))
            
            Text(viewModel.carrierEmail)
                .font(.system(size: 12))
                .foregroundColor(Color("YPBlue"))
        }
    }
    
    private var phoneSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Телефон")
                .font(.system(size: 17))
                .foregroundColor(Color("YPBlack"))
            
            Text(viewModel.carrierPhone)
                .font(.system(size: 12))
                .foregroundColor(Color("YPBlue"))
        }
    }
}

#Preview {
    CarrierDetailView(carrierCode: "63438")
}
