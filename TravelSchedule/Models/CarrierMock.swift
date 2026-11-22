//
//  CarrierModel.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 29.10.2026.
//

internal import SwiftUI

struct CarrierMock: Identifiable {
    let id = UUID()
    let name: String
    let date: String
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let hasTransfers: Bool
    let transferText: String?
    let logoURL: String?
    let logoColor: Color
    let departureHour: Int
    let carrierCode: String?
}
