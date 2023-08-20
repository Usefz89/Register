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
    
    @IBOutlet weak var termsLabel: UILabel!
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
    var textFields: [UITextField] = []
    var inputTextFields: [UITextField] = []
    
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
        
        // Add gesture to View
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(releaseKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        //Add observer
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageChanged, object: nil)
        
        // fetch countries.
        Task { await countries = Countries().countries }
        prepareInputFields()
    }
    
    @objc func languageChanged() {
        self.title = localizedString(for: "Register")
        self.labelText = localizedString(for: "agree")
        self.linkRange = localizedString(for: "terms")
        self.lgButton.setTitle(localizedString(for: "Change the language"), for: .normal)
        UserDefaults.standard.set([LanguageManager.shared.currentLanguage], forKey: "AppleLanguages")

        modifyLabelText()
        prepareInputFields()
        
    }
    
    // End editing when tap gesture.
    @objc func releaseKeyboard(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        modifyLabelText()
        let buttonTitle = localizedString(for: "Change the language")
        lgButton.setTitle(buttonTitle, for: .normal)
        lgButton.titleLabel?.font = Constants.buttonFont
        navigationBarTitleStyling()
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
        
        //Custom style for all TextFields
        textFields = [nameTextField, codeTextField, passwordTextField, phoneNumberTextField, emailTextField, countryTextField, stateTextField]
        for textField in textFields {
            if !Constants.isEnglish {
                textField.textAlignment = .right
            } else {
                textField.textAlignment = .left
            }
            textField.font = Constants.textFieldFont
            if let currentPlaceholder = textField.placeholder {
                let placeholder = NSAttributedString(string: currentPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
                textField.attributedPlaceholder = placeholder
            }
            textField.borderStyle = .roundedRect
            textField.layer.cornerRadius = Constants.cornerRadius
            textField.layer.borderColor = Constants.borderColor
            textField.layer.borderWidth = Constants.borderWidth
        }
        
        // Custom styling for input textfields
        inputTextFields = [codeTextField, countryTextField, stateTextField]
        for textField in inputTextFields {
            let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
            imageView.contentMode = .scaleAspectFit

            // Define padding values
            let padding: CGFloat = 10

            // Create a container view with padding
            let containerWidth = imageView.frame.width + padding * 2
            let containerHeight = imageView.frame.height
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight))

            // Add the image view to the container view, with padding on the sides
            imageView.frame.origin.x = padding
            containerView.addSubview(imageView)

            // Set the container view as the right view of the text field
            textField.rightView = containerView
            textField.rightViewMode = .always
            textField.rightView?.tintColor = .black
        }
      
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        codePickerView.delegate = self
        codePickerView.dataSource = self
        statePickerView.delegate = self
        statePickerView.dataSource = self
    }
    
    // Styling the label text
    func modifyLabelText() {
        let urlString = termUrlString
                
        let attributedString = NSMutableAttributedString(string: localizedString(for:labelText))
        if URL(string: urlString) != nil {
            let linkRange = (labelText as NSString).range(of: linkRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: linkRange)
        }
        termsLabel.font = Constants.labelFont
        termsLabel.attributedText = attributedString
        termsLabel.isUserInteractionEnabled = true
        termsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkTapped)))
    }
    
    // present url webpage when tapping the label text
    @objc func linkTapped(_ gesture: UITapGestureRecognizer) {
        let text = (gesture.view as! UILabel).text!
        let range = (text as NSString).range(of: linkRange)
        if gesture.didTapAttributedTextInLabel(label: termsLabel, inRange: range) {
            
            // Load the url request.
            let webView = WKWebView(frame: self.view.bounds)
            if let url = URL(string: termUrlString) {
              let request = URLRequest(url: url)
              webView.load(request)
            }
            
            //Create the webViewController
            let webViewController = UIViewController()
            webViewController.view.addSubview(webView)
            
            // present the webviewcontroller
            self.present(webViewController, animated: true)
            
        }else {
            print("Touch Text")
        }
    }
    
    // Print all the textfields
    func register() {
        for textField in textFields {
            print(textField.text ?? "")
        }
    }
    
    func changeLanguageInterface() {
        
        LanguageManager.shared.setLanguage()
//        let currentLanguage = Locale.current.language.languageCode?.identifier
//        let selectedLanguage = currentLanguage == "en" ? "ar" : "en"
//        UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
//        UserDefaults.standard.synchronize()
//
//        // Make alert
//        let alert = UIAlertController(
//            title: localizedString("alertTitle"),
//            message: localizedString("alertDescription"),
//            preferredStyle: .alert
//        )
//        // Add alert action
//        alert.addAction(UIAlertAction(title: localizedString("ok"), style: .default) {_ in
//            exit(0)
//        })
//        self.present(alert, animated: true, completion: nil)
    }
}




//MARK: Delegates & DataSources
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





