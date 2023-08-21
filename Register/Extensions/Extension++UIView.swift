//
//  Extension++UIView.swift
//  Register
//
//  Created by Yousef Zuriqi on 21/08/2023.
//

import UIKit

extension UIView {
    func viewController() -> UIViewController? {
        var next: UIResponder? = self
        while next != nil {
            next = next?.next
            if let viewController = next as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
