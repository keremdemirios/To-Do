//
//  ToDoListItem+CoreDataProperties.swift
//  ToDo Firebase
//
//  Created by Kerem Demir on 16.04.2024.
//
//

import Foundation
import CoreData

extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var status: String?

}

extension ToDoListItem : Identifiable {

}
