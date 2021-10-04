//
//  TasksViewModel.swift
//  TaskManager
//
//  Created by Khateeb H. on 10/3/21.
//

import Foundation
class TasksViewModel {
    var todoItems: [TodoItem] = [TodoItem]()

    func fetchAllTodoItems(completion: @escaping(Result<[TodoItem], Error>) -> Void) {
        let result = DataManager.shared.fetchTodoItems()
        switch result {
        case .success(let items):
            self.todoItems = items
            completion(.success(items))
            return
        case .failure(let error):
            completion(.failure(error))
            return
        }
    }
    
    func deleteTodoItem(item: TodoItem) {
        DataManager.shared.deleteTodoItem(by: item.id)
    }
}
