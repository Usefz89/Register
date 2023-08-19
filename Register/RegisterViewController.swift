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
    var selectedCountry: Country? {
        didSet {
            
            Task {
                try await states = requestManager.perform(request: RequestCountry.state(countryID: selectedCountry!.countryId))
                print(states.count)
                if !states.isEmpty {
                    DispatchQueue.main.async {
                        self.stateTextField.isEnabled = true
                        self.statePickerView.reloadAllComponents()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.stateTextField.text = ""
                        self.stateTextField.isEnabled = false
                    }
                }
               
            }
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var stateTextField: UITextField!
    
    let codePickerView = UIPickerView()
    let countryPickerView = UIPickerView()
    let statePickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await countries = Countries().countries
        }
        

        codePickerView.tag = 1
        countryPickerView.tag = 2
        statePickerView.tag = 3
        countryTextField.inputView = countryPickerView
        stateTextField.inputView = statePickerView
        codeTextField.inputView = codePickerView
        
        countryTextField.rightView = UIImageView(image: UIImage(systemName: "chevron.down"))
        stateTextField.rightView = UIImageView(image: UIImage(systemName: "chevron.down"))
        codeTextField.rightView = UIImageView(image: UIImage(systemName: "chevron.down"))

        countryTextField.rightViewMode = .always
        stateTextField.rightViewMode = .always
        codeTextField.rightViewMode = .always
        
        // Disable the StateTextField
        stateTextField.isEnabled = false
        
        //Custom style TextFields
        let textFields: [UITextField] = [nameTextField, codeTextField, passwordTextField, phoneNumberTextField, emailTextField, countryTextField, stateTextField]
        
        for textField in textFields {
            textField.borderStyle = .roundedRect
            textField.layer.cornerRadius = Constants.cornerRadius
            textField.layer.borderColor = Constants.borderColor
            textField.layer.borderWidth = Constants.borderWidth
        }
        
        
        
        
        


        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        codePickerView.delegate = self
        codePickerView.dataSource = self
        statePickerView.delegate = self
        statePickerView.dataSource = self
        

        
       


        
    }
    
    @objc func handlePickerViewTap(gesture: UITapGestureRecognizer, completion: () -> Void)  {
        print("countryPicker view has been tapped")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = "REGISTER"
    }
 
 
}

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
           return  countries.count
        case 2:
            return countries.count
        case 3:
            return states.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
           return "\(countries[row].code)"
        case 2:
            return countries[row].name
        case 3:
            return states[row].name
        default:
            return "None"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        switch pickerView.tag {
        case 1:
            codeTextField.text = "\(countries[row].code)"
            codeTextField.resignFirstResponder()
            
        case 2:
            countryTextField.text = countries[row].name
            countryTextField.resignFirstResponder()
            selectedCountry = countries[row]

            
            
        case 3:
            stateTextField.text = states[row].name
            stateTextField.resignFirstResponder()
        default:
            countryTextField.resignFirstResponder()
        }
    }
}





