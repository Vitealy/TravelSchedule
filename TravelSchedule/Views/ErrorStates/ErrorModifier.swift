//
//  ErrorModifier.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 02.11.2026.
//

import SwiftUI

extension View {
    /// Модификатор для показа экрана ошибки поверх любого контента
    func showErrorOverlay(errorType: AppErrorType?, onRetry: @escaping () -> Void) -> some View {
        ZStack {
            self
            if let errorType = errorType {
                ErrorView(errorType: errorType, onRetry: onRetry)
                    .transition(.opacity)
                    .zIndex(1) 
            }
        }
    }
}
