//
//  ClickableLabel.swift
//  Register
//
//  Created by Yousef Zuriqi on 21/08/2023.
//

import UIKit
import WebKit

/// Label that  allow a part of its Text to be clickable. To open a URL  link.
/// Make sure to define the all the properties in ViewController viewDidLoad
/// Make sure viewcontroller() extension added  to UIView
/// Make sure didTapAttributedTextInLabel extension is added to UITapGesture

class ClickableLabel: UILabel {
    
    var labelText: String = ""
    var clickableText: String = ""
    var urlString: String = ""
    var color: UIColor = .black
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    func LabelTextStyle() {
        
        // Make part of the label with different color.
        let attributedString = NSMutableAttributedString(string: localizedString(for:labelText))
        let linkRange = (labelText as NSString).range(of: clickableText)
        attributedString.addAttribute(.foregroundColor, value: color, range: linkRange)
   
        font = Constants.labelFont
        self.attributedText = attributedString
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkTapped)))
    }
    
    @objc func linkTapped(_ gesture: UITapGestureRecognizer) {
        let text = (gesture.view as! UILabel).text!
        let range = (text as NSString).range(of: clickableText)
        
        if gesture.didTapAttributedTextInLabel(label: self, inRange: range) {
            
            // Load the url request.
            
            let webView = WKWebView(frame: (viewController()?.view.bounds)! )
            if let url = URL(string: urlString) {
              let request = URLRequest(url: url)
              webView.load(request)
            }
            
            //Create the webViewController
            let webViewController = UIViewController()
            
            webViewController.view.addSubview(webView)
            
            // present the webviewcontroller
            viewController()?.present(webViewController, animated: true)
            
        }else {
            print("Touch Text")
        }
    }
    
    
    

}
