//
//  Country.swift
//  Register
//
//  Created by Yousef Zuriqi on 18/08/2023.
//

import Foundation


struct Country: Codable {
    let countryId: Int
    let nameAr: String
    let nameEn: String
    let name: String
    let flag: String
    let code: Int
 

    enum CodingKeys: String, CodingKey {
        case countryId = "CountryId"
        case nameAr = "NameAr"
        case nameEn = "NameEn"
        case name = "Name"
        case flag = "Flag"
        case code = "Code"
   
    }
}

