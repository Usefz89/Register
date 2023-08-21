//
//  InputRegisterTextField.swift
//  Register
//
//  Created by Yousef Zuriqi on 21/08/2023.
//

import UIKit

class InputRegisterTextField: RegisterTextField {

 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        
    }
    override func setupView() {
        super.setupView()
        
        // Adding the down arrow to the textField with horizantal padding
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
        rightView = containerView
        rightViewMode = .always
        rightView?.tintColor = .black
    }
    
  
   
    
    

}
