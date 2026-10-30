//
//  CarrierDetailView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 30.10.2026.
//

import SwiftUI

struct CarrierDetailView: View {
    let carrierName: String
    
    var body: some View {
        VStack {
            Spacer()
            Text("Информация о перевозчике: \(carrierName)")
                .font(.system(size: 20, weight: .medium))
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color("YPBlack"))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color("YPBackground").ignoresSafeArea())
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    CarrierDetailView(carrierName: "РЖД")
}
