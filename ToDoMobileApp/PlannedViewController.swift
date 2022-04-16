//
//  PlannedViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 15/04/2022.
//

import UIKit
class PlannedViewController: UIViewController {
    var taskStore: TaskStore!
    @IBOutlet weak var addTaskTextField: UITextField!
    @IBOutlet weak var plannedTableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        plannedTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        plannedTableView.delegate = self
        plannedTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func addTask(_ sender: UIButton) {
        if let taskName = addTaskTextField.text, !taskName.isEmpty
        {
            plannedTableView.reloadData()
            let newTask = Task(detail:taskName, taskType: .planned, timeCreate: Date())
            taskStore.addTask(task: newTask)
            let index = taskStore.planTask.count - 1
            let indexPath = IndexPath(row: index, section: 0)
            plannedTableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func addPresentView(_ sender: UIButton) {
        print("Load present ")
        let plannedFilterFloatViewController = PlannedFilterFloatViewController()
        self.present(plannedFilterFloatViewController, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - render tableView
extension PlannedViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.planTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = plannedTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        cell.task = taskStore.planTask[indexPath.row]
        cell.delegate = self
        cell.initCellForPlannedViewController()
        return cell
    }
    
}
// MARK: - delegate from cell
extension PlannedViewController: TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isFinished = state
        let indexPath = plannedTableView.indexPath(for: cell)
        if let index = indexPath
        {
            plannedTableView.deleteRows(at: [index], with: .automatic)
        }
        else
        {
            print("Unexpected error!")
        }
        //importantTableView.reloadData()
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isInterested = state

    }
    
    
}


