//
//  ViewController.swift
//  TaskManager
//
//  Created by Khateeb H. on 10/1/21.
//

import UIKit

class TasksViewController: UIViewController {

    private static let reuseCellIdentifier = "ToDoCell"

    private let viewModel = TasksViewModel()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareView()
        fetch()
    }
    
    private func prepareView() {
        self.title = "To-Do"
        tableView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: type(of: self).reuseCellIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    private func fetch() {
        viewModel.fetchAllTodoItems { result in
            switch result {
            case .success(_):
                self.update()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func update() {
        tableView.reloadData()
    }
    @IBAction func onAddNewToDo(_ sender: Any) {
        
        let taskDetailVC = TaskDetailViewController(viewModel: TaskDetailViewModel(viewMode: .addNew))
        taskDetailVC.delegate = self
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}

extension TasksViewController: TaskDetailViewControllerDelegate {
    func didActionDone() {
        self.fetch()
    }
}


extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).reuseCellIdentifier, for: indexPath) as? ToDoCell{
            cell.todoItem = viewModel.todoItems[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTodoItem(item: viewModel.todoItems[indexPath.row])
            fetch()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
        let taskDetailVC = TaskDetailViewController(viewModel: TaskDetailViewModel(viewMode: .showAndUpdate, item: viewModel.todoItems[indexPath.row]))
        taskDetailVC.delegate = self
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}
