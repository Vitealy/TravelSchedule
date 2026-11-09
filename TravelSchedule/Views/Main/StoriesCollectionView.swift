//
//  StoriesCollectionView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 09.11.2026.
//

import SwiftUI

struct StoriesCollectionView: View {
    let stories: [Story]
    let onStoryTap: (Story) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(stories) { story in
                    Button(action: {
                        onStoryTap(story)
                    }) {
                        ZStack(alignment: .bottomLeading) {
                            Image(story.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 92, height: 140)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                // Если просмотрено — делаем прозрачность
                                .opacity(story.isViewed ? 0.5 : 1.0)
                            
                            Text(story.title)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.white)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                                .padding(8)
                                .frame(width: 92, height: 140, alignment: .bottomLeading)
                        }
                        .frame(width: 92, height: 140)
                        // Синяя обводка, если не просмотрено
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(story.isViewed ? Color.clear : Color(.ypBlue), lineWidth: 4)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 2)
        }
        .frame(height: 144)
    }
}
