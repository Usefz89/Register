//
//  Countries.swift
//  Register
//
//  Created by Yousef Zuriqi on 18/08/2023.
//

import Foundation

struct Countries {
    var countries: [Country]
    var requestManager: RequestManager = RequestManager()
    
    init() async {
            do {
                self.countries = try await requestManager.perform(request: RequestCountry.country)
            } catch {
                print("Error: Cannot retrive countries. \(error.localizedDescription)")
                self.countries = []
            }
    }
    
}
