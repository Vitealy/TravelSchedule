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
        VStack {
            Spacer()
            Text("Информация о перевозчике: \(carrierName)")
                .font(.system(size: 20, weight: .medium))
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color(.ypBlack))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color("YPBackground").ignoresSafeArea())
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(.ypBlack))
                }
            }
        }
    }
}

#Preview {
    CarrierDetailView(carrierName: "РЖД")
}
