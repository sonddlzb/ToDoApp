//
//  TaskViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 13/04/2022.
//

import UIKit

class TaskViewController: UIViewController, UIViewControllerTransitioningDelegate {
        
    var taskStore: TaskStore!
    @IBOutlet weak private var taskTableView: UITableView!
    @IBOutlet weak private var addTaskTextField: UITextField!
    @IBOutlet weak var myDayButton: UIButton!
    @IBOutlet weak var dueButton: UIButton!
    @IBOutlet weak var viewMove: UIView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var moveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var isOnEditMode: Bool = false
    var isSelected: [Bool] = [Bool](repeating: false, count: 1000)
    static var backgroundColor: UIColor?
    var listStore: ListStore!
    var currentList: Int!
    var nextDate: Date!
    var currentDeadlineType: DeadlineType = .Today
    var isMyDay: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "Task"
        stackView.isHidden = true
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        let optionBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(listOptionDidTap(_:)))
        self.navigationItem.rightBarButtonItem  = optionBarButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(TaskViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TaskViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let color = TaskViewController.backgroundColor
        {
            TaskViewController.backgroundColor = color
            self.view.backgroundColor = color
            self.taskTableView.backgroundColor = color
            viewMove.backgroundColor = color
            addTaskTextField.backgroundColor = color
        }
        self.dueButton.setTitle("", for: .normal)
        self.nextDate = Date()
        taskTableView.reloadData()
    }
    
    // MARK: edit mode on
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
        taskTableView.reloadData()
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
        taskTableView.reloadData()
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
        listOptionView.taskType = .normal
        self.present(listOptionView, animated: true, completion: nil)
        self.view.layer.opacity = 0.5
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var isMoved: Bool = false
    @objc func keyboardWillShow(notification: NSNotification) {
        if(isMoved)
        {
            return
        }
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }

      // move the root view up by the distance of keyboard height
        bottomConstraint.constant += keyboardSize.height - 30
        isMoved =  true
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin
        bottomConstraint.constant = 0
        isMoved = false
    }
    
    // MARK:  tap turn on my day
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
    
    @IBAction func addTask(_ sender: UIButton) {
        if let taskName = addTaskTextField.text, !taskName.isEmpty
        {
            taskTableView.reloadData()
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
                newTask = Task(detail:taskName, taskType: .normal, timeCreate: Date(), timePlanned: nextDate!)
            }
            else
            {
                newTask = Task(detail:taskName, taskType: .normal, secondTaskType: .myDay, timeCreate: Date(), timePlanned: nextDate!)
            }
            taskStore.addTask(task: newTask)
            let index = taskStore.taskNotFinished.count - 1
            let indexPath = IndexPath(row: index, section: 0)
            taskTableView.insertRows(at: [indexPath], with: .automatic)
            addTaskTextField.text = ""
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
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
            return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    // MARK: - tap to return
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        addTaskTextField.resignFirstResponder()
    }

    // MARK: - select all tap
    @IBAction func selectAllTap(_ sender: UIButton)
    {
        var taskList: [Task] = taskStore.taskFinished + taskStore.taskNotFinished
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
            if(taskStore.taskNotFinished.count != 0)
            {
                for i in 0...(taskStore.taskNotFinished.count - 1)
                {
                    let indexPath = IndexPath(row: i, section: 0)
                    (taskTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                }
            }
            if(taskStore.taskFinished.count != 0)
            {
                for i in 0...(taskStore.taskFinished.count - 1)
                {
                    let indexPath = IndexPath(row: i, section: 1)
                    (taskTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                }
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
            if(taskStore.taskNotFinished.count != 0)
            {
                for i in 0...(taskStore.taskNotFinished.count - 1)
                {
                    let indexPath = IndexPath(row: i, section: 0)
                    (taskTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
                }
            }
            if(taskStore.taskFinished.count != 0)
            {
                for i in 0...(taskStore.taskFinished.count - 1)
                {
                    let indexPath = IndexPath(row: i, section: 1)
                    (taskTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
                }
            }
        }
        updateOptionButtons()
        
    }
    
    // MARK: - delete selected Tasks
    @IBAction func deleteSelectedTasksTap(_ sender: UIButton)
    {
        var taskList = taskStore.taskFinished + taskStore.taskNotFinished
        let alert = UIAlertController(title: nil, message: "Are you sure you want to permanently delete these tasks?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Delete task", style: .destructive)
        {   _ in
            var idRemove = [String]()
            for i in 0...taskList.count - 1
            {
                if(self.isSelected[i])
                {
                    if(i >= self.taskStore.taskNotFinished.count)
                    {
                        idRemove.append(self.taskStore.taskFinished[i - self.taskStore.taskNotFinished.count].taskID)
                        self.isSelected[i] = false
                    }
                    else
                    {
                        idRemove.append(self.taskStore.taskNotFinished[i].taskID)
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
    // MARK: - update option buttons
    func updateOptionButtons()
    {
        var taskList = taskStore.taskNotFinished + taskStore.taskFinished
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
        if let value = isSelected.firstIndex(of: false), value < taskList.count
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
    
}

// MARK: - delegate from tableView
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
        cell.isOnEditMode = isOnEditMode
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //display task detail screen for each task
        if(!isOnEditMode)
        {
            let detailTaskViewController = TaskMoreDetailViewController()
            if(indexPath.section == 0)
            {
                detailTaskViewController.task = taskStore.taskNotFinished[indexPath.row]
            }
            else
            {
                detailTaskViewController.task = taskStore.taskFinished[indexPath.row]
            }
            detailTaskViewController.delegate = self
            detailTaskViewController.currentIndexPath = indexPath
            detailTaskViewController.isMyDay = true
            self.navigationController?.pushViewController(detailTaskViewController, animated: true)
        }
    }
}

// MARK: - delegate from textField for returning
extension TaskViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - delegate from cell
extension TaskViewController: TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task,didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        if(!isOnEditMode)
        {
        task.isFinished = state
        taskTableView.reloadSections([0,1], with: .automatic)
        }
        else
        {
            var indexPath: IndexPath = taskTableView.indexPath(for: cell)!
            if(indexPath.section == 0)
            {
                isSelected[indexPath.row] = state
            }
            else
            {
                isSelected[indexPath.row + taskStore.taskNotFinished.count] = state
            }
            print(taskTableView.indexPath(for: cell)!.row)
            updateOptionButtons()
        }
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

// MARK: -Deadline ViewController
extension TaskViewController: DeadlineViewControllerDelegate
{
    func deadlineViewController(currentDateSelect datePicker: Date) {
        nextDate = datePicker
        if(isOnEditMode)
        {
            for (index,value) in isSelected.enumerated()
            {
                if(value)
                {
                    if(index >= self.taskStore.taskNotFinished.count)
                    {
                        self.taskStore.taskFinished[index - self.taskStore.taskNotFinished.count].timePlanned = nextDate
                    }
                    else
                    {
                        self.taskStore.taskNotFinished[index].timePlanned = nextDate
                    }
                }
            }
            taskTableView.reloadData()
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
                    if(index >= self.taskStore.taskNotFinished.count)
                    {
                        self.taskStore.taskFinished[index - self.taskStore.taskNotFinished.count].timePlanned = nextDate
                    }
                    else
                    {
                        self.taskStore.taskNotFinished[index].timePlanned = nextDate
                    }
                }
            }
            if(currentDeadlineType != .Other)
            {
                stackViewDismiss()
            }
            
        }
        taskTableView.reloadData()
    }
    
    
}

// MARK: - Task More Detail View Controller
extension TaskViewController: TaskMoreDetailViewControllerDelegate
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
        taskTableView.reloadData()
    }
    
    func taskMoreDetailViewController(DeleteTarget target: Task) {
        taskStore.removeByID(id: target.taskID)
        taskTableView.reloadData()
    }
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isFinished = state
        if(state)
        {
            taskTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        self.taskTableView.reloadData()
    }
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapImportantButtonAtTask task: Task, didTapImportantButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isInterested = state
    }
    
    
}

// MARK: - add TapGestureRecognizer
extension TaskViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension TaskViewController: ListOptionViewControllerDelegate
{
    func listOptionViewController(Opacity opacity: Float) {
        self.view.layer.opacity = opacity
        self.taskTableView.reloadData()
    }
    
    func listOptionViewController() {
        stackViewAppear()
        updateOptionButtons()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(stackViewDismiss))
        self.navigationItem.setRightBarButton(cancelButton, animated: true)
    }
    
    func listOptionViewController(setBackgroundColorTo newColor: UIColor) {
        TaskViewController.backgroundColor = newColor
        self.view.backgroundColor = newColor
        self.taskTableView.backgroundColor = newColor
        viewMove.backgroundColor = newColor
        addTaskTextField.backgroundColor = newColor
    }
    
    func listOptionViewController(changeCompletedTaskPropertyTo newState: Bool) {
        
    }
}
