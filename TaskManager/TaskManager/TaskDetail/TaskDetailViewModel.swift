//
//  TaskDetailViewModel.swift
//  TaskManager
//
//  Created by Khateeb H. on 10/3/21.
//

import Foundation
enum TaskDetailViewMode: Int {
    case addNew, showAndUpdate
}
class TaskDetailViewModel {
    var mode: TaskDetailViewMode
    var todoItem: TodoItem?
    
    init(viewMode: TaskDetailViewMode = .showAndUpdate, item: TodoItem? = nil) {
        mode = viewMode
        todoItem = item
    }
    
    func addNewToDo(id: String, title: String, detail: String) {
        DataManager.shared.saveNewTodoItem(id: id, title: title, detail: detail)
    }
    
    func deleteTodoItem() {
        if let id = self.todoItem?.id {
            DataManager.shared.deleteTodoItem(by: id)
        }
    }
    
    func updateTodoItem(with title: String, detail: String) {
        if let id = self.todoItem?.id {
            DataManager.shared.updateTodoItem(by: id, title: title, detail: detail)
        }
    }
}
