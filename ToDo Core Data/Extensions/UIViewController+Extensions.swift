//
//  UIViewController+Extensions.swift
//  ToDo Firebase
//
//  Created by Kerem Demir on 16.04.2024.
//

import UIKit

extension UIViewController {
    
    // MARK: Alert View
    func showAlert(title: String = "Warning", message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Hide Keyboard When Tapped Around
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


