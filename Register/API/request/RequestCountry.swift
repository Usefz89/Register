//
//  RequestCountry.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import Foundation

enum RequestCountry: RequestProtocol {
    case country
    case state(countryID: Int)
    
    var path: String {
        switch self {
        case .country:
            return "/Api/Countries"
        case .state:
            return "/Api/States"
        }
    }
    
    var requestType: RequestType {
        return RequestType.GET
    }
    
    
    var urlParams: [String: String?]{
        switch self {
        case .country:
            return [:]
        case .state(let countryID):
            return ["countryId": "\(countryID)"]
        }
    }
}





