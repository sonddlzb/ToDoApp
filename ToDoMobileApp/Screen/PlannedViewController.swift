//
//  PlannedViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 15/04/2022.
//

import UIKit
import SwiftUI
class PlannedViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var isOnEditMode: Bool = false
    static var showCompletedTask: Bool = false
    var taskStore: TaskStore!
    var currentFilter: Int = 0
    var isMyDay = false
    var nextDate: Date!
    var currentDeadlineType: DeadlineType = .Today

    var isSelected: [Bool] = [Bool](repeating: false, count: 1000)
    let nameValue = ["All Planned", "Overdue", "Today", "Tomorrow", "This Week", "Later"]
    static var backgroundColor: UIColor?
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addTaskTextField: UITextField!
    @IBOutlet weak var plannedTableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var myDayButton: UIButton!
    @IBOutlet weak var dueButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var viewMove: UIView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var moveButton: UIButton!
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.plannedTableView.separatorColor = .white
        addTaskTextField.placeholder = "Add a Task"
        stackView.isHidden = true
        self.hideKeyboardWhenTappedAround()
        let optionBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(listOptionDidTap(_:)))
        self.navigationItem.rightBarButtonItem  = optionBarButtonItem
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
        if let color = PlannedViewController.backgroundColor
        {
            PlannedViewController.backgroundColor = color
            self.view.backgroundColor = color
            self.plannedTableView.backgroundColor = color
            viewMove.backgroundColor = color
            addTaskTextField.backgroundColor = color
        }
        self.dueButton.setTitle("", for: .normal)
        self.nextDate = Date()
        plannedTableView.reloadData()
    }
    // MARK: -edit mode on
    func stackViewAppear()
    {
        
        isOnEditMode = true
        stackView.isHidden = false
        viewMove.isHidden = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
        let leadingConstraint = stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingConstraint = stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        bottomConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        plannedTableView.reloadData()
    }
    
    // MARK: -edit mode off
    @objc func stackViewDismiss()
    {
        isSelected = [Bool](repeating: false, count: 1000)
        isOnEditMode = false
        stackView.isHidden = true
        viewMove.isHidden = false
        let optionBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(listOptionDidTap(_:)))
        self.navigationItem.setRightBarButton(optionBarButtonItem, animated: true)
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
            print("due is \(newTask.due)")
            taskStore.addTask(task: newTask)
            var index: Int
            switch currentFilter
            {
                case 0: index = taskStore.planTask.count - 1
                case 1: index = taskStore.planOverdueTask.count - 1
                case 2: index = taskStore.planTodayTask.count - 1
                case 3: index = taskStore.planTomorrowTask.count - 1
                case 4: index = taskStore.planThisWeekTask.count - 1
                case 5: index = taskStore.planLaterTask.count - 1
                default: index = 0
            }
            let indexPath = IndexPath(row: index, section: 0)
            if newTask.due.rawValue == currentFilter || currentFilter == 0
            {
                
                plannedTableView.insertRows(at: [indexPath], with: .automatic)
            }
            addTaskTextField.text = ""
        }
        self.dueButton.setTitle("", for: .normal)
        self.nextDate = Date()
    }
    // MARK: - select all tap
    @IBAction func selectAllTap(_ sender: UIButton)
    {
        var taskList: [Task]
        if(PlannedViewController.showCompletedTask)
        {
            taskList = self.taskStore.bothPlanTask
        }
        else
        {
            taskList = self.taskStore.planTask
        }
        if(taskList.count == 0)
        {
            return
        }
        if let title = sender.titleLabel?.text, title == "Select all"
        {
            sender.setTitle("Clear all", for: .normal)
            let attributeText = NSMutableAttributedString(string: sender.title(for: .normal) ?? "", attributes: [
                .font: UIFont(name: "Times New Roman", size: CGFloat(12))!
            ])
            sender.setAttributedTitle(attributeText, for: .normal)
            //selectAllButton.setNeedsUpdateConfiguration()
            print(selectAllButton.titleLabel?.font)
            print(selectAllButton.titleLabel?.attributedText)
            sender.titleLabel?.numberOfLines = 1
            isSelected = [Bool](repeating: true, count: taskList.count)
            for i in 0...(taskList.count - 1)
            {
                let indexPath = IndexPath(row: i, section: 0)
                (plannedTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            }
        }
        else
        {
            sender.setTitle("Select all", for: .normal)
            let attributeText = NSMutableAttributedString(string: sender.title(for: .normal) ?? "", attributes: [
                .font: UIFont(name: "Times New Roman", size: CGFloat(12))!
            ])
            sender.setAttributedTitle(attributeText, for: .normal)
            isSelected = [Bool](repeating: false, count: taskList.count)
            for i in 0...(taskList.count - 1)
            {
                let indexPath = IndexPath(row: i, section: 0)
                (plannedTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
        updateOptionButtons()
        
    }
    
    // MARK: - delete selected Tasks
    @IBAction func deleteSelectedTasksTap(_ sender: UIButton)
    {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to permanently delete these tasks?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Delete task", style: .destructive)
        {   _ in
            var idRemove = [String]()
            for i in 0...((PlannedViewController.showCompletedTask) ? (self.taskStore.bothPlanTask.count-1) : (self.taskStore.planTask.count - 1))
            {
                if(self.isSelected[i])
                {
                    if(PlannedViewController.showCompletedTask)
                    {
                        idRemove.append(self.taskStore.bothPlanTask[i].getTaskID())
                        self.isSelected[i] = false
                    }
                    else
                    {
                        idRemove.append(self.taskStore.planTask[i].getTaskID())
                        self.isSelected[i] = false
                    }
                }
            }
            for value in idRemove
            {
                self.taskStore.removeByID(id: value)
            }
            self.stackViewDismiss()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert,animated: true, completion: nil)
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
            myDayButton.setTitleColor(UIColor.white, for: .normal)
        }
        else
        {
            isMyDay = false
            myDayButton.backgroundColor = view.backgroundColor
            myDayButton.setTitle("", for: .normal)
        }
    }
    
    // MARK: - tap to return
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        addTaskTextField.resignFirstResponder()
    }
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var isMoved: Bool = false;
    // MARK: - keyboard show
    @objc func keyboardWillShow(notification: NSNotification) {
        if(isMoved)
        {
            return;
        }
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }

      // move the root view up by the distance of keyboard height
        //self.viewMove.frame.origin.y = view.bounds.height - keyboardSize.height - viewMove.bounds.height
        self.bottomConstraint.constant -= keyboardSize.height - 30
        self.view.layoutIfNeeded()
        isMoved = true
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin
        self.bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
        isMoved = false
    }
     
    // MARK: - update option buttons
    func updateOptionButtons()
    {
        if let value = isSelected.firstIndex(of: true)
        {
            moveButton.tintColor = UIColor.systemBlue
            dueDateButton.tintColor = UIColor.systemBlue
            deleteButton.tintColor = UIColor.red
            deleteButton.isUserInteractionEnabled = true
            dueDateButton.isUserInteractionEnabled = true
            moveButton.isUserInteractionEnabled = true
        }
        else
        {
            if let title = selectAllButton.titleLabel?.text, title == "Clear all"
            {
                selectAllButton.setTitle("Select all", for: .normal)
                let attributeText = NSMutableAttributedString(string: selectAllButton.title(for: .normal) ?? "", attributes: [
                    .font: UIFont(name: "Times New Roman", size: CGFloat(12))!
                ])
                selectAllButton.setAttributedTitle(attributeText, for: .normal)
            }
            moveButton.tintColor = UIColor.black
            dueDateButton.tintColor = UIColor.black
            deleteButton.tintColor = UIColor.black
            deleteButton.isUserInteractionEnabled = false
            dueDateButton.isUserInteractionEnabled = false
            moveButton.isUserInteractionEnabled = false
        }
        if let value = isSelected.firstIndex(of: false), value < ((PlannedViewController.showCompletedTask) ?  taskStore.bothPlanTask.count : taskStore.planTask.count)
        {
            
        }
        else
        {
            if let title = selectAllButton.titleLabel?.text, title == "Select all"
            {
                selectAllButton.setTitle("Clear all", for: .normal)
                let attributeText = NSMutableAttributedString(string: selectAllButton.title(for: .normal) ?? "", attributes: [
                    .font: UIFont(name: "Times New Roman", size: CGFloat(12))!
                ])
                selectAllButton.setAttributedTitle(attributeText, for: .normal)
            }
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
        self.view.layer.opacity = 0.5
    }
    
    // MARK: -tap list option
    @objc func listOptionDidTap(_ sender: UIBarButtonItem)
    {
        print("Load list of options presentation")
        let listOptionView = ListOptionViewController()
        listOptionView.modalTransitionStyle = .coverVertical
        listOptionView.modalPresentationStyle = .custom
        listOptionView.transitioningDelegate = self
        listOptionView.delegate = self
        listOptionView.taskStore = taskStore
        listOptionView.taskType = .planned
        listOptionView.showCompletedTask = PlannedViewController.showCompletedTask
        self.present(listOptionView, animated: true, completion: nil)
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
        if(!PlannedViewController.showCompletedTask)
        {
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
        else
        {
            switch currentFilter
            {
                case 0: return taskStore.bothPlanTask.count
                case 1: return taskStore.bothPlanOverdueTask.count
                case 2: return taskStore.bothPlanTodayTask.count
                case 3: return taskStore.bothPlanTomorrowTask.count
                case 4: return taskStore.bothPlanThisWeekTask.count + taskStore.bothPlanTomorrowTask.count + taskStore.bothPlanTodayTask.count
                case 5: return taskStore.bothPlanLaterTask.count
                default: print("wrong index of filter")
            }
            return taskStore.bothPlanTask.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = plannedTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        if(!PlannedViewController.showCompletedTask)
        {
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
        }
        else
        {
            switch currentFilter
            {
                case 0: cell.task = taskStore.bothPlanTask[indexPath.row]
                case 1: cell.task = taskStore.bothPlanOverdueTask[indexPath.row]
                case 2: cell.task = taskStore.bothPlanTodayTask[indexPath.row]
                case 3: cell.task = taskStore.bothPlanTomorrowTask[indexPath.row]
                case 4:
                let thisWeek = taskStore.bothPlanTodayTask + taskStore.bothPlanTomorrowTask + taskStore.bothPlanThisWeekTask
                cell.task = thisWeek[indexPath.row]
                case 5: cell.task = taskStore.bothPlanLaterTask[indexPath.row]
                default: print("wrong index of filter for cell")
            }
        }
        cell.delegate = self
        cell.isOnEditMode = isOnEditMode
        cell.initCellForPlannedViewController(showCompletedTaskState: PlannedViewController.showCompletedTask)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let id: String
            if(!PlannedViewController.showCompletedTask)
            {
                switch currentFilter
                {
                    case 0: id = taskStore.allTask[indexPath.row].getTaskID()
                    case 1: id = taskStore.planOverdueTask[indexPath.row].getTaskID()
                    case 2: id = taskStore.planTodayTask[indexPath.row].getTaskID()
                    case 3: id = taskStore.planTomorrowTask[indexPath.row].getTaskID()
                    case 4: id = taskStore.planThisWeekTask[indexPath.row].getTaskID()
                    case 5: id = taskStore.planLaterTask[indexPath.row].getTaskID()
                    default: id = ""
                }
                taskStore.removeByID(id: id)
                plannedTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!isOnEditMode)
        {
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
}
// MARK: - delegate from cell
extension PlannedViewController: TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.getDetail())!")
        if(!isOnEditMode)
        {
            task.setIsFinished(newState: state)
            if(!PlannedViewController.showCompletedTask)
            {
                let indexPath = plannedTableView.indexPath(for: cell)
                if let index = indexPath
                {
                    plannedTableView.deleteRows(at: [index], with: .automatic)
                }
                else
                {
                    print("Unexpected error!")
                }
            }
        }
        else
        {
            isSelected[plannedTableView.indexPath(for: cell)!.row] = state
            print(plannedTableView.indexPath(for: cell)!.row)
            updateOptionButtons()
        }
        //importantTableView.reloadData()
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        print("update finished database of \(task.getDetail())!")
        task.setIsInterested(newState: state)

    }
    
}

// MARK: - PlannedFilterFloatViewControlle
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

// MARK: - DeadlineViewController
extension PlannedViewController: DeadlineViewControllerDelegate
{
    func deadlineViewController(currentDateSelect datePicker: Date) {
        nextDate = datePicker
        
        if(isOnEditMode)
        {
            for (index,value) in isSelected.enumerated()
            {
                if(value)
                {
                    if(!PlannedViewController.showCompletedTask)
                    {
                        taskStore.planTask[index].setTimePlanned(newTime: nextDate)
                    }
                    else
                    {
                        taskStore.bothPlanTask[index].setTimePlanned(newTime: nextDate)
                    }
                }
            }
            plannedTableView.reloadData()
            stackViewDismiss()
            
            
        }
        else
        {
            dueButton.setTitle("Due \(nextDate.dayofTheWeek), \(nextDate.day) \(nextDate.monthString)", for: .normal)
        }
        let attributeText = NSMutableAttributedString(string: dueButton.title(for: .normal) ?? "", attributes: [
            .font: UIFont(name: "Times New Roman", size: CGFloat(12))!
        ])
        dueButton.setAttributedTitle(attributeText, for: .normal)
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
        let attributeText = NSMutableAttributedString(string: dueButton.title(for: .normal) ?? "", attributes: [
            .font: UIFont(name: "Times New Roman", size: CGFloat(12))!
        ])
        dueButton.setAttributedTitle(attributeText, for: .normal)
        if(isOnEditMode)
        {
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
            for (index,value) in isSelected.enumerated()
            {
                if(value)
                {
                    if(PlannedViewController.showCompletedTask)
                    {
                        self.taskStore.bothPlanTask[index].setTimePlanned(newTime: nextDate)
                    }
                    else
                    {
                        self.taskStore.planTask[index].setTimePlanned(newTime: nextDate)
                    }
                }
            }
            if(currentDeadlineType != .Other)
            {
                stackViewDismiss()
            }
            plannedTableView.reloadData()
            
        }
    }
    
}

// MARK: - textField
extension PlannedViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - TaskMoreDetailViewController

extension PlannedViewController: TaskMoreDetailViewControllerDelegate
{
    func taskMoreDetailViewController(targetTask target: Task, changeMyDayState state: Bool) {
        if(state)
        {
            target.setSecondTaskType(newTaskType: .myDay)
        }
        else
        {
            target.setSecondTaskType(newTaskType: .normal)
        }
        plannedTableView.reloadData()
    }
    
    func taskMoreDetailViewController(DeleteTarget target: Task) {
        taskStore.removeByID(id: target.getTaskID())
        plannedTableView.reloadData()
    }
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.getDetail())!")
        task.setIsFinished(newState: state)
        if(state)
        {
            plannedTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        self.plannedTableView.reloadData()
    }
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapImportantButtonAtTask task: Task, didTapImportantButtonToState state: Bool) {
        print("update finished database of \(task.getDetail())!")
        task.setIsInterested(newState: state)
    }
    
    
}

// MARK: - ListOptionViewController
extension PlannedViewController: ListOptionViewControllerDelegate
{
    func listOptionViewController(changeCompletedTaskPropertyTo newState: Bool) {
        PlannedViewController.showCompletedTask = newState
        self.plannedTableView.reloadData()
    }
    
    func listOptionViewController(setBackgroundColorTo newColor: UIColor) {
        PlannedViewController.backgroundColor = newColor
        self.view.backgroundColor = newColor
        self.plannedTableView.backgroundColor = newColor
        viewMove.backgroundColor = newColor
        addTaskTextField.backgroundColor = newColor
    }
    
    func listOptionViewController() {
        stackViewAppear()
        updateOptionButtons()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(stackViewDismiss))
        self.navigationItem.setRightBarButton(cancelButton, animated: true)
        
    }
    
    func listOptionViewController(Opacity opacity: Float) {
        self.view.layer.opacity = opacity
        self.plannedTableView.reloadData()
    }
    

}

// MARK: - add TapGestureRecognizer
extension PlannedViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



