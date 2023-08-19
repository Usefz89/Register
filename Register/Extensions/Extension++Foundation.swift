//
//  Extension++Foundation.swift
//  Register
//
//  Created by Yousef Zuriqi on 20/08/2023.
//

import Foundation

public func localizedString(for key: String) -> String {
    let language = LanguageManager.shared.currentLanguage
    let path = Bundle.main.path(forResource: language, ofType: "lproj")!
    let bundle = Bundle(path: path)!
    return NSLocalizedString(key, bundle: bundle, comment: "")
}
