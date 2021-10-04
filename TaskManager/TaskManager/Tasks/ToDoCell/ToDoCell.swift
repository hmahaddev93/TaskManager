//
//  ToDoCell.swift
//  TaskManager
//
//  Created by Khateeb H. on 10/3/21.
//

import UIKit

class ToDoCell: UITableViewCell {

    var todoItem: TodoItem! {
        didSet {
            titleLabel.text = todoItem.title
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
