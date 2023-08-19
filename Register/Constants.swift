//
//  Constants.swift
//  Register
//
//  Created by Yousef Zuriqi on 19/08/2023.
//

import Foundation
import UIKit

struct Constants {
    static var isEnglish = Locale.current.language.languageCode!.identifier == "en"
    static var borderWidth = 0.7
    static var cornerRadius: CGFloat = 5
    static var borderColor: CGColor = UIColor.black.cgColor
    static var textFieldFont = isEnglish ? UIFont(name: "Montserrat-Regular", size: 14) :
    UIFont(name: "GE Dinar One Medium", size: 15)
    static var buttonFont = isEnglish ? UIFont(name: "Montserrat-Regular", size: 20) :
    UIFont(name: "GE Dinar One Medium", size: 15)
    static var titleFont = isEnglish ? UIFont(name: "Montserrat-Regular", size: 20) :
    UIFont(name: "GE Dinar One Medium", size: 20)
    static var labelFont = isEnglish ? UIFont(name: "Montserrat-Regular", size: 9) :
    UIFont(name: "GE Dinar One Medium", size: 9)
    
}
