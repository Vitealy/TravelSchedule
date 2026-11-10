//
//  StoriesView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 09.11.2026.
//

import SwiftUI
import Combine

struct StoriesView: View {
    let stories: [Story]
    let startIndex: Int
    let onStoryViewed: (Story) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @State private var currentIndex: Int
    @State private var progress: CGFloat = 0.0
    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    private let storyDuration: CGFloat = 10.0
    
    init(stories: [Story], startIndex: Int, onStoryViewed: @escaping (Story) -> Void) {
        self.stories = stories
        self.startIndex = startIndex
        self.onStoryViewed = onStoryViewed
        self._currentIndex = State(initialValue: startIndex)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { proxy in
                Image(stories[currentIndex].imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .cornerRadius(40)
            }
            .ignoresSafeArea()
            .padding(.top, 7)
            .padding(.bottom, 17)
            
            HStack(spacing: 0) {
                Rectangle().fill(Color.clear).contentShape(Rectangle()).onTapGesture { previousStory() }
                Rectangle().fill(Color.clear).contentShape(Rectangle()).onTapGesture { nextStory() }
            }
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 12) {
                // Прогресс-бар
                ProgressBarView(
                    numberOfSections: stories.count,
                    currentSection: currentIndex,
                    progress: progress
                )
                .frame(height: 4)
                .padding(.horizontal, 12)
                .padding(.top, 35)
                
                
                // Кнопка закрытия
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(.close)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    .padding(.top, 4)
                    .padding(.trailing, 12)
                }
                
                Spacer()
                
                // Тексты внизу
                VStack(alignment: .leading, spacing: 16) {
                    Text(stories[currentIndex].title)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(stories[currentIndex].description)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 57)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onAppear {
            onStoryViewed(stories[currentIndex])
        }
        .onReceive(timer) { _ in
            withAnimation(.linear(duration: 0.05)) {
                progress += CGFloat(0.05) / storyDuration
            }
            
            if progress >= 1.0 {
                nextStory()
            }
        }
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.width < 0 { nextStory() }
                    else if value.translation.width > 0 { previousStory() }
                }
        )
    }
    
    private func nextStory() {
        if currentIndex < stories.count - 1 {
            currentIndex += 1
            progress = 0.0
            onStoryViewed(stories[currentIndex])
        } else {
            dismiss()
        }
    }
    
    private func previousStory() {
        if currentIndex > 0 {
            currentIndex -= 1
            progress = 0.0
            onStoryViewed(stories[currentIndex])
        } else {
            progress = 0.0
        }
    }
}
