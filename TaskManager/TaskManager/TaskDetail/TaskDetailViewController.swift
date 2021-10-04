//
//  TaskDetailViewController.swift
//  TaskManager
//
//  Created by Khateeb H. on 10/3/21.
//

import UIKit

protocol TaskDetailViewControllerDelegate: AnyObject {
  func didActionDone()
}

class TaskDetailViewController: UIViewController {

    var viewModel: TaskDetailViewModel
    private let alertPresenter = AlertPresenter()
    
    weak var delegate: TaskDetailViewControllerDelegate?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var updateSaveButton: UIButton!
    @IBOutlet weak var updateSaveButtonBottomAnchor: NSLayoutConstraint!
    
    private var actionButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationSetup()
        prepareView()
        update()
    }
    
    required init(viewModel: TaskDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func notificationSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func prepareView() {
        updateSaveButton.isHidden = true

        switch viewModel.mode {
        case .addNew:
            self.title = "Add New Task"
            makeEditingEnabled()
            actionButton = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle.fill"), style: .plain, target: self, action: #selector(onAction(sender:)))
        case .showAndUpdate:
            self.title = "Task Detail"
            makeEditingDisabled()
            actionButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(onAction(sender:)))
        }
        self.navigationItem.rightBarButtonItem = actionButton
    }
    
    private func makeEditingEnabled() {
        titleTextField.isEnabled = true
        detailTextView.isEditable = true
        titleTextField.becomeFirstResponder()
    }
    
    private func makeEditingDisabled() {
        titleTextField.isEnabled = false
        detailTextView.isEditable = false
        view.endEditing(true)
    }
    
    private func update() {
        if viewModel.mode == .showAndUpdate,
           let task = viewModel.todoItem {
            titleTextField.text = task.title
            detailTextView.text = task.detail
        }
    }
    
    private func validateAndSave() {
        if titleTextField.text?.replacingOccurrences(of: " ", with: "") == "" {
            self.alertPresenter.present(from: self, title: nil, message: "Input title", dismissButtonTitle: "OK")
            return
        }
        
        if viewModel.mode == .addNew {
            viewModel.addNewToDo(id: UUID().uuidString, title: titleTextField.text!, detail: detailTextView.text)
        }else {
            viewModel.updateTodoItem(with: titleTextField.text!, detail: detailTextView.text)
        }
        
        delegate?.didActionDone()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSaveUpdate(_ sender: Any) {
        validateAndSave()
    }
    
    @objc
    private func onAction(sender: Any) {
        switch viewModel.mode {
        case .addNew:
            validateAndSave()
        case .showAndUpdate:
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let updateAction = UIAlertAction(title: "Update", style: .default) { action in
                self.makeEditingEnabled()
                self.updateSaveButton.isHidden = false
            }
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.viewModel.deleteTodoItem()
                self.delegate?.didActionDone()
                self.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                
            }
            actionSheet.addAction(updateAction)
            actionSheet.addAction(deleteAction)
            actionSheet.addAction(cancelAction)

            present(actionSheet, animated: true) {
            }
            
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: { [self] in
                
                self.updateSaveButtonBottomAnchor.constant = keyboardSize.height + 8
                
                self.view.setNeedsLayout()
            }, completion: nil)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.updateSaveButtonBottomAnchor.constant = 30
        }
    }
}
