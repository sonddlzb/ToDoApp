//
//  PlannedViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 15/04/2022.
//

import UIKit
import SwiftUI
class PlannedViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var taskStore: TaskStore!
    var currentFilter: Int = 0
    var isMyDay = false
    var nextDate: Date!
    var currentDeadlineType: DeadlineType = .Today
    let nameValue = ["All Planned", "Overdue", "Today", "Tomorrow", "This Week", "Later"]
    @IBOutlet weak var addTaskTextField: UITextField!
    @IBOutlet weak var plannedTableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var myDayButton: UIButton!
    @IBOutlet weak var dueButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var viewMove: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        plannedTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        plannedTableView.delegate = self
        plannedTableView.dataSource = self
        addTaskTextField.delegate = self
        self.plannedTableView.isUserInteractionEnabled = true
        self.plannedTableView.allowsSelection = true
        NotificationCenter.default.addObserver(self, selector: #selector(PlannedViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlannedViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        plannedTableView.reloadData()
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
                case .Other: dayComponent.day = -1
            }
            let theCalendar = Calendar.current
            if(currentDeadlineType == .Today || currentDeadlineType == .NextWeek || currentDeadlineType == .Tomorrow )
            {
                nextDate = theCalendar.date(byAdding: dayComponent, to: Date())
            }
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
            if newTask.due.rawValue == currentFilter || currentFilter == 0
            {
                plannedTableView.insertRows(at: [indexPath], with: .automatic)
            }
            addTaskTextField.text = ""
        }
    }
    
    @IBAction func addPresentView(_ sender: UIButton) {
        print("Load present ")
        let plannedFilterFloatViewController = PlannedFilterFloatViewController()
        plannedFilterFloatViewController.modalPresentationStyle = .custom
        plannedFilterFloatViewController.transitioningDelegate = self
        plannedFilterFloatViewController.modalTransitionStyle = .coverVertical
        plannedFilterFloatViewController.delegate = self
        self.view.layer.opacity = 0.5
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
    
    // MARK: - tap to return
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        addTaskTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }

      // move the root view up by the distance of keyboard height
        self.viewMove.frame.origin.y = view.bounds.height - keyboardSize.height - viewMove.bounds.height
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin
        self.viewMove.frame.origin.y = view.bounds.height - viewMove.bounds.height - view.safeAreaInsets.bottom
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
        self.view.layer.opacity = 0.5
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
            return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }

}

// MARK: - render tableView
extension PlannedViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentFilter
        {
            case 0: return taskStore.planTask.count
            case 1: return taskStore.planOverdueTask.count
            case 2: return taskStore.planTodayTask.count
            case 3: return taskStore.planTomorrowTask.count
            case 4: return taskStore.planThisWeekTask.count + taskStore.planTomorrowTask.count + taskStore.planTodayTask.count
            case 5: return taskStore.planLaterTask.count
            default: print("wrong index of filter")
        }
        return taskStore.planTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = plannedTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        switch currentFilter
        {
            case 0: cell.task = taskStore.planTask[indexPath.row]
            case 1: cell.task = taskStore.planOverdueTask[indexPath.row]
            case 2: cell.task = taskStore.planTodayTask[indexPath.row]
            case 3: cell.task = taskStore.planTomorrowTask[indexPath.row]
            case 4:
            let thisWeek = taskStore.planTodayTask + taskStore.planTomorrowTask + taskStore.planThisWeekTask
            cell.task = thisWeek[indexPath.row]
            case 5: cell.task = taskStore.planLaterTask[indexPath.row]
            default: print("wrong index of filter for cell")
        }
        cell.delegate = self
        cell.initCellForPlannedViewController()
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let id: String
            switch currentFilter
            {
                case 0: id = taskStore.allTask[indexPath.row].taskID
                case 1: id = taskStore.planOverdueTask[indexPath.row].taskID
                case 2: id = taskStore.planTodayTask[indexPath.row].taskID
                case 3: id = taskStore.planTomorrowTask[indexPath.row].taskID
                case 4: id = taskStore.planThisWeekTask[indexPath.row].taskID
                case 5: id = taskStore.planLaterTask[indexPath.row].taskID
                default: id = ""
            }
            taskStore.removeByID(id: id)
            plannedTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select row at \(indexPath.row)")
        var taskSelect: Task = taskStore.taskNotFinished[indexPath.row]
        switch currentFilter
        {
            case 0: taskSelect = taskStore.taskNotFinished[indexPath.row]
            case 1: taskSelect = taskStore.planOverdueTask[indexPath.row]
            case 2: taskSelect = taskStore.planTodayTask[indexPath.row]
            case 3: taskSelect = taskStore.planTomorrowTask[indexPath.row]
            case 4: taskSelect = taskStore.planThisWeekTask[indexPath.row]
            case 5: taskSelect = taskStore.planLaterTask[indexPath.row]
            default:
                print("Wrong filter")
        }
        var detailTaskViewController = TaskMoreDetailViewController()
        detailTaskViewController.task = taskSelect
        detailTaskViewController.delegate = self
        detailTaskViewController.currentIndexPath = indexPath
        self.navigationController?.pushViewController(detailTaskViewController, animated: true)
        detailTaskViewController.reloadInputViews()
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
    func plannedFilterFloatViewController() {
        self.view.layer.opacity = 1.0
        plannedTableView.reloadData()
    }
    
    func plannedFilterFloatViewController(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentFilter = indexPath.row
        filterButton.setTitle(nameValue[indexPath.row], for: .normal)
        plannedTableView.reloadData()
    }
    
}

// MARK: - delegate from DeadlineViewController
extension PlannedViewController: DeadlineViewControllerDelegate
{
    func deadlineViewController(currentDateSelect datePicker: Date) {
        nextDate = datePicker
        dueButton.setTitle("Due \(nextDate.dayofTheWeek), \(nextDate.day) \(nextDate.monthString)", for: .normal)
    }
    
    func deadlineViewController(Opacity opacity: Float) {
        self.view.layer.opacity = opacity
    }
    
    func deadlineViewController(didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row
        {
            case 0:
                currentDeadlineType = .Today
                dueButton.setTitle("Due Today", for: .normal)
            case 1:
                currentDeadlineType = .Tomorrow
                dueButton.setTitle("Due Tomorrow", for: .normal)
            case 2:
                currentDeadlineType = .NextWeek
                dueButton.setTitle("Due Next Week", for: .normal)
            case 3:
                currentDeadlineType = .Other
                
            default: print("Wrong deadline!")
        }
    }
    
}

// MARK: - delegate from textField for returning
extension PlannedViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - delegate from TaskMoreDetailViewController

extension PlannedViewController: TaskMoreDetailViewControllerDelegate
{
    func taskMoreDetailViewController(targetTask target: Task, changeMyDayState state: Bool) {
        if(state)
        {
            target.secondTaskType = .myDay
        }
        else
        {
            target.secondTaskType = .normal
        }
        plannedTableView.reloadData()
    }
    
    func taskMoreDetailViewController(DeleteTarget target: Task) {
        taskStore.removeByID(id: target.taskID)
        plannedTableView.reloadData()
    }
    
    func taskMoreDetailViewController(changeToMyDay isMyDay: Bool) {
        self.isMyDay = isMyDay
    }
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isFinished = state
        if(state)
        {
            plannedTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        self.plannedTableView.reloadData()
    }
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapImportantButtonAtTask task: Task, didTapImportantButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isInterested = state
    }
    
    
}



