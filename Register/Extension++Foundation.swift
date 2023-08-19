//
//  Extension++Foundation.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 18/08/2023.
//

import Foundation

/// return localized version of the string
/// - parameter key: the key string referes to the localized string
/// - returns: return the localized string
/// --------------------------------
/// This function  returns the same result of NSLocalizedString(), with initial empty value  for comment key.
/// 
public func localizedString(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
    
}
