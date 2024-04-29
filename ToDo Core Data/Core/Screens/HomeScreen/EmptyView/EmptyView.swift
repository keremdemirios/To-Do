//
//  EmptyView.swift
//  ToDo Firebase
//
//  Created by Kerem Demir on 20.04.2024.
//

import UIKit

final class EmptyView: UIView {
    
    // MARK: UI Elements
    lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(named: "arrow2")
        arrowImageView.backgroundColor = .clear
        return arrowImageView
    }()
    
    lazy var emptyInfoLabel: UILabel = {
        let emptyInfoLabel = UILabel()
        emptyInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyInfoLabel.text = """
                                              LET'S CREATE!
                              
                              
                              An empty page is the beginning
                              of endless opportunities!
                              
                              Now, it's time to take the first step.
                              """
        emptyInfoLabel.numberOfLines = 0
        emptyInfoLabel.textColor = .label
        emptyInfoLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        return emptyInfoLabel
    }()
    
    lazy var emptyViewImageView: UIImageView = {
        let emptyViewImageView = UIImageView()
        emptyViewImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyViewImageView.image = UIImage(named: "EmptyTaskImage")
        return emptyViewImageView
    }()
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    private func configureView() {
        backgroundColor = .systemBackground
        
        addSubViews(arrowImageView, emptyInfoLabel, emptyViewImageView)
        
        NSLayoutConstraint.activate([
            // Arrow Image View
            arrowImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -20),
            arrowImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -50),
            arrowImageView.heightAnchor.constraint(equalToConstant: 175),
            arrowImageView.widthAnchor.constraint(equalToConstant: 130),
            
            // Empty Info Label
            emptyInfoLabel.topAnchor.constraint(equalTo: arrowImageView.bottomAnchor, constant: -5),
            emptyInfoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            emptyInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            // Empty Image View
            emptyViewImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyViewImageView.topAnchor.constraint(equalTo: emptyInfoLabel.bottomAnchor, constant: 0),
            emptyViewImageView.widthAnchor.constraint(equalToConstant: 350),
            emptyViewImageView.heightAnchor.constraint(equalToConstant: 350),
        ])
    }
    
    // MARK: Functions
    
    // MARK: Actions
}

// MARK: Extension

