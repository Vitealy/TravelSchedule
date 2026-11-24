//
//  StoryModel.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 09.11.2026.
//

internal import SwiftUI

struct Story: Identifiable, Sendable, Equatable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    var isViewed: Bool
}
