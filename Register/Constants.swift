//
//  Constants.swift
//  Register
//
//  Created by Yousef Zuriqi on 19/08/2023.
//

import Foundation
import UIKit

struct Constants {
    static var isEnglish: Bool {
        return LanguageManager.shared.currentLanguage == "en"
    }
    static var borderWidth = 0.7
    static var cornerRadius: CGFloat = 5
    static var borderColor: CGColor = UIColor.black.cgColor
    static var textFieldFont: UIFont? {
       isEnglish ? UIFont(name: "Montserrat-Regular", size: 15) :
        UIFont(name: "GE Dinar One Medium", size: 15)
    }
    static var buttonFont: UIFont? {
        isEnglish ? UIFont(name: "Montserrat-Regular", size: 20) :
        UIFont(name: "GE Dinar One Medium", size: 20)
    }
    static var titleFont: UIFont? {
        isEnglish ? UIFont(name: "Montserrat-Regular", size: 22) :
        UIFont(name: "GE Dinar One Medium", size: 22)
    }
    static var labelFont: UIFont? {
        isEnglish ? UIFont(name: "Montserrat-Regular", size: 12) :
        UIFont(name: "GE Dinar One Medium", size: 12)
    }
    
}
