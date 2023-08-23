//
//  RegisterViewController.swift
//  Register
//
//  Created by Yousef Zuriqi on 18/08/2023.
//

import UIKit
import WebKit
import AYPopupPickerView

class RegisterViewController: UIViewController {
    var requestManager = RequestManager()
    var countries: [Country] = []
    var states: [State] = []
    var labelText = localizedString(for: "agree")
    let termUrlString = "https://termsfeed.com/blog/sample-terms-and-conditions-template/"
    var linkRange = localizedString(for: "terms")
    
    @IBOutlet weak var termsLabel: ClickableLabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var lgButton: UIButton!
    
    @IBOutlet weak var phoneStackView: UIStackView!
    
    
    let codePickerView = AYPopupPickerView()
    let countryPickerView = AYPopupPickerView()
    let statePickerView = AYPopupPickerView()
    
    var inputTextFields: [ UITextField] {
        return [codeTextField, countryTextField, stateTextField]
    }

  
    @IBAction func changeLgButtonTapped(_ sender: Any) {
        register()
        changeLanguageInterface()
        
    }
    
    var selectedCountry: Country? {
        didSet {
            Task {
                guard let selectedCountry = selectedCountry else {return}
                 await states = States(countryID: selectedCountry.countryId).states
                if !states.isEmpty {
                    DispatchQueue.main.async {
                        self.stateTextField.isEnabled = true
                        self.statePickerView.pickerView.reloadAllComponents()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in inputTextFields {
            let uiTapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped(recognizer:)))
            textField.addGestureRecognizer(uiTapGesture)
        }
       
        
        // Add tap gesture recognizer to release the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(releaseKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        //Add observer for language changing
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageChanged, object: nil)
        // fetch countries.
        Task { await countries = Countries().countries }
        prepareInputFields()
    }
    
    @objc func textFieldTapped(recognizer: UITapGestureRecognizer) {
        // Dismiss the keyboard if textfield is on editing
        view.endEditing(true)
        
        // show the pickerview and select the row
        if let textField = recognizer.view as? InputRegisterTextField {
            // codetextField
            if textField == codeTextField {
                codePickerView.display {
                   let selectedIndex = self.codePickerView.pickerView.selectedRow(inComponent: 0)
                   self.codeTextField.text =  "\(self.countries[selectedIndex].code)"
                    
               }
                // countryTextField
            } else if textField == countryTextField {
                countryPickerView.display {
                   let selectedIndex = self.countryPickerView.pickerView.selectedRow(inComponent: 0)
                    self.countryTextField.text =  self.countries[selectedIndex].nameByLang
                    self.selectedCountry = self.countries[selectedIndex]
               }
            } else if textField == stateTextField {
                statePickerView.display {
                    let selectedIndex = self.statePickerView.pickerView.selectedRow(inComponent: 0)
                    self.stateTextField.text = self.states[selectedIndex].nameByLang
                    
                }
            }
          
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // modifyLabelText()
        modifyLabelText()
        let buttonTitle = localizedString(for: "Change the language")
        lgButton.setTitle(buttonTitle, for: .normal)
        lgButton.titleLabel?.font = Constants.buttonFont
        navigationBarTitleStyling()
    }
    
    @objc func languageChanged() {
        self.title = localizedString(for: "Register")
        self.labelText = localizedString(for: "agree")
        self.linkRange = localizedString(for: "terms")
        self.lgButton.setTitle(localizedString(for: "Change the language"), for: .normal)

        modifyLabelText()
        prepareInputFields()
        codeTextField.text = ""
        countryTextField.text = ""
        stateTextField.text = ""
        statePickerView.pickerView.reloadComponent(0)
    }
    
    // End editing when tap gesture.
    @objc func releaseKeyboard(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Styling the navigation bar title
    func navigationBarTitleStyling() {
        self.title = localizedString(for:"Register")
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: Constants.titleFont]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
    }
    
    // set inputTextfiled to it's related pickerview
    func prepareInputFields() {
        codePickerView.pickerView.tag = 1
        countryPickerView.pickerView.tag = 2
        statePickerView.pickerView.tag = 3
        
        codeTextField.tag = 1
        countryTextField.tag = 2
        stateTextField.tag = 3
        
        //assign passwordtextfield
        passwordTextField.isSecureTextEntry = true // Enable secure text entry
        passwordTextField.textContentType = .oneTimeCode
        
        nameTextField.placeholder = localizedString(for:"Full name")
        passwordTextField.placeholder = localizedString(for:"Password")
        codeTextField.placeholder = localizedString(for:"Code")
        phoneNumberTextField.placeholder = localizedString(for:"Phone number")
        emailTextField.placeholder = localizedString(for:"Email")
        countryTextField.placeholder = localizedString(for:"Country")
        stateTextField.placeholder = localizedString(for:"City")
        
        
        
        // Disable the StateTextField
        stateTextField.isEnabled = false
      
        countryPickerView.pickerView.delegate = self
        countryPickerView.pickerView.dataSource = self
        codePickerView.pickerView.delegate = self
        codePickerView.pickerView.dataSource = self
        statePickerView.pickerView.delegate = self
        statePickerView.pickerView.dataSource = self
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        countryTextField.delegate = self
        codeTextField.delegate = self
        stateTextField.delegate = self
    }
    
    // Styling the label text
    func modifyLabelText() {
        termsLabel.labelText = labelText
        termsLabel.clickableText = linkRange
        termsLabel.urlString = termUrlString
        termsLabel.color = UIColor.red
        termsLabel.LabelTextStyle()
    }
    
    // Print all the textfields
    func register() {
        // print the values of textfields
        view.subviews.first?.subviews.forEach {
            print(($0 as? UITextField)?.text ?? "")
        }
    }
    
    func changeLanguageInterface() {
        LanguageManager.shared.setLanguage()
        if Constants.isEnglish {
            phoneStackView.semanticContentAttribute = .forceLeftToRight
        } else {
            phoneStackView.semanticContentAttribute = .forceRightToLeft
        }
    }
}

//MARK: PickerView Delegate

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
            return countries[row].nameByLang
        case 3:
            return states[row].nameByLang
        default:
            return "None"
        }
    }
}

//MARK: - TextField delegate

extension RegisterViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        false
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
   
        textField.resignFirstResponder()
        return true
    }
    
}





