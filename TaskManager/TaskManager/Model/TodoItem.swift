//
//  TodoItem.swift
//  TaskManager
//
//  Created by Khateeb H. on 10/3/21.
//

import Foundation
import CoreData

struct TaskItem {
    var id: String
    var title: String
    var detail: String
}

class TodoItem: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var detail: String

    var taskItem : TaskItem {
       get {
        return TaskItem(id: self.id, title: self.title, detail: self.detail)
        }
        set {
            self.id = newValue.id
            self.title = newValue.title
            self.detail = newValue.detail
        }
     }
}
