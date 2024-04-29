//
//  UIView+Extensions.swift
//  ToDo Firebase
//
//  Created by Kerem Demir on 15.04.2024.
//

import UIKit

extension UIView {
    // MARK: Add Subviews
    func addSubViews(_ views: UIView...){
        views.forEach({
            addSubview($0)
        })
    }
    
    // MARK: Pin To Edges
    func pinToEdgesOf(view: UIView){
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

