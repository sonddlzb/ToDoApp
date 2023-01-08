//
//  MyDayViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 08/04/2022.
//

import UIKit

class ListViewController: UIViewController, UIViewControllerTransitioningDelegate{

    var listStore: ListStore!
    var currentList: Int!
    @IBOutlet weak private var listTableView: UITableView!
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
    var nextDate: Date!
    var currentDeadlineType: DeadlineType = .Today
    var isMyDay = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = listStore.allList[currentList].getName()
        addTaskTextField.delegate = self
        stackView.isHidden = true
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        
        //add right bar button item
        let optionBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(listOptionDidTap(_:)))
        self.navigationItem.rightBarButtonItem  = optionBarButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let color = ListViewController.backgroundColor
        {
            ListViewController.backgroundColor = color
            self.view.backgroundColor = color
            self.listTableView.backgroundColor = color
            viewMove.backgroundColor = color
            addTaskTextField.backgroundColor = color
        }
        self.dueButton.setTitle("", for: .normal)
        self.nextDate = Date()
        listTableView.reloadData()
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
        listTableView.reloadData()
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
        listTableView.reloadData()
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
        listOptionView.listStore = listStore
        listOptionView.currentList = currentList
        listOptionView.taskType = .listed
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
    
    // MARK: - add new task
    @IBAction func addNewTask(_ sender: Any) {
        
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
            if(isMyDay)
            {
                newTask = Task(detail:taskName, taskType: .listed, secondTaskType: .myDay, timeCreate: Date(), timePlanned: nextDate!, listID: listStore.allList[currentList].getListID())
            }
            else
            {
                newTask = Task(detail:taskName, taskType: .listed, secondTaskType: .normal, timeCreate: Date(), timePlanned: nextDate!,listID:  listStore.allList[currentList].getListID())
            }
            listStore.allList[currentList].addTask(task: newTask)
            let index = listStore.allList[currentList].taskNotFinished.count - 1
            let indexPath = IndexPath(row: index, section: 0)
            listTableView.insertRows(at: [indexPath], with: .automatic)
            addTaskTextField.text = ""
        }
    }
    // MARK: - tap my day button
    @IBAction func myDayDidTap(_ sender: UIButton)
    {
        
        if(!isMyDay)
        {
            print("Myday picked!")
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
    
    // MARK: -deadline button did tapped
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
    
    // MARK: - select all tap
    @IBAction func selectAllTap(_ sender: UIButton)
    {
        var taskList: [Task] = listStore.taskFinished(currentList: currentList) + listStore.taskNotFinished(currentList: currentList)
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
            if(listStore.taskNotFinished(currentList: currentList).count != 0)
            {
                for i in 0...(listStore.taskNotFinished(currentList: currentList).count  - 1)
                {
                    let indexPath = IndexPath(row: i, section: 0)
                    (listTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                }
            }
            if(listStore.taskFinished(currentList: currentList).count  != 0)
            {
                for i in 0...(listStore.taskFinished(currentList: currentList).count  - 1)
                {
                    let indexPath = IndexPath(row: i, section: 1)
                    (listTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
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
            if(listStore.taskNotFinished(currentList: currentList).count  != 0)
            {
                for i in 0...(listStore.taskNotFinished(currentList: currentList).count - 1)
                {
                    let indexPath = IndexPath(row: i, section: 0)
                    (listTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
                }
            }
            if(listStore.taskFinished(currentList: currentList).count  != 0)
            {
                for i in 0...(listStore.taskFinished(currentList: currentList).count  - 1)
                {
                    let indexPath = IndexPath(row: i, section: 1)
                    (listTableView.cellForRow(at: indexPath) as! TaskTableViewCell).finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
                }
            }
        }
        updateOptionButtons()
        
    }
    
    // MARK: - delete selected Tasks
    @IBAction func deleteSelectedTasksTap(_ sender: UIButton)
    {
        var taskList = listStore.taskNotFinished(currentList: currentList) + listStore.taskFinished(currentList: currentList)
        let alert = UIAlertController(title: nil, message: "Are you sure you want to permanently delete these tasks?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Delete task", style: .destructive)
        {   _ in
            var idRemove = [String]()
            for i in 0...taskList.count - 1
            {
                if(self.isSelected[i])
                {
                    if(i >= self.listStore.taskNotFinished(currentList: self.currentList).count )
                    {
                        idRemove.append(self.listStore.taskFinished(currentList: self.currentList)[i - self.listStore.taskNotFinished(currentList: self.currentList).count].getTaskID())
                        self.isSelected[i] = false
                    }
                    else
                    {
                        idRemove.append(self.listStore.taskNotFinished(currentList: self.currentList)[i].getTaskID())
                        self.isSelected[i] = false
                    }
                }
            }
            for value in idRemove
            {
                self.listStore.removeByID(currentList: self.currentList, id: value)
                //Database.deleteTask(task: self.listStore.findTaskByID(taskID: value))
                self.listTableView.reloadData()
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
        var taskList = self.listStore.taskNotFinished(currentList: self.currentList) + self.listStore.taskFinished(currentList: self.currentList)
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
        let cell = listTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        //task not finished
        cell.delegate = self
        cell.isOnEditMode = isOnEditMode
        cell.listStore = listStore
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //display task detail screen for each task
        if(!isOnEditMode)
        {
            let detailTaskViewController = TaskMoreDetailViewController()
            if(indexPath.section == 0)
            {
                detailTaskViewController.task = listStore.allList[currentList].taskNotFinished[indexPath.row]
            }
            else
            {
                detailTaskViewController.task = listStore.allList[currentList].taskFinished[indexPath.row]
            }
            detailTaskViewController.delegate = self
            detailTaskViewController.currentIndexPath = indexPath
            detailTaskViewController.isMyDay = true
            self.navigationController?.pushViewController(detailTaskViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let alert = UIAlertController(title: nil, message: "\("\(self.listStore.allList[currentList].listOfTask[indexPath.row].getDetail())") will be permanently deleted", preferredStyle: .actionSheet)
            let yesAction = UIAlertAction(title: "Delete Task", style: .destructive)
            {
                _ in
                Database.deleteTask(task: self.listStore.allList[self.currentList].listOfTask[indexPath.row])
                self.listStore.allList[self.currentList].listOfTask.remove(at: indexPath.row)
                self.listTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
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
        print("update finished database of \(task.getDetail())!")
        if(!isOnEditMode)
        {
            task.setIsFinished(newState: state)
            listTableView.reloadSections([0,1], with: .automatic)
        }
        else
        {
            var indexPath: IndexPath = listTableView.indexPath(for: cell)!
            if(indexPath.section == 0)
            {
                isSelected[indexPath.row] = state
            }
            else
            {
                isSelected[indexPath.row + listStore.taskNotFinished(currentList: self.currentList).count] = state
            }
            print(listTableView.indexPath(for: cell)!.row)
            updateOptionButtons()
        }
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        print("update interested database of \(task.getDetail())!")
        task.setIsInterested(newState: state)
    }
    
}

// MARK: - add TapGestureRecognizer
extension ListViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TaskMoreDetailViewController
extension ListViewController: TaskMoreDetailViewControllerDelegate
{
    //change my day property in task detail screen
    func taskMoreDetailViewController(targetTask target: Task, changeMyDayState state: Bool) {
        if(state)
        {
            target.setSecondTaskType(newTaskType: .myDay)
        }
        else
        {
            target.setSecondTaskType(newTaskType: .normal)
        }
        listTableView.reloadData()
    }
    
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.getDetail())!")
        task.setIsFinished(newState: state)
        self.listTableView.reloadData()
    }
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapImportantButtonAtTask task: Task, didTapImportantButtonToState state: Bool) {
        print("update finished database of \(task.getDetail())!")
        task.setIsInterested(newState: state)
    }
    
    //delete a task from task detail screen
    func taskMoreDetailViewController(DeleteTarget target: Task) {
        listStore.removeByID(currentList:  currentList, id: target.getTaskID())
        print("deleted");
        listTableView.reloadData()
    }
    
}

// MARK: - Deadline View Controller
extension ListViewController: DeadlineViewControllerDelegate
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
                    if(index >= self.listStore.taskNotFinished(currentList: self.currentList).count)
                    {
                        self.listStore.taskFinished(currentList: self.currentList)[index - self.listStore.taskNotFinished(currentList: self.currentList).count].setTimePlanned(newTime: nextDate)
                    }
                    else
                    {
                        self.listStore.taskNotFinished(currentList: self.currentList)[index].setTimePlanned(newTime: nextDate)
                    }
                }
            }
            if(currentDeadlineType != .Other)
            {
                stackViewDismiss()
            }
            
        }
        listTableView.reloadData()
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
                    if(index >= self.listStore.taskNotFinished(currentList: self.currentList).count)
                    {
                        self.listStore.taskFinished(currentList: self.currentList)[index - self.listStore.taskNotFinished(currentList: self.currentList).count].setTimePlanned(newTime: nextDate)
                    }
                    else
                    {
                        self.listStore.taskNotFinished(currentList: self.currentList)[index].setTimePlanned(newTime: nextDate)
                    }
                }
            }
            listTableView.reloadData()
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

extension ListViewController: ListOptionViewControllerDelegate
{
    func listOptionViewController(Opacity opacity: Float) {
        self.view.layer.opacity = opacity
        self.listTableView.reloadData()
    }
    
    func listOptionViewController() {
        stackViewAppear()
        updateOptionButtons()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(stackViewDismiss))
        self.navigationItem.setRightBarButton(cancelButton, animated: true)
    }
    
    func listOptionViewController(setBackgroundColorTo newColor: UIColor) {
        ListViewController.backgroundColor = newColor
        self.view.backgroundColor = newColor
        self.listTableView.backgroundColor = newColor
        viewMove.backgroundColor = newColor
        addTaskTextField.backgroundColor = newColor
    }
    
    func listOptionViewController(changeCompletedTaskPropertyTo newState: Bool) {
        
    }
}

