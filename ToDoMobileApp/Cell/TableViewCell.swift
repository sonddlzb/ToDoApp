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
    var imageColor: [UIColor] = [.purple, .darkGray, .red, .green, .blue]
    var importantTaskNotFinished: [Task]
    {
        let res = listStore.importantTaskListStoreNotFinished + taskStore.importantTaskTaskStoreNotFinished
        return res
    }
    var importantTaskBoth: [Task]
    {
        let res = listStore.importantTaskListStoreBoth + taskStore.importantTaskTaskStoreBoth
        return res
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
        self.nameLabel.text = list.getName()
        self.imageViewCell.image = UIImage(systemName: "list.bullet")
        let number = list.listOfTask.count
        print("number count of list \(list.getName()) is \(number)")
        if(number != 0)
        {
            print("Bind number for row \(indexPath.row) section \(indexPath.section) with value \(number)")
            countLabel.text = "\(number)"
        }
    }
    func bindDataForSection0(indexPath: IndexPath)
    {
        if(indexPath.section == 0)
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
            imageViewCell.tintColor = imageColor[indexPath.row]
            let number: Int

            switch indexPath.row
            {
            case 0: number = taskStore.myDayTask.count + listStore.myDayListStore.count
                case 1: number = importantTaskNotFinished.count
                case 2: number = taskStore.planTask.count
                case 4: number = taskStore.taskNotFinished.count
                default: number = 0
            }
            if(number != 0)
            {
                countLabel.text = "\(number)"
                print("Bind number for row \(indexPath.row) section \(indexPath.section) with value \(number)")
            }
            else
            {
                countLabel.text = ""
            }
        }
    }
    
    func initCellForTaskMoreDetailViewController(indexPath: IndexPath, myDayState: Bool)
    {
        self.nameLabel.text = functionName[indexPath.row]
        self.nameLabel.textColor = .black
        self.countLabel.text = ""
        self.nameLabel.contentMode = .left
        self.imageViewCell.image = UIImage(systemName: imageName[indexPath.row])
        if(indexPath.section == 1 && indexPath.row == 0)
        {
          changeToMyDay(state: myDayState)
        }
        if(indexPath.row == 2)
        {
            let plan = task.getTimePlanned()
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
                deadline += "\(task.getTimePlanned().dayofTheWeek), \(task.getTimePlanned().day) \(task.getTimePlanned().monthString)"
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
    
    func initCellForListOptionViewController(indexPath: IndexPath, completedState: Bool)
    {
        let optionName: [String] = ["Edit", "Change Theme", "Print List","Group by", "Sort", "Show Completed Tasks"]
        let optionImage: [String] = ["pencil", "photo.artframe", "printer","rectangle.3.group", "square.and.arrow.up", "checkmark.circle"]
        self.nameLabel.text = optionName[indexPath.row]
        self.imageViewCell.image = UIImage(systemName: optionImage[indexPath.row])
        if(indexPath.row == 1 || indexPath.row == 3)
        {
            self.countLabel.text = ">"
        }
        if(completedState && indexPath.row == 5)
        {
            self.nameLabel.text = "Hide Completed Tasks"
        }
        
    }
    func initCellForListOptionViewController(indexPath: IndexPath)
    {
        let optionName: [String] = ["Edit", "Change Theme", "Print List","Group by", "Sort"]
        let optionImage: [String] = ["pencil", "photo.artframe", "printer","rectangle.3.group", "square.and.arrow.up"]
        self.nameLabel.text = optionName[indexPath.row]
        self.imageViewCell.image = UIImage(systemName: optionImage[indexPath.row])
        if(indexPath.row == 1 || indexPath.row == 3)
        {
            self.countLabel.text = ">"
        }
        
    }
    // MARK: - cell for color viewcontroller
    func initCellForSortViewController(indexPath: IndexPath)
    {
        let cellName = ["Alphabetically","Due Date","Creation Date"]
        let cellImage = ["arrow.up.arrow.down","calendar","plus.circle"]
        self.nameLabel.text = cellName[indexPath.row]
        self.imageViewCell.image = UIImage(systemName: cellImage[indexPath.row])
    }
}

