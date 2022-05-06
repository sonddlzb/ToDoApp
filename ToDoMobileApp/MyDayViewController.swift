//
//  MyDayViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 15/04/2022.
//

import UIKit

class MyDayViewController: UIViewController, UIViewControllerTransitioningDelegate {
    @IBOutlet weak private var myDayTableView: UITableView!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var addTaskTextField: UITextField!
    @IBOutlet weak var myDayButton: UIButton!
    @IBOutlet weak var dueButton: UIButton!
    @IBOutlet weak var viewMove: UIView!
    @IBOutlet weak var moveButton: UIButton!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var isOnEditMode: Bool = false
    var taskStore: TaskStore!
    var nextDate: Date!
    var listStore: ListStore!
    var currentDeadlineType: DeadlineType = .Today
    var isSelected: [Bool] = [Bool](repeating: false, count: 1000)
    static var backgroundColor: UIColor?
    var myDayTaskFinished: [Task]
    {
        var res = [Task]()
        for value in taskStore.allTask
        {
            if value.taskType == .myDay && value.isFinished
            {
                res.append(value)
            }
            if value.secondTaskType == .myDay && value.isFinished
            {
                res.append(value)
            }
        }
        for list in listStore.allList
        {
            for task in list.listOfTask
            {
                if(task.secondTaskType == .myDay && task.isFinished)
                {
                    res.append(task)
                }
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
            if value.secondTaskType == .myDay && !value.isFinished
            {
                res.append(value)
            }
        }
        for list in listStore.allList
        {
            for task in list.listOfTask
            {
                if(task.secondTaskType == .myDay && !task.isFinished)
                {
                    res.append(task)
                }
            }
        }
        return res
    }
    
    func initUI()
    {
        let date = Date()
        dateLabel.text = date.dayofTheWeek + ", " + date.day + " " + date.monthString
        view.backgroundColor = UIColor.white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        self.hideKeyboardWhenTappedAround()
        addTaskTextField.placeholder = "Add a Task"
        stackView.isHidden = true
        let optionBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(listOptionDidTap(_:)))
        self.navigationItem.rightBarButtonItem  = optionBarButtonItem
        myDayTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        myDayTableView.delegate = self
        myDayTableView.dataSource = self
        addTaskTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(MyDayViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyDayViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let color = MyDayViewController.backgroundColor
        {
            MyDayViewController.backgroundColor = color
            self.view.backgroundColor = color
            self.myDayTableView.backgroundColor = color
            viewMove.backgroundColor = color
            addTaskTextField.backgroundColor = color
        }
        self.dueButton.setTitle("", for: .normal)
        self.nextDate = Date()
        myDayTableView.reloadData()
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
        myDayTableView.reloadData()
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
        myDayTableView.reloadData()
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
        listOptionView.taskType = .myDay
        self.present(listOptionView, animated: true, completion: nil)
        self.view.layer.opacity = 0.5
    }

    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var isMoved: Bool = false
    //move viewMove to keyboard
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
        isMoved = true
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin
        bottomConstraint.constant = 0
        isMoved = false
    }
    @IBAction func addTask(_ sender: UIButton) {
        if let taskName = addTaskTextField.text, !taskName.isEmpty
        {
            //determine due date for new Task
            var dayComponent = DateComponents()
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
            let newTask: Task
            newTask = Task(detail:taskName, taskType: .myDay, timeCreate: Date(), timePlanned: nextDate!)
            taskStore.addTask(task: newTask)
            let index = myDayTaskNotFinished.count - 1
            let indexPath = IndexPath(row: index, section: 0)
            myDayTableView.insertRows(at: [indexPath], with: .automatic)
            addTaskTextField.text = ""
        }
    }
    
    // MARK: - select all tap
    @IBAction func selectAllTap(_ sender: UIButton)
    {
        var taskList: [Task] = self.myDayTaskFinished + self.myDayTaskNotFinished
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
            if(myDayTaskNotFinished.count != 0)
            {
                for i in 0...(myDayTaskNotFinished.count - 1)
                {
                    let indexPath = IndexPath(row: i, section: 0)
                    (myDayTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                }
            }
            if(myDayTaskFinished.count != 0)
            {
                for i in 0...(myDayTaskFinished.count - 1)
                {
                    let indexPath = IndexPath(row: i, section: 1)
                    (myDayTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
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
            if(myDayTaskNotFinished.count != 0)
            {
                for i in 0...(myDayTaskNotFinished.count - 1)
                {
                    let indexPath = IndexPath(row: i, section: 0)
                    (myDayTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
                }
            }
            if(myDayTaskFinished.count != 0)
            {
                for i in 0...(myDayTaskFinished.count - 1)
                {
                    let indexPath = IndexPath(row: i, section: 1)
                    (myDayTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
                }
            }
        }
        updateOptionButtons()
        
    }
    
    // MARK: - delete selected Tasks
    @IBAction func deleteSelectedTasksTap(_ sender: UIButton)
    {
        var taskList = myDayTaskFinished + myDayTaskNotFinished
        let alert = UIAlertController(title: nil, message: "Are you sure you want to permanently delete these tasks?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Delete task", style: .destructive)
        {   _ in
            var idRemove = [String]()
            for i in 0...taskList.count - 1
            {
                if(self.isSelected[i])
                {
                    if(i >= self.myDayTaskNotFinished.count)
                    {
                        idRemove.append(self.myDayTaskFinished[i - self.myDayTaskNotFinished.count].taskID)
                        self.isSelected[i] = false
                    }
                    else
                    {
                        idRemove.append(self.myDayTaskNotFinished[i].taskID)
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
        var taskList = myDayTaskFinished + myDayTaskNotFinished
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
    
    @IBAction func deadlineDidTap(_ sender: UIButton)
    {
        //display deadline picker screen
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
        cell.isOnEditMode = isOnEditMode
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
            return "Completed \(number)"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let id: String
            if(indexPath.section == 0)
            {
                id = myDayTaskNotFinished[indexPath.row].taskID
            }
            else
            {
                id = myDayTaskFinished[indexPath.row].taskID
            }
                taskStore.removeByID(id: id)
                myDayTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(!isOnEditMode)
        {
        //display task detail screen for each task
        let detailTaskViewController = TaskMoreDetailViewController()
        if(indexPath.section == 0)
        {
            detailTaskViewController.task = myDayTaskNotFinished[indexPath.row]
        }
        else
        {
            detailTaskViewController.task = myDayTaskFinished[indexPath.row]
        }
        detailTaskViewController.delegate = self
        detailTaskViewController.currentIndexPath = indexPath
        detailTaskViewController.isMyDay = true
        self.navigationController?.pushViewController(detailTaskViewController, animated: true)
    }
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

// MARK: - delegate from cell
extension MyDayViewController: TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task,didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        if(!isOnEditMode)
        {
            task.isFinished = state
            myDayTableView.reloadSections([0,1], with: .automatic)
        }
        else
        {
            var indexPath: IndexPath = myDayTableView.indexPath(for: cell)!
            if(indexPath.section == 0)
            {
                isSelected[indexPath.row] = state
            }
            else
            {
                isSelected[indexPath.row + myDayTaskNotFinished.count] = state
            }
            print(myDayTableView.indexPath(for: cell)!.row)
            updateOptionButtons()
        }
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        print("update interested database of \(task.detail)!")
        task.isInterested = state
    }
    
}

// MARK: -Task Detail View Controller
extension MyDayViewController: TaskMoreDetailViewControllerDelegate
{
    //change my day property in task detail screen
    func taskMoreDetailViewController(targetTask target: Task, changeMyDayState state: Bool) {
        if(state)
        {
            target.taskType = .myDay
        }
        else
        {
            target.taskType = .normal
        }
        myDayTableView.reloadData()
    }
    
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isFinished = state
        self.myDayTableView.reloadData()
    }
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapImportantButtonAtTask task: Task, didTapImportantButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isInterested = state
    }
    
    //delete a task from task detail screen
    func taskMoreDetailViewController(DeleteTarget target: Task) {
        taskStore.removeByID(id: target.taskID)
        myDayTableView.reloadData()
    }
}

// MARK: - DeadlineDelegate
extension MyDayViewController: DeadlineViewControllerDelegate
{
    //receive due type from Deadline screen
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
                    if(index >= self.myDayTaskNotFinished.count)
                    {
                        self.myDayTaskFinished[index - self.myDayTaskNotFinished.count].timePlanned = nextDate
                    }
                    else
                    {
                        self.myDayTaskNotFinished[index].timePlanned = nextDate
                    }
                }
            }
            if(currentDeadlineType != .Other)
            {
                stackViewDismiss()
            }
            
        }
        myDayTableView.reloadData()
    }
    
    func deadlineViewController(Opacity opacity: Float) {
        self.view.layer.opacity = opacity
    }
    
    //get date from date picker
    func deadlineViewController(currentDateSelect datePicker: Date) {
        nextDate = datePicker
        if(isOnEditMode)
        {
            for (index,value) in isSelected.enumerated()
            {
                if(value)
                {
                    if(index >= self.myDayTaskNotFinished.count)
                    {
                        self.myDayTaskFinished[index - self.myDayTaskNotFinished.count].timePlanned = nextDate
                    }
                    else
                    {
                        self.myDayTaskNotFinished[index].timePlanned = nextDate
                    }
                }
            }
            myDayTableView.reloadData()
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
    
    
}
// MARK: - add TapGestureRecognizer
extension MyDayViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MyDayViewController: ListOptionViewControllerDelegate
{
    func listOptionViewController(Opacity opacity: Float) {
        self.view.layer.opacity = opacity
        self.myDayTableView.reloadData()
    }
    
    func listOptionViewController() {
        stackViewAppear()
        updateOptionButtons()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(stackViewDismiss))
        self.navigationItem.setRightBarButton(cancelButton, animated: true)
    }
    
    func listOptionViewController(setBackgroundColorTo newColor: UIColor) {
        MyDayViewController.backgroundColor = newColor
        self.view.backgroundColor = newColor
        self.myDayTableView.backgroundColor = newColor
        viewMove.backgroundColor = newColor
        addTaskTextField.backgroundColor = newColor
    }
    
    func listOptionViewController(changeCompletedTaskPropertyTo newState: Bool) {
        
    }
    
    
}
