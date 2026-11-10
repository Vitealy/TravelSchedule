//
//  Story+Mock.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 10.11.2026.
//

import Foundation

extension Story {
    /// Тестовые данные для экрана Stories.
    static var mockStories: [Story] {
        let title = Array(repeating: "Text", count: 10).joined(separator: " ")
        let description = Array(repeating: "Text", count: 30).joined(separator: " ")
        
        var stories: [Story] = []
        
        let imageNames = ["1", "2", "6", "4"]
        
        for imageName in imageNames {
            stories.append(
                Story(
                    imageName: imageName,
                    title: title,
                    description: description + (imageName == "4" ? "." : ""),
                    isViewed: false
                )
            )
        }
        
        return stories
    }
}
