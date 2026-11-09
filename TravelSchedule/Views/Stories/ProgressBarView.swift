//
//  ProgressBarView.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 09.11.2026.
//

import SwiftUI

struct ProgressBarView: View {
    let numberOfSections: Int
    let currentSection: Int
    let progress: CGFloat
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<numberOfSections, id: \.self) { index in
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Фон (незаполненная часть)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(.ypWhite))
                            .frame(height: 6)
                        
                        // Заполненная часть
                        let fillWidth: CGFloat = {
                            if index < currentSection { return geometry.size.width }
                            if index == currentSection { return geometry.size.width * progress }
                            return 0
                        }()
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(.ypBlue))
                            .frame(width: fillWidth, height: 6)
                    }
                }
            }
        }
    }
    
    // Логика заполнения конкретной секции
    private func progressForSection(index: Int) -> CGFloat {
        let sectionProgress = CGFloat(1) / CGFloat(numberOfSections)
        let currentSectionStart = sectionProgress * CGFloat(index)
        let currentSectionEnd = currentSectionStart + sectionProgress
        
        if progress >= currentSectionEnd {
            return 1.0 // Секция полностью заполнена
        } else if progress <= currentSectionStart {
            return 0.0 // Секция еще не началась
        } else {
            // Секция заполняется прямо сейчас
            return (progress - currentSectionStart) / sectionProgress
        }
    }
}
