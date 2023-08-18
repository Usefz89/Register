//
//  RegisterViewController.swift
//  Register
//
//  Created by Yousef Zuriqi on 18/08/2023.
//

import UIKit

class RegisterViewController: UIViewController {
    var requestManager = RequestManager()
    var countries: [Country] = []
    var states: [State] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await countries = Countries().countries}
    }
    
    
   
 
  

    
}





