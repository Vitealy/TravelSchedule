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
        case .noInternet: "Нет интернета"
        case .serverError: "Ошибка сервера"
        }
    }
    
    var imageName: String {
        switch self {
        case .noInternet: "No Internet"
        case .serverError: "Server Error"
        }
    }
}

struct ErrorView: View {
    let errorType: AppErrorType
    var onRetry: (() -> Void)? = nil
    
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
                .foregroundColor(Color(.ypBlack))
            
            if let onRetry = onRetry {
                Button(action: onRetry) {
                    Text("Повторить")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color(.ypBlue))
                        .cornerRadius(16)
                }
                .padding(.top, 20)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.ypBackground).ignoresSafeArea())
    }
}

#Preview {
    ErrorView(errorType: .noInternet)
}
