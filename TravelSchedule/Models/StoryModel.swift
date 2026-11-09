//
//  StoryModel.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 09.11.2026.
//

import SwiftUI

struct Story: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    var isViewed: Bool
}
