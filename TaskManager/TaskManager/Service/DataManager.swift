//
//  DataManager.swift
//  TaskManager
//
//  Created by Khateeb H. on 10/3/21.
//

import Foundation
import UIKit
import CoreData

final class DataManager {
    enum DataManagerError: Error {
        case invalidContext
    }
    static let shared: DataManager = DataManager()
    private var managedContext: NSManagedObjectContext? = nil
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func fetchTodoItems() -> Result<[TodoItem], Error> {
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        
        guard let managedContext = self.managedContext else {
            return .failure(DataManagerError.invalidContext)
        }
        
        do{
            let todoItems = try managedContext.fetch(fetchRequest)
            return .success(todoItems)
        } catch let fetchErr{
            print("Failed to fetch items: ", fetchErr)
            return .failure(fetchErr)
        }
    }
    
    func saveNewTodoItem(id: String, title: String, detail: String) {
        guard let context = managedContext else {
            return
        }
        let todo = TodoItem(context: context)
        //let todoItem = NSManagedObject(entity: entity!, insertInto: context)
        todo.id = id
        todo.title = title
        todo.detail = detail
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteTodoItem(by id: String) {
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        
        guard let managedContext = self.managedContext else {
            return
        }
        
        if let result = try? managedContext.fetch(fetchRequest) {
            for item in result {
                if item.id == id {
                    managedContext.delete(item)
                    do {
                        try managedContext.save()
                        return
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                        return
                    }
                }
            }
        }
    }
    
    func updateTodoItem(by id: String, title: String, detail: String) {
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: "TodoItem")
        
        guard let managedContext = self.managedContext else {
            return
        }
        
        if let result = try? managedContext.fetch(fetchRequest) {
            for item in result {
                if item.id == id {
                    item.title = title
                    item.detail = detail
                    do {
                        try managedContext.save()
                        return
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                        return
                    }
                }
            }
        }
    }
}
