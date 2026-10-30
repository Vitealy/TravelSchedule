//
//  ErrorView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

import SwiftUI

enum AppErrorType {
    case noInternet
    case serverError
    
    var title: String {
        switch self {
        case .noInternet: return "Нет интернета"
        case .serverError: return "Ошибка сервера"
        }
    }
    
    var imageName: String {
        switch self {
        case .noInternet: return "No Internet"
        case .serverError: return "Server Error"
        }
    }
}

struct ErrorView: View {
    let errorType: AppErrorType
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(errorType.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)
                .cornerRadius(32)
            
            Text(errorType.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color("YPBlack"))
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .background(Color("YPBackground").ignoresSafeArea())
    }
}

#Preview {
    ErrorView(errorType: .noInternet)
}
