//
//  MyDayViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 15/04/2022.
//

import UIKit

class MyDayViewController: UIViewController {
    @IBOutlet weak private var myDayTableView: UITableView!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var addTaskTextField: UITextField!
    
    var taskStore: TaskStore!
    var myDayTaskFinished: [Task]
    {
        var res = [Task]()
        for value in taskStore.allTask
        {
            if value.taskType == .myDay && value.isFinished
            {
                res.append(value)
            }
            if value.taskType == .planned && value.secondTaskType == .myDay && value.isFinished
            {
                res.append(value)
            }
        }
        return res
    }
    
    var myDayTaskNotFinished: [Task]
    {
        var res = [Task]()
        for value in taskStore.allTask
        {
            if value.taskType == .myDay && !value.isFinished
            {
                res.append(value)
            }
            if value.taskType == .planned && value.secondTaskType == .myDay && !value.isFinished
            {
                res.append(value)
            }
        }
        return res
    }
    
    func initUI()
    {
        let date = Date()
        dateLabel.text = date.dayofTheWeek + ", " + date.day + " " + date.monthString
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        myDayTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        myDayTableView.delegate = self
        myDayTableView.dataSource = self
        addTaskTextField.delegate = self
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    @IBAction func addTask(_ sender: UIButton) {
        if let taskName = addTaskTextField.text, !taskName.isEmpty
        {
            myDayTableView.reloadData()
            let newTask = Task(detail:taskName, taskType: .myDay, timeCreate: Date())
            taskStore.addTask(task: newTask)
            let index = myDayTaskNotFinished.count - 1
            let indexPath = IndexPath(row: index, section: 0)
            myDayTableView.insertRows(at: [indexPath], with: .automatic)
            addTaskTextField.text = ""
        }
    }
    
    // MARK: - tap to return
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        addTaskTextField.resignFirstResponder()
    }
    

}

// MARK: - tableViewCell render

extension MyDayViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return myDayTaskNotFinished.count
        }
        else
        {
            return myDayTaskFinished.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myDayTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        cell.delegate = self
        if(indexPath.section == 0)
        {
            cell.task = myDayTaskNotFinished[indexPath.row]
        }
        else
        {
            cell.task = myDayTaskFinished[indexPath.row]
        }
        cell.initCellForMyDayViewController(indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let number = myDayTaskFinished.count
        if(section == 1)
        {
            if(number == 0)
            {
                return ""
            }
            return "Đã hoàn thành \(number)"
        }
        return ""
    }
    
}
// MARK: - delegate from textField

extension MyDayViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - delegate from cell for finish and interest touch action
extension MyDayViewController: TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task,didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isFinished = state
        myDayTableView.reloadSections([0,1], with: .automatic)
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        print("update interested database of \(task.detail)!")
        task.isInterested = state
    }
    
    
}

