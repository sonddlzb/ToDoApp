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
    var isOnEditMode: Bool!
    var taskStore: TaskStore!
    var listStore: ListStore!
    var task: Task!
    func initGui()
    {
        taskNameLabel.text = task.getDetail()
        taskNameLabel.contentMode = .left
        if(!task.getIsFinished())
        {
            finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        else
        {
            finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        if(task.getIsInterested())
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
//        self.layer.cornerRadius = 5
//        self.layer.masksToBounds = true
        self.alpha = 0.5
        self.layer.borderWidth = 0.1
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = .white

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
            self.taskNameLabel.text = taskStore.taskNotFinished[indexPath.row].getDetail()
            self.taskNameLabel.contentMode = .left
            self.task.setIsFinished(newState: false)
            self.finishButton.imageView?.image = UIImage(systemName: "circle")
            if(self.task.getIsInterested())
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
            self.taskNameLabel.text = taskStore.taskFinished[indexPath.row].getDetail()
            self.taskNameLabel.contentMode = .left

            self.task.setIsFinished(newState: true)
            self.finishButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            if(self.task.getIsInterested())
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
            }
            else
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star")
            }
        }
        if(isOnEditMode)
        {
            self.interestButton.isHidden = true
            self.finishButton.tintColor = UIColor.black
            self.finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        else
        {
            self.interestButton.isHidden = false
            self.finishButton.tintColor = .systemBlue
        }
    }
    
    //init the view of cell for ListTableView
    func initCellForListTableViewCell(list: List, indexPath: IndexPath)
    {
        self.task = list.listOfTask[indexPath.row]
        let due = task.getTimePlanned()
        let nextDay = Int(task.getTimePlanned().day)
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
        if(Date() > due)
        {
            self.moreInfoLabel.textColor = UIColor.red
        }
        else
        {
            self.moreInfoLabel.textColor = UIColor.black
        }
        self.moreInfoLabel.text! = "Tasks. " + deadline
        self.moreInfoLabel.contentMode = .left
        if indexPath.section == 0
        {
            self.task = list.taskNotFinished[indexPath.row]
            initGui()
            self.taskNameLabel.text = list.taskNotFinished[indexPath.row].getDetail()
            self.taskNameLabel.contentMode = .left
            self.task.setIsFinished(newState: false)
            self.finishButton.imageView?.image = UIImage(systemName: "circle")
            if(self.task.getIsInterested())
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
            self.taskNameLabel.text = list.taskFinished[indexPath.row].getDetail()
            self.taskNameLabel.contentMode = .left

            self.task.setIsFinished(newState: true)
            self.finishButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            if(self.task.getIsInterested())
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
            }
            else
            {
                self.interestButton.imageView?.image = UIImage(systemName: "star")
            }
        }
        if(isOnEditMode)
        {
            self.interestButton.isHidden = true
            self.finishButton.tintColor = UIColor.black
            self.finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        else
        {
            self.interestButton.isHidden = false
            self.finishButton.tintColor = .systemBlue
        }
    }
    
    //init cell for importantViewController
    func initCellForImportantViewController(indexPath: IndexPath, listOfImportantTask: [Task])
    {
        self.task = listOfImportantTask[indexPath.row]
        let due = task.getTimePlanned()
        let nextDay = Int(task.getTimePlanned().day)
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
        if(Date() > due)
        {
            self.moreInfoLabel.textColor = UIColor.red
        }
        else
        {
            self.moreInfoLabel.textColor = UIColor.black
        }
        self.moreInfoLabel.text! = "Tasks " + deadline
        self.moreInfoLabel.contentMode = .left
        print(listOfImportantTask.count)
        self.task = listOfImportantTask[indexPath.row]
        initGui()
        if(task.getTaskType() == .listed)
        {
            print("add list name")
            detailLabel.text = listStore.getListNameByTaskID(taskID: task.getTaskID())
        }
        self.taskNameLabel.text = listOfImportantTask[indexPath.row].getDetail()
        self.taskNameLabel.contentMode = .left
        self.task.setIsFinished(newState: false)
        self.finishButton.imageView?.image = UIImage(systemName: "circle")
        self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
        if(isOnEditMode)
        {
            self.interestButton.isHidden = true
            self.finishButton.tintColor = UIColor.black
            self.finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        else
        {
            self.interestButton.isHidden = false
            self.finishButton.tintColor = .systemBlue
        }
    }
    
    //init cell for myDayViewController
    func initCellForMyDayViewController(indexPath: IndexPath)
    {
        let due = task.getTimePlanned()
        let nextDay = Int(task.getTimePlanned().day)
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
        if(Date() > due)
        {
            self.moreInfoLabel.textColor = UIColor.red
        }
        else
        {
            self.moreInfoLabel.textColor = UIColor.black
        }
        if(task.getTaskType() == .myDay || (task.getTaskType() == .planned && task.getSecondTaskType() == .myDay))
        {
            self.moreInfoLabel.text = "My Day."
        }
        else
        {
            self.moreInfoLabel.text = ""
        }
        self.moreInfoLabel.text! += " Tasks." + deadline
        self.moreInfoLabel.contentMode = .left
        self.taskNameLabel.text = self.task.getDetail()
        self.taskNameLabel.contentMode = .left
        if(task.getIsInterested())
        {
            self.interestButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else
        {
            self.interestButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        if(indexPath.section == 0)
        {
            self.task.setIsFinished(newState: false)
            self.finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        else
        {
            self.task.setIsFinished(newState: true)
            self.finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        if(isOnEditMode)
        {
            self.interestButton.isHidden = true
            self.finishButton.tintColor = UIColor.black
            self.finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        else
        {
            self.interestButton.isHidden = false
            self.finishButton.tintColor = .systemBlue
        }
    }
    //init cell for plannedViewController
    func initCellForPlannedViewController(showCompletedTaskState state: Bool)
    {
        initGui()
        self.taskNameLabel.text = task.getDetail()
        self.taskNameLabel.contentMode = .left
        if(state)
        {
            if(!task.getIsFinished())
            {
                finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
            }
            else
            {
                finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            }
        }
        else
        {
            self.finishButton.imageView?.image = UIImage(systemName: "circle")
        }
        if(task.getIsInterested())
        {
            self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
        }
        else
        {
            self.interestButton.imageView?.image = UIImage(systemName: "star")
        }
        let due = task.getTimePlanned()
        let nextDay = Int(task.getTimePlanned().day)
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
        if(Date() > due)
        {
            self.moreInfoLabel.textColor = UIColor.red
        }
        else
        {
            self.moreInfoLabel.textColor = UIColor.black
        }
        if(task.getTaskType() == .myDay || (task.getTaskType() == .planned && task.getSecondTaskType() == .myDay))
        {
            self.moreInfoLabel.text = "My Day."
        }
        else
        {
            self.moreInfoLabel.text = ""
        }
        self.moreInfoLabel.text! += " Tasks" + deadline
        self.moreInfoLabel.contentMode = .left
        if(task.getIsInterested())
        {
            self.interestButton.imageView?.image = UIImage(systemName: "star.fill")
        }
        else
        {
            self.interestButton.imageView?.image = UIImage(systemName: "star")
        }
        if(isOnEditMode)
        {
            self.interestButton.isHidden = true
            self.finishButton.tintColor = UIColor.black
            self.finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        else
        {
            self.interestButton.isHidden = false
            self.finishButton.tintColor = .systemBlue
        }
    }
    
    // MARK: init cell for searching result
    func initCellForSearchViewController()
    {
        initGui()
        let due = task.getTimePlanned()
        let nextDay = Int(task.getTimePlanned().day)
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
        if(Date() > due)
        {
            self.moreInfoLabel.textColor = UIColor.red
        }
        else
        {
            self.moreInfoLabel.textColor = UIColor.black
        }
        if(task.getTaskType() == .myDay || (task.getTaskType() == .planned && task.getSecondTaskType() == .myDay))
        {
            self.moreInfoLabel.text = "My Day. "
        }
        if(task.getTaskType() == .listed)
        {
            self.moreInfoLabel.text = listStore.getListNameByTaskID(taskID: task.getTaskID())
        }
        else
        {
            self.moreInfoLabel.text = "Tasks. "
        }
        self.moreInfoLabel.text! +=  deadline
        self.moreInfoLabel.contentMode = .left
    }
}





