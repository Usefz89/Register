//
//  RegisterTextField.swift
//  Register
//
//  Created by Yousef Zuriqi on 21/08/2023.
//

import UIKit

class RegisterTextField: UITextField {
    let newVar = 0 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        // observe changing on interface language
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageChanged, object: nil)
    }
    
    func setupView() {
        
        changeAlignment()
        font = Constants.textFieldFont
        changePlaceholderColor()
        borderStyle = .roundedRect
        layer.cornerRadius = Constants.cornerRadius
        layer.borderColor = Constants.borderColor
        layer.borderWidth = Constants.borderWidth
    }
    
    @objc func languageChanged() {
       changeAlignment()
    }
    
    //Change placeholder color to dark grey
    func changePlaceholderColor() {
        if let currentPlaceholder = self.placeholder {
            let placeholder = NSAttributedString(string: currentPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            attributedPlaceholder = placeholder
        }
    }
    // Change the alignment based on the language input
    func changeAlignment() {
        if !Constants.isEnglish {
            self.textAlignment = .right
        } else {
            self.textAlignment = .left
        }
    }
    
    
   
    
    

}
