//
//  CarrierDetailView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 30.10.2026.
//

import SwiftUI

struct CarrierDetailView: View {
    let carrierName: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            carrierLogo
            carrierTitle
            emailSection
            phoneSection
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color("YPBackground").ignoresSafeArea())
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
    }
    
    // MARK: - Subviews
    
    private var carrierLogo: some View {
        Image("Image")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: 104)
            .padding(.top, 24)
    }
    
    private var carrierTitle: some View {
        Text("ОАО «РЖД»")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(Color("YPBlack"))
    }
    
    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("E-mail")
                .font(.system(size: 17))
                .foregroundColor(Color("YPBlack"))
            
            Text("i.lozgkina@yandex.ru")
                .font(.system(size: 12))
                .foregroundColor(Color("YPBlue"))
        }
    }
    
    private var phoneSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Телефон")
                .font(.system(size: 17))
                .foregroundColor(Color("YPBlack"))
            
            Text("+7 (904) 329-27-71")
                .font(.system(size: 12))
                .foregroundColor(Color("YPBlue"))
        }
    }
}

#Preview {
    CarrierDetailView(carrierName: "РЖД")
}
