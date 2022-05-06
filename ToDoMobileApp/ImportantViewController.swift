//
//  ImportantViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 13/04/2022.
//

import UIKit

class ImportantViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak private var addTaskTextField: UITextField!
    @IBOutlet weak private var importantTableView: UITableView!
    @IBOutlet weak var myDayButton: UIButton!
    @IBOutlet weak var dueButton: UIButton!
    @IBOutlet weak var viewMove: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var moveButton: UIButton!
    @IBOutlet weak var dueDateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var listStore: ListStore!
    var taskStore: TaskStore!
    var isOnEditMode: Bool = false
    static var backgroundColor: UIColor?
    static var showCompletedTask: Bool = false
    var isSelected: [Bool] = [Bool](repeating: false, count: 1000)
    var importantTaskNotFinished: [Task]
    {
        let res = listStore.importantTaskListStoreNotFinished + taskStore.importantTaskTaskStoreNotFinished
        return res
    }
    var importantTaskBoth: [Task]
    {
        let res = listStore.importantTaskListStoreBoth + taskStore.importantTaskTaskStoreBoth
        return res
    }
    var nextDate: Date!
    var currentDeadlineType: DeadlineType = .Today
    var isMyDay = false
    //combine important tasks in both listStore and taskStore
    override func viewDidLoad() {

        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "Important"
        stackView.isHidden = true
        let optionBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(listOptionDidTap(_:)))
        self.navigationItem.rightBarButtonItem  = optionBarButtonItem
        importantTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        importantTableView.reloadData()
        importantTableView.delegate = self
        importantTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(ImportantViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ImportantViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let color = ImportantViewController.backgroundColor
        {
            ImportantViewController.backgroundColor = color
            self.view.backgroundColor = color
            self.importantTableView.backgroundColor = color
            viewMove.backgroundColor = color
            addTaskTextField.backgroundColor = color
        }
        self.dueButton.setTitle("", for: .normal)
        self.nextDate = Date()
        importantTableView.reloadData()
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
        importantTableView.reloadData()
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
        importantTableView.reloadData()
    }
    
    // MARK: - select all tap
    @IBAction func selectAllTap(_ sender: UIButton)
    {
        var taskList: [Task]
        if(ImportantViewController.showCompletedTask)
        {
            taskList = self.importantTaskBoth
        }
        else
        {
            taskList = self.importantTaskNotFinished
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
            sender.titleLabel?.numberOfLines = 1
            isSelected = [Bool](repeating: true, count: taskList.count)
            for i in 0...(taskList.count - 1)
            {
                let indexPath = IndexPath(row: i, section: 0)
                (importantTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
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
                (importantTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
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
            for i in 0...((ImportantViewController.showCompletedTask) ? (self.importantTaskBoth.count-1) : (self.taskStore.importantTaskTaskStoreNotFinished.count - 1))
            {
                if(self.isSelected[i])
                {
                    if(ImportantViewController.showCompletedTask)
                    {
                        idRemove.append(self.importantTaskBoth[i].taskID)
                        self.isSelected[i] = false
                    }
                    else
                    {
                        idRemove.append(self.importantTaskNotFinished[i].taskID)
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
        if let value = isSelected.firstIndex(of: false), value < ((ImportantViewController.showCompletedTask) ?  importantTaskBoth.count : importantTaskNotFinished.count)
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
        listOptionView.taskType = .important
        listOptionView.showCompletedTask = ImportantViewController.showCompletedTask
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
        bottomConstraint.constant -= keyboardSize.height - 30
        isMoved = true
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin
        bottomConstraint.constant = 0
        isMoved = false
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
    // MARK: - tap turn on my day
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
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
            return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    @IBAction func addTask(_ sender: UIButton) {
        if let taskName = addTaskTextField.text, !taskName.isEmpty
        {
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
            if(!isMyDay)
            {
                newTask = Task(detail:taskName, taskType: .important, timeCreate: Date(), timePlanned: nextDate!)
            }
            else
            {
                newTask = Task(detail:taskName, taskType: .important, secondTaskType: .myDay, timeCreate: Date(), timePlanned: nextDate!)
            }
            taskStore.addTask(task: newTask)
            let index = importantTaskNotFinished.count - 1
            let indexPath = IndexPath(row: index, section: 0)
            importantTableView.insertRows(at: [indexPath], with: .automatic)
            addTaskTextField.text = ""
        }
    }
    
    // MARK: - tap to return
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        addTaskTextField.resignFirstResponder()
    }
}

// MARK: - table render
extension ImportantViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!ImportantViewController.showCompletedTask)
        {
            return importantTaskNotFinished.count
        }
        else
        {
            return importantTaskBoth.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = importantTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        cell.taskStore = taskStore
        cell.isOnEditMode = self.isOnEditMode
        if(!ImportantViewController.showCompletedTask)
        {
            cell.initCellForImportantViewController(indexPath: indexPath, listOfImportantTask: importantTaskNotFinished)
        }
        else
        {
            cell.initCellForImportantViewController(indexPath: indexPath, listOfImportantTask: importantTaskBoth)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //display task detail screen for each task
        if(!isOnEditMode)
        {
            let detailTaskViewController = TaskMoreDetailViewController()
            if(!ImportantViewController.showCompletedTask)
            {
                detailTaskViewController.task = importantTaskNotFinished[indexPath.row]
                detailTaskViewController.isMyDay = (importantTaskNotFinished[indexPath.row].secondTaskType == .myDay)
            }
            else
            {
                detailTaskViewController.task = importantTaskBoth[indexPath.row]
                detailTaskViewController.isMyDay = (importantTaskBoth[indexPath.row].secondTaskType == .myDay)
            }
            detailTaskViewController.delegate = self
            detailTaskViewController.currentIndexPath = indexPath
            self.navigationController?.pushViewController(detailTaskViewController, animated: true)
        }
    }

}
// MARK: - delegate from UITextField

extension ImportantViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - delegate from cell

extension ImportantViewController: TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        if(!isOnEditMode)
        {
            task.isFinished = state
            if(!ImportantViewController.showCompletedTask)
            {
                let indexPath = importantTableView.indexPath(for: cell)
                if let index = indexPath
                {
                    importantTableView.deleteRows(at: [index], with: .automatic)
                }
                else
                {
                    print("Unexpected error!")
                }
            }
        }
        else
        {
            isSelected[importantTableView.indexPath(for: cell)!.row] = state
            print(importantTableView.indexPath(for: cell)!.row)
            updateOptionButtons()
        }
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isInterested = state
        let indexPath = importantTableView.indexPath(for: cell)
        importantTableView.deleteRows(at: [indexPath!], with: .automatic)
    }
    
    
}

// MARK: - deadline View controller
extension ImportantViewController: DeadlineViewControllerDelegate
{
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
                    if(ImportantViewController.showCompletedTask)
                    {
                        importantTaskBoth[index].timePlanned = nextDate
                    }
                    else
                    {
                        importantTaskNotFinished[index].timePlanned = nextDate
                    }
                }
            }
            if(currentDeadlineType != .Other)
            {
                stackViewDismiss()
            }
            importantTableView.reloadData()
            
        }
    }
    
    func deadlineViewController(Opacity opacity: Float) {
        self.view.layer.opacity = opacity
    }
    
    func deadlineViewController(currentDateSelect datePicker: Date) {
        nextDate = datePicker
        if(isOnEditMode)
        {
            for (index,value) in isSelected.enumerated()
            {
                if(value)
                {
                    if(!ImportantViewController.showCompletedTask)
                    {
                        importantTaskNotFinished[index].timePlanned = nextDate
                    }
                    else
                    {
                        importantTaskBoth[index].timePlanned = nextDate
                    }
                }
            }
            importantTableView.reloadData()
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

// MARK: - delegate from Task Detail ViewController

extension ImportantViewController: TaskMoreDetailViewControllerDelegate
{
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isFinished = state
        if(state)
        {
            importantTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        self.importantTableView.reloadData()
    }
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapImportantButtonAtTask task: Task, didTapImportantButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isInterested = state
    }
    
    func taskMoreDetailViewController(DeleteTarget target: Task) {
        taskStore.removeByID(id: target.taskID)
        importantTableView.reloadData()
    }
    
    func taskMoreDetailViewController(targetTask target: Task, changeMyDayState state: Bool) {
        if(state)
        {
            target.secondTaskType = .myDay
        }
        else
        {
            target.secondTaskType = .normal
        }
        importantTableView.reloadData()
    }
    
    
}
// MARK: - add TapGestureRecognizer
extension ImportantViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - List Option View Controller
extension ImportantViewController: ListOptionViewControllerDelegate
{
    func listOptionViewController(changeCompletedTaskPropertyTo newState: Bool) {
        ImportantViewController.showCompletedTask = newState
        self.importantTableView.reloadData()
    }
    
    func listOptionViewController(setBackgroundColorTo newColor: UIColor) {
        ImportantViewController.backgroundColor = newColor
        self.view.backgroundColor = newColor
        self.importantTableView.backgroundColor = newColor
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
        self.importantTableView.reloadData()
    }
    

}

