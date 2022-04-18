//
//  PlannedFillterFloatTableViewCell.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 15/04/2022.
//

import UIKit

class PlannedFilterFloatTableViewCell: UITableViewCell {

    let nameValue = ["All Planned", "Overdue", "Today", "Tomorrow", "This Week", "Later"]
    let imageValue = ["calendar", "calendar.badge.exclamationmark","calendar.badge.plus", "calendar.badge.minus", "calendar.badge.clock","calendar.badge.clock.rtl"]
    let deadlineValue = ["Today", "Tomorrow", "Next Week", "Pick a Date"]
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
    
    func initCellForPlannedFilterTableView(indexPath: IndexPath)
    {
        nameLabel.text = nameValue[indexPath.row]
        imageIcon.image = UIImage(systemName: imageValue[indexPath.row])
        nameLabel.contentMode = .left
    }
    
    func initCellForDeadlineTableView(indexPath: IndexPath)
    {
        nameLabel.text = deadlineValue[indexPath.row]
        imageIcon.image = UIImage(systemName: imageValue[indexPath.row])
        nameLabel.contentMode = .left
    }
}
