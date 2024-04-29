//
//  GoalsCell.swift
//  ToDo Firebase
//
//  Created by Kerem Demir on 15.04.2024.
//

import UIKit

final class GoalsCell: UITableViewCell {
    
    static let reuseIndetifier = "GoalsCell"
    
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    func setCell(name: String?, status: String, statusColor: UIColor, checkBoxSystemImageName: String) {
        if let text = name {
            goalsLabel.text = text
        }
        statusLabel.text = status
        statusLabel.textColor = statusColor
        checkBoxImageView.image = UIImage(systemName: checkBoxSystemImageName)
    }
}
