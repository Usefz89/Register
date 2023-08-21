//
//  RegisterViewController.swift
//  Register
//
//  Created by Yousef Zuriqi on 18/08/2023.
//

import UIKit
import WebKit



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
    
    let codePickerView = UIPickerView()
    let countryPickerView = UIPickerView()
    let statePickerView = UIPickerView()
  
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add tap gesture recognizer to release the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(releaseKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        //Add observer for language changing
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageChanged, object: nil)
        // fetch countries.
        Task { await countries = Countries().countries }
        prepareInputFields()
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
        countryTextField.text = ""
        stateTextField.text = ""
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
        codePickerView.tag = 1
        countryPickerView.tag = 2
        statePickerView.tag = 3
        
        countryTextField.inputView = countryPickerView
        stateTextField.inputView = statePickerView
        codeTextField.inputView = codePickerView
        
        nameTextField.placeholder = localizedString(for:"Full name")
        passwordTextField.placeholder = localizedString(for:"Password")
        codeTextField.placeholder = localizedString(for:"Code")
        phoneNumberTextField.placeholder = localizedString(for:"Phone number")
        emailTextField.placeholder = localizedString(for:"Email")
        countryTextField.placeholder = localizedString(for:"Country")
        stateTextField.placeholder = localizedString(for:"City")
        
        // Disable the StateTextField
        stateTextField.isEnabled = false
      
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        codePickerView.delegate = self
        codePickerView.dataSource = self
        statePickerView.delegate = self
        statePickerView.dataSource = self
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
        /*
         **Use this method to apply built in localization for the app
        let currentLanguage = Locale.current.language.languageCode?.identifier
        let selectedLanguage = currentLanguage == "en" ? "ar" : "en"
        UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
         */
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
            countryTextField.text = countries[row].nameByLang
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

//MARK: - TextField delegate
extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
   
}





