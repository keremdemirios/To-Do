//
//  ToDoItem.swift
//  ToDo Firebase
//
//  Created by Kerem Demir on 15.04.2024.
//

import Foundation
import UIKit

struct ToDoItem {
    
    var id     : String
    var title  : String
    var status : Status
    
    init(id: String, title: String, status: Status) {
        self.id         = id
        self.title      = title
        self.status     = status
    }
    

}

public enum Status: String, CaseIterable {
    
    case todo   = "To Do"
    case doing  = "Doing"
    case done   = "Done"
    
    func colorForStatus() -> UIColor {
        switch self {
        case .todo:
            return .red
        case .doing:
            return .systemYellow
        case .done:
            return .green
        }
    }
    
    func imageForStatus() -> String {
        switch self {
        case .todo:
            return "circle"
        case .doing:
            return "circle.dotted.circle"
        case .done:
            return "checkmark.circle"
        }
    }
}



public enum FilterOption {
    case none
    case todo
    case doing
    case done
    
    var status: Status? {
        switch self {
        case .none:
            return nil
        case .todo:
            return .todo
        case .doing:
            return .doing
        case .done:
            return .done
        }
    }
}

public enum SetCheckBoxImage {
    
}
