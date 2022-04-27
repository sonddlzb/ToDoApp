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
    var task: Task!
    var functionName: [String] = ["Add to My Day", "Remind Me", "Add Due Date", "Repeat", "Add File"]
    var imageName: [String] = [ "sun.max", "bell", "calendar", "repeat", "tag"]
    var listOfImportantTask: [Task]
    {
        return listStore.importantTaskListStore + taskStore.importantTaskTaskStore
    }
    let buttonName: [String] = ["My Day", "Important", "Planned", "Assign To Me", "Task"]
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
            case 1: number = listOfImportantTask.count
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
    
    func initCellForTaskMoreDetailViewController(indexPath: IndexPath, myDayState: Bool)
    {
        self.nameLabel.text = functionName[indexPath.row]
        self.nameLabel.textColor = .black
        self.nameLabel.contentMode = .left
        self.imageViewCell.image = UIImage(systemName: imageName[indexPath.row])
        if(indexPath.section == 1 && indexPath.row == 0)
        {
          changeToMyDay(state: myDayState)
        }
        if(indexPath.row == 2)
        {
            let plan = task.timePlanned
            let nextDay = Int(plan.day)
            let currentDay = Int(Date().day)
            let distance = nextDay! - currentDay!
            var deadline: String = " "
            if(distance == 0)
            {
                    deadline += "Today"
            }
            else if(distance == 1)
            {
                deadline += "Tomorrow"
            }
            else if(distance == -1)
            {
                deadline += "Yesterday"
            }
            else
            {
                deadline += "\(task.timePlanned.dayofTheWeek), \(task.timePlanned.day) \(task.timePlanned.monthString)"
            }
            if(Date() > plan)
            {
                nameLabel.textColor = UIColor.red
            }
            else
            {
                nameLabel.textColor = UIColor.blue
            }
              nameLabel.text = deadline
        }
        
    }
    
    func changeToMyDay(state: Bool)
    {
        if(state)
        {
            self.nameLabel.textColor = UIColor.blue
            self.countLabel.text = "x"
        }
        else
        {
            self.nameLabel.textColor = UIColor.black
            self.countLabel.text = ""
        }
    }
}

