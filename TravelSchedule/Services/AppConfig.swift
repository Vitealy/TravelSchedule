//
//  AppConfig.swift
//  TravelSchedule
//
//  Created by Vitaly Kashavkin on 13.10.2026.
//

import Foundation

/// Централизованный доступ к конфигурации приложения.
enum AppConfig {
    
    /// API-ключ Яндекс.Расписаний, читается из Info.plist
    /// (значение подставляется туда из Config.xcconfig при сборке).
    static var yandexRaspAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "YandexRaspAPIKey") as? String,
              !key.isEmpty,
              key != "your_yandex_rasp_api_key_here" else {
            // В Debug — падаем, чтобы сразу заметить проблему.
            // В Release — вернём пустую строку, приложение продолжит работать.
            assertionFailure("YandexRaspAPIKey не найден или не заполнен в Config.xcconfig")
            return ""
        }
        return key
    }
}
