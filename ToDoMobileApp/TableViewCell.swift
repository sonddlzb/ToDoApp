//
//  TableViewCell.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 08/04/2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    var taskStore: TaskStore!
    var listStore: ListStore!
    var listOfImportantTask: [Task]
    {
        return listStore.importantTaskListStore + taskStore.importantTaskTaskStore
    }
    let buttonName: [String] = ["Ngày của tôi", "Quan trọng", "Đã lập kế hoạch", "Đã giao cho tôi", "Tác vụ"]
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet private weak var imageViewCell: UIImageView!
    @IBOutlet private weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.textAlignment = .left
        self.imageViewCell.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func bindDataForSection1(list: List,indexPath: IndexPath)
    {
        self.nameLabel.text = list.name
        self.imageViewCell.image = UIImage(systemName: "list.bullet")
        let number = list.listOfTask.count
        if(number != 0)
        {
            self.countLabel.text = "\(number)"
        }
    }
    func bindDataForSection0(indexPath: IndexPath)
    {
        self.nameLabel.text = buttonName[indexPath.row]
        switch indexPath.row
        {
            case 0:     self.imageViewCell.image = UIImage(systemName: "sun.max")
            case 1:     self.imageViewCell.image = UIImage(systemName: "star")
            case 2:     self.imageViewCell.image = UIImage(systemName: "calendar")
            case 3:     self.imageViewCell.image = UIImage(systemName: "person")
            default: self.imageViewCell.image = UIImage(systemName: "homekit")
        }
        let number: Int
        switch indexPath.row
        {
            case 0: number = taskStore.myDayTask.count
            case 1: number = listOfImportantTask.count + listStore.numberOfImportantTaskInList()
            case 2: number = taskStore.planTask.count
        case 4: number = taskStore.taskNotFinished.count
            default: number = 0
        }
        if(number != 0)
        {
            self.countLabel.text = "\(number)"
            print("Bind number for row \(indexPath.row)")
        }
        else
        {
            self.countLabel.text = ""
        }
    }
}
