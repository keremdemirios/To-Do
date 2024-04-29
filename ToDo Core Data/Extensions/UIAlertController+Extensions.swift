//
//  UIAlertController+Extensions.swift
//  ToDo Firebase
//
//  Created by Kerem Demir on 17.04.2024.
//

import UIKit

extension UIAlertController {
    static func showAlertForAnything(title: String, message: String, presentingViewController: UIViewController) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", 
                                      style: .default,
                                      handler: nil))
        
        presentingViewController.present(alert,
                                         animated: true,
                                         completion: nil)
    }
}
