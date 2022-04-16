//
//  TaskViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 13/04/2022.
//

import UIKit

class TaskViewController: UIViewController {
        
    var taskStore: TaskStore!
    @IBOutlet weak private var taskTableView: UITableView!
    @IBOutlet weak private var addTaskTextField: UITextField!
    var listStore: ListStore!
    var currentList: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tác vụ"
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        // Do any additional setup after loading the view.
    }

    @IBAction func addTask(_ sender: UIButton) {
        if let taskName = addTaskTextField.text, !taskName.isEmpty
        {
            taskTableView.reloadData()
            let newTask = Task(detail:taskName, taskType: .normal, timeCreate: Date())
            taskStore.addTask(task: newTask)
            let index = taskStore.taskNotFinished.count - 1
            let indexPath = IndexPath(row: index, section: 0)
            taskTableView.insertRows(at: [indexPath], with: .automatic)
        }
    }


}
extension TaskViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return taskStore.taskNotFinished.count
        }
        else
        {
            return taskStore.taskFinished.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        cell.delegate = self
        cell.taskStore = taskStore
        cell.initCellForTaskTableView(indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let number = taskStore.taskFinished.count
        if(section == 1)
        {
            if(number == 0)
            {
                return ""
            }
            return "Đã hoàn thành \(taskStore.taskFinished.count)"
        }
        return ""
    }
    
}
extension TaskViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension TaskViewController: TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task,didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isFinished = state
        taskTableView.reloadSections([0,1], with: .automatic)
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        print("update interested database of \(task.detail)!")
        task.isInterested = state
        if(!state)
        {
            task.taskType = .normal
        }
//        task.taskType = .important
    }
    
}
