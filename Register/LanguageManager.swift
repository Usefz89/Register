//
//  LanguageManager.swift
//  Register
//
//  Created by Yousef Zuriqi on 20/08/2023.
//

import Foundation

class LanguageManager {
    static let shared = LanguageManager()
    var currentLanguage: String = "en"
    
    func setLanguage() {
        currentLanguage = currentLanguage == "en" ? "ar" : "en"
        NotificationCenter.default.post(name: Notification.Name("languageChanged"), object: nil)
    }
}

extension NSNotification.Name {
    static let languageChanged = NSNotification.Name("languageChanged")
}
