//
//  ImportantViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 13/04/2022.
//

import UIKit

class ImportantViewController: UIViewController {
    var listStore: ListStore!
    var taskStore: TaskStore!
    var listOfImportantTask: [Task]
    {
        var res = [Task]()
        for list in listStore.allList
        {
            for task in list.listOfTask
            {
                if(task.isInterested)
                {
                    res.append(task)
                }
            }
        }
        for task in taskStore.allTask
        {
            if(task.taskType == .important)
            {
                res.append(task)
            }
        }
        return res
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        importantTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        importantTableView.delegate = self
        importantTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var addTaskTextField: UITextField!
    
    @IBOutlet weak var importantTableView: UITableView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ImportantViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfImportantTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = importantTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        cell.taskStore = taskStore
        cell.initCellForImportantViewController(indexPath: indexPath, listOfImportantTask: listOfImportantTask)
        return cell
    }
    
    
}
