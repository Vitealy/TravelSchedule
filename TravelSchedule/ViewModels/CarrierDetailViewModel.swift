//
//  CarrierDetailViewModel.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 18.11.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class CarrierDetailViewModel {
    
    // MARK: - Public Properties
    var carrierTitle: String = "Загрузка..."
    var carrierEmail: String = ""
    var carrierPhone: String = ""
    var isLoading: Bool = false
    var error: AppErrorType? = nil
    var carrierLogoURL: String? = nil
    
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    private let carrierCode: String
    
    init(carrierCode: String, networkClient: NetworkClient = try! NetworkClient()) {
        self.carrierCode = carrierCode
        self.networkClient = networkClient
    }
    
    // MARK: - Actions
    func loadCarrierInfo() async {
        isLoading = true
        error = nil
        
        do {
            let response = try await networkClient.getCarrierInfo(code: carrierCode)
            
            self.carrierLogoURL = response.carrier?.logo
    
            self.carrierTitle = response.carrier?.title ?? "Неизвестный перевозчик"
            
            if let email = response.carrier?.email, !email.isEmpty {
                self.carrierEmail = email
            } else {
                self.carrierEmail = "Нет данных"
            }
            
            if let phone = response.carrier?.phone, !phone.isEmpty {
                self.carrierPhone = phone
            } else {
                self.carrierPhone = "Нет данных"
            }
            
        } catch {
            self.error = .serverError
        }
        
        isLoading = false
    }
}
