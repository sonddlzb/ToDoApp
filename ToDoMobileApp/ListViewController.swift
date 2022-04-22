//
//  MyDayViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 08/04/2022.
//

import UIKit

class ListViewController: UIViewController{

    var listStore: ListStore!
    var currentList: Int!
    @IBOutlet weak private var myDayTableView: UITableView!
    @IBOutlet weak private var addTaskTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = listStore.allList[currentList].name
        addTaskTextField.delegate = self
        myDayTableView.delegate = self
        myDayTableView.dataSource = self
        myDayTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        if let taskName = addTaskTextField.text, !taskName.isEmpty
        {
            myDayTableView.reloadData()
            let newTask = Task(detail: taskName, taskType: .listed, timeCreate: Date())
            newTask.listName = listStore.allList[currentList].name
            listStore.allList[currentList].addTask(task: newTask)
            let index = listStore.allList[currentList].taskNotFinished.count - 1
            let indexPath = IndexPath(row: index, section: 0)
            myDayTableView.insertRows(at: [indexPath], with: .automatic)
            addTaskTextField.text = ""
        }
    }

}

// MARK: - delegate from tableView
extension ListViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return listStore.allList[currentList].taskNotFinished.count
        }
        else
        {
            return listStore.allList[currentList].taskFinished.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myDayTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        //task not finished
        cell.delegate = self
        cell.initCellForListTableViewCell(list: listStore.allList[currentList], indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let number = listStore.allList[currentList].taskFinished.count
        if(section == 1)
        {
            if(number == 0)
            {
                return ""
            }
            return "Đã hoàn thành \(listStore.allList[currentList].taskFinished.count)"
        }
        return ""
    }
}

// MARK: - delegate from text Field for returning
extension ListViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - delegate from cell
extension ListViewController: TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isFinished = state
        myDayTableView.reloadSections([0,1], with: .automatic)
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        print("update interested database of \(task.detail)!")
        task.isInterested = state
    }
    
}
