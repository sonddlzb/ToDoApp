//
//  TaskTableViewCell.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 13/04/2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    var delegate : TaskTableViewCellDelegate?
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var interestButton: UIButton!
    @IBOutlet weak var taskNameLabel: UILabel!
    var taskStore: TaskStore!
    var task: Task!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func finishClick(_ sender: UIButton) {
        //print(sender.tag)
        if sender.imageView!.image!.description.contains("uncheck-icon")
        {
            sender.setImage(UIImage(named: "check-icon"), for: .normal)
            delegate?.taskTableViewCell(self, didTapFinishButtonAtTask: task, didTapFinishButtonToState: true)
            
        }
        else
        {
            //finishedButton.imageView?.image = UIImage(named: "check-icon")
            sender.setImage(UIImage(named: "uncheck-icon"), for: .normal)
            delegate?.taskTableViewCell(self, didTapFinishButtonAtTask: task, didTapFinishButtonToState: false)
        }
    }
    @IBAction func interestClick(_ sender: UIButton) {
        if sender.imageView!.image!.description.contains("star1-icon")
        {
            sender.setImage(UIImage(named: "star2-icon"), for: .normal)
            delegate?.taskTableViewCell(self, didTapInterestButtonAtTask: task, didTapInterestButtonToState: true)
        }
        else
        {
            
            sender.setImage(UIImage(named: "star1-icon"), for: .normal)
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
        if indexPath.section == 0
        {
            self.task = taskStore.taskNotFinished[indexPath.row]
            self.taskNameLabel.text = taskStore.taskNotFinished[indexPath.row].detail
            self.taskNameLabel.contentMode = .left
            self.task.isFinished = false
            self.finishButton.imageView?.image = UIImage(named: "uncheck-icon")
            if(self.task.isInterested)
            {
                self.interestButton.imageView?.image = UIImage(named: "star2-icon")
            }
            else
            {
                self.interestButton.imageView?.image = UIImage(named: "star1-icon")
            }
        }
        else
        {
            self.task = taskStore.taskFinished[indexPath.row]
            self.taskNameLabel.text = taskStore.taskFinished[indexPath.row].detail
            self.taskNameLabel.contentMode = .left

            self.task.isFinished = true
            self.finishButton.imageView?.image = UIImage(named: "check-icon")
            if(self.task.isInterested)
            {
                self.interestButton.imageView?.image = UIImage(named: "star2-icon")
            }
            else
            {
                self.interestButton.imageView?.image = UIImage(named: "star1-icon")
            }
        }
    }
    
    //init the view of cell for ListTableView
    func initCellForListTableViewCell(list: List, indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            self.task = list.taskNotFinished[indexPath.row]
            self.taskNameLabel.text = list.taskNotFinished[indexPath.row].detail
            self.taskNameLabel.contentMode = .left
            self.task.isFinished = false
            self.finishButton.imageView?.image = UIImage(named: "uncheck-icon")
            if(self.task.isInterested)
            {
                self.interestButton.imageView?.image = UIImage(named: "star2-icon")
            }
            else
            {
                self.interestButton.imageView?.image = UIImage(named: "star1-icon")
            }
        }
        else
        {
            self.task = list.taskFinished[indexPath.row]
            self.taskNameLabel.text = list.taskFinished[indexPath.row].detail
            self.taskNameLabel.contentMode = .left

            self.task.isFinished = true
            self.finishButton.imageView?.image = UIImage(named: "check-icon")
            if(self.task.isInterested)
            {
                self.interestButton.imageView?.image = UIImage(named: "star2-icon")
            }
            else
            {
                self.interestButton.imageView?.image = UIImage(named: "star1-icon")
            }
        }
    }
    
    func initCellForImportantViewController(indexPath: IndexPath, listOfImportantTask: [Task])
    {
        self.task = listOfImportantTask[indexPath.row]
        self.taskNameLabel.text = listOfImportantTask[indexPath.row].detail
        self.taskNameLabel.contentMode = .left
        self.task.isFinished = false
        self.finishButton.imageView?.image = UIImage(named: "uncheck-icon")
        self.interestButton.imageView?.image = UIImage(named: "star2-icon")
    }
}



protocol TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task,didTapFinishButtonToState state: Bool)
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task,didTapInterestButtonToState state: Bool)
}
