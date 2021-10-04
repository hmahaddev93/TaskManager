//
//  AlertPresenter.swift
//  TaskManager
//
//  Created by Khateeb H. on 10/3/21.
//

import Foundation
import UIKit

protocol AlertPresenter_Proto {
    func present(from: UIViewController, title: String?, message: String, dismissButtonTitle: String)
}

class AlertPresenter: AlertPresenter_Proto {
    func present(from: UIViewController, title: String?, message: String, dismissButtonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: dismissButtonTitle, style: .default, handler: nil)
        alertController.addAction(alertAction)
        from.present(alertController, animated: true, completion: nil)
    }
    
}
