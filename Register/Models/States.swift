//
//  States.swift
//  Register
//
//  Created by Yousef Zuriqi on 18/08/2023.
//

import Foundation

struct States {
    var requestManager = RequestManager()
    var states: [State]
    var countryID: Int
    
   

    init(countryID: Int) async {
        self.countryID = countryID
        do {
            self.states = try await requestManager.perform(request: RequestCountry.state(countryID: countryID))
        }catch {
            print("Error: Cannot retrieve states. \(error.localizedDescription)")
            self.states = []
        }
    }
}
