//
//  CheckBox.swift
//  ToDo Firebase
//
//  Created by Kerem Demir on 8.04.2024.
//

import UIKit

@IBDesignable
final class CheckBox: UIControl {
    
    private weak var imageView: UIImageView!
    
    private var image: UIImage {
        return checked ? UIImage(systemName: "checkmark.circle")! : UIImage(systemName: "circle")!
    }
    
    @IBInspectable
    public var checked: Bool = false {
        didSet {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        imageView.contentMode = .scaleAspectFit
        
        self.imageView = imageView
        backgroundColor = .clear
        
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc func tapped() {
        checked = !checked
        sendActions(for: .valueChanged)
    }
}
