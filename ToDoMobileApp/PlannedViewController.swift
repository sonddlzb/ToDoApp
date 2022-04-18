//
//  PlannedViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 15/04/2022.
//

import UIKit
class PlannedViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var taskStore: TaskStore!
    var currentFilter: Int = 0
    var isMyDay = false
    var currentDeadlineType: DeadlineType = .Today
    let nameValue = ["All Planned", "Overdue", "Today", "Tomorrow", "This Week", "Later"]
    @IBOutlet weak var addTaskTextField: UITextField!
    @IBOutlet weak var plannedTableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var myDayButton: UIButton!
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
            var dayComponent    = DateComponents()
            switch currentDeadlineType
            {
                case .Tomorrow: dayComponent.day = 1
                case .Today: dayComponent.day = 0
                case .NextWeek: dayComponent.day = 7
                case .Other: dayComponent.day = 100
            }
            let theCalendar = Calendar.current
            let nextDate = theCalendar.date(byAdding: dayComponent, to: Date())
            print(nextDate)
            let newTask: Task
            if(!isMyDay)
            {
                newTask = Task(detail:taskName, taskType: .planned, timeCreate: Date(), timePlanned: nextDate!)
            }
            else
            {
                newTask = Task(detail:taskName, taskType: .planned, secondTaskType: .myDay, timeCreate: Date(), timePlanned: nextDate!)
            }
            taskStore.addTask(task: newTask)
            let index = taskStore.planTask.count - 1
            let indexPath = IndexPath(row: index, section: 0)
            plannedTableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func addPresentView(_ sender: UIButton) {
        print("Load present ")
        let plannedFilterFloatViewController = PlannedFilterFloatViewController()
        plannedFilterFloatViewController.modalPresentationStyle = .custom
        plannedFilterFloatViewController.transitioningDelegate = self
        plannedFilterFloatViewController.modalTransitionStyle = .coverVertical
        plannedFilterFloatViewController.delegate = self
        self.present(plannedFilterFloatViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func myDayDidTap(_ sender: UIButton)
    {
        print("Myday picked!")
        if(!isMyDay)
        {
            isMyDay = true
            myDayButton.backgroundColor = UIColor.blue
            myDayButton.setTitle("My Day", for: .normal)
            myDayButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            isMyDay = false
            myDayButton.backgroundColor = UIColor.white
            myDayButton.setTitle("", for: .normal)
        }
    }
    
    @IBAction func deadlineDidTap(_ sender: UIButton)
    {
        print("Load deadline presentation")
        let deadlineViewController = DeadlineViewController()
        deadlineViewController.modalPresentationStyle = .custom
        deadlineViewController.transitioningDelegate = self
        deadlineViewController.modalTransitionStyle = .coverVertical
        deadlineViewController.delegate = self
        self.present(deadlineViewController, animated: true, completion: nil)
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
            return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    
    class HalfSizePresentationController: UIPresentationController {
        override var frameOfPresentedViewInContainerView: CGRect {
            guard let bounds = containerView?.bounds else { return .zero }
            return CGRect(x: 0, y: bounds.height/2, width: bounds.width, height: bounds.height/2)
        }
    }

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

// MARK: - delegate from PlannedFilterFloatViewControlle
extension PlannedViewController: PlannedFilterFloatViewControllerDelegate
{
    func plannedFilterFloatViewController(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentFilter = indexPath.row
        filterButton.setTitle(nameValue[indexPath.row], for: .normal)
        plannedTableView.reloadData()
    }
    
}

// MARK: - delegate from DeadlineViewController
extension PlannedViewController: DeadlineViewControllerDelegate
{
    func deadlineViewControllerDelagate(didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row
        {
            case 0: currentDeadlineType = .Today
            case 1: currentDeadlineType = .Tomorrow
            case 2: currentDeadlineType = .NextWeek
            case 3: currentDeadlineType = .Other
            default: print("Wrong deadline!")
        }
    }
    
    
}

