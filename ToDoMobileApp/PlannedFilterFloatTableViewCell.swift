//
//  PlannedFillterFloatTableViewCell.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 15/04/2022.
//

import UIKit

class PlannedFilterFloatTableViewCell: UITableViewCell {

    let nameValue = ["All Planned", "Overdue", "Today", "Tomorrow", "This Week", "Later"]
    @IBOutlet private weak var imageIcon: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(indexPath: IndexPath)
    {
        nameLabel.text = nameValue[indexPath.row]
        nameLabel.contentMode = .left
    }
}
