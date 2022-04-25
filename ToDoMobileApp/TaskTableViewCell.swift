//
//  TaskTableViewCell.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 13/04/2022.
//

import UIKit

protocol TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task,didTapFinishButtonToState state: Bool)
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task,didTapInterestButtonToState state: Bool)
}
class TaskTableViewCell: UITableViewCell {

    var delegate : TaskTableViewCellDelegate?
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var interestButton: UIButton!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var moreInfoLabel: UILabel!
    var taskStore: TaskStore!
    var task: Task!
    func initGui()
    {
        taskNameLabel.text = task.detail
        taskNameLabel.contentMode = .left
        if(!task.isFinished)
        {
            finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        else
        {
            finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        if(task.isInterested || task.taskType == .important)
        {
            interestButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else
        {
            interestButton.setImage(UIImage(systemName: "star"), for: .normal)
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func finishClick(_ sender: UIButton) {
        //print(sender.tag)
        if sender.imageView!.image!.description.contains("checkmark.circle.fill")
        {
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
            delegate?.taskTableViewCell(self, didTapFinishButtonAtTask: task, didTapFinishButtonToState: false)        }
        else
        {
            //finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            delegate?.taskTableViewCell(self, didTapFinishButtonAtTask: task, didTapFinishButtonToState: true)
        }
    }
    @IBAction func interestClick(_ sender: UIButton) {
        if sender.imageView!.image!.description.contains("star.fill")
        {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            delegate?.taskTableViewCell(self, didTapInterestButtonAtTask: task, didTapInterestButtonToState: false)
        }
        else
        {
            
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            delegate?.taskTableViewCell(self, didTapInterestButtonAtTask: task, didTapInterestButtonToState: true)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //init the view of cell for TaskTableView
    func initCellForTaskTableView(indexPath: IndexPath)
    {
        self.moreInfoLabel.text = "Tasks"
        self.moreInfoLabel.contentMode = .left
        if indexPath.section == 0
        {
            self.task = taskStore.taskNotFinished[indexPath.row]
            initGui()
            self.taskNameLabel.text = taskStore.taskNotFinished[indexPath.row].detail
            self.taskNameLabel.contentMode = .left
            self.task.isFinished = false
            self.finishButton.imageView?.image = UIImage(systemName: "circle")
            if(self.task.isInterested || self.task.taskType == .important)
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
            }
            else
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star")
            }
        }
        else
        {
            self.task = taskStore.taskFinished[indexPath.row]
            initGui()
            self.taskNameLabel.text = taskStore.taskFinished[indexPath.row].detail
            self.taskNameLabel.contentMode = .left

            self.task.isFinished = true
            self.finishButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            if(self.task.isInterested || self.task.taskType == .important)
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
            }
            else
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star")
            }
        }
    }
    
    //init the view of cell for ListTableView
    func initCellForListTableViewCell(list: List, indexPath: IndexPath)
    {
        self.moreInfoLabel.text = "Tasks"
        self.moreInfoLabel.contentMode = .left
        if indexPath.section == 0
        {
            self.task = list.taskNotFinished[indexPath.row]
            initGui()
            self.taskNameLabel.text = list.taskNotFinished[indexPath.row].detail
            self.taskNameLabel.contentMode = .left
            self.task.isFinished = false
            self.finishButton.imageView?.image = UIImage(systemName: "circle")
            if(self.task.isInterested)
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
            }
            else
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star")
            }
        }
        else
        {
            self.task = list.taskFinished[indexPath.row]
            initGui()
            self.taskNameLabel.text = list.taskFinished[indexPath.row].detail
            self.taskNameLabel.contentMode = .left

            self.task.isFinished = true
            self.finishButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            if(self.task.isInterested)
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
            }
            else
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star")
            }
        }
    }
    
    //init cell for importantViewController
    func initCellForImportantViewController(indexPath: IndexPath, listOfImportantTask: [Task])
    {
        self.moreInfoLabel.text = "Tasks"
        self.moreInfoLabel.contentMode = .left
        print(listOfImportantTask.count)
        self.task = listOfImportantTask[indexPath.row]
        initGui()
        if(task.taskType == .listed)
        {
            print("add list name")
            detailLabel.text = task.listName
        }
        self.taskNameLabel.text = listOfImportantTask[indexPath.row].detail
        self.taskNameLabel.contentMode = .left
        self.task.isFinished = false
        self.finishButton.imageView?.image = UIImage(systemName: "circle")
        self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
    }
    
    //init cell for myDayViewController
    func initCellForMyDayViewController(indexPath: IndexPath)
    {
        let due = task.timePlanned
        let nextDay = Int(task.timePlanned.day)
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
        if(Date() > due)
        {
            self.moreInfoLabel.textColor = UIColor.red
        }
        else
        {
            self.moreInfoLabel.textColor = UIColor.black
        }
        if(task.taskType == .myDay || (task.taskType == .planned && task.secondTaskType == .myDay))
        {
            self.moreInfoLabel.text = "My Day"
        }
        else
        {
            self.moreInfoLabel.text = ""
        }
        self.moreInfoLabel.text! += " Tasks" + deadline
        self.moreInfoLabel.contentMode = .left
        self.taskNameLabel.text = self.task.detail
        self.taskNameLabel.contentMode = .left
        if(task.isInterested)
        {
            self.interestButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else
        {
            self.interestButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        if(indexPath.section == 0)
        {
            self.task.isFinished = false
            self.finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        else
        {
            self.task.isFinished = true
            self.finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
    }
    //init cell for plannedViewController
    func initCellForPlannedViewController()
    {
        initGui()
        self.taskNameLabel.text = task.detail
        self.taskNameLabel.contentMode = .left
        self.task.isFinished = false
        if(task.isInterested)
        {
            self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
        }
        else
        {
            self.interestButton.imageView?.image = UIImage(systemName: "star")
        }
        let due = task.timePlanned
        let nextDay = Int(task.timePlanned.day)
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
        if(Date() > due)
        {
            self.moreInfoLabel.textColor = UIColor.red
        }
        else
        {
            self.moreInfoLabel.textColor = UIColor.black
        }
        if(task.taskType == .myDay || (task.taskType == .planned && task.secondTaskType == .myDay))
        {
            self.moreInfoLabel.text = "My Day"
        }
        else
        {
            self.moreInfoLabel.text = ""
        }
        self.moreInfoLabel.text! += " Tasks" + deadline
        self.moreInfoLabel.contentMode = .left
        self.finishButton.imageView?.image = UIImage(systemName: "circle")
        if(task.isInterested)
        {
            self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
        }
        else
        {
            self.interestButton.imageView?.image = UIImage(systemName: "star")
        }
    }
}





