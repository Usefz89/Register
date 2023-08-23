//
//  LanguageManager.swift
//  Register
//
//  Created by Yousef Zuriqi on 20/08/2023.
//

import Foundation

class LanguageManager {
    static let shared = LanguageManager()
    var currentLanguage: String = {   UserDefaults.standard.string(forKey: "AppleLanguages") ?? Locale.current.language.languageCode!.identifier
    }()
    
    
    func setLanguage() {
        let setLanguage  = currentLanguage == "en" ? "ar" : "en"
        UserDefaults.standard.setValue([setLanguage], forKey: "AppleLanguages")
        currentLanguage = setLanguage
//        UserDefaults.standard.setValue([currentLanguage], forKey: "AppleLanguages")
        
        NotificationCenter.default.post(name: Notification.Name("languageChanged"), object: nil)
    }
}

extension NSNotification.Name {
    static let languageChanged = NSNotification.Name("languageChanged")
}
