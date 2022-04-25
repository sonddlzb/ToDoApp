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
    var taskStore: TaskStore!
    var nextDate: Date!
    var currentDeadlineType: DeadlineType = .Today
    var myDayTaskFinished: [Task]
    {
        var res = [Task]()
        for value in taskStore.allTask
        {
            if value.taskType == .myDay && value.isFinished
            {
                res.append(value)
            }
            if value.taskType == .planned && value.secondTaskType == .myDay && value.isFinished
            {
                res.append(value)
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
            if value.taskType == .planned && value.secondTaskType == .myDay && !value.isFinished
            {
                res.append(value)
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
        myDayTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        myDayTableView.delegate = self
        myDayTableView.dataSource = self
        addTaskTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(MyDayViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyDayViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        myDayTableView.reloadData()
    }
    //move viewMove to keyboard
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
            print(nextDate)
            let newTask: Task
            newTask = Task(detail:taskName, taskType: .myDay, timeCreate: Date(), timePlanned: nextDate!)
            taskStore.addTask(task: newTask)
            let index = myDayTaskNotFinished.count - 1
            let indexPath = IndexPath(row: index, section: 0)
            myDayTableView.insertRows(at: [indexPath], with: .automatic)
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
            return "Đã hoàn thành \(number)"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var detailTaskViewController = TaskMoreDetailViewController()
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
// MARK: - delegate from textField

extension MyDayViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - delegate from cell for finish and interest touch action
extension MyDayViewController: TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task,didTapFinishButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isFinished = state
        myDayTableView.reloadSections([0,1], with: .automatic)
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        print("update interested database of \(task.detail)!")
        task.isInterested = state
    }
    
}

// MARK: - delegate from Task Detail View Controller
extension MyDayViewController: TaskMoreDetailViewControllerDelegate
{
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
    
    func taskMoreDetailViewController(DeleteTarget target: Task) {
        taskStore.removeByID(id: target.taskID)
        myDayTableView.reloadData()
    }
}
extension MyDayViewController: DeadlineViewControllerDelegate
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
        myDayTableView.reloadData()
    }
    
    func deadlineViewController(Opacity opacity: Float) {
        self.view.layer.opacity = opacity
    }
    
    func deadlineViewController(currentDateSelect datePicker: Date) {
        nextDate = datePicker
        dueButton.setTitle("Due \(nextDate.dayofTheWeek), \(nextDate.day) \(nextDate.monthString)", for: .normal)
    }
    
    
}
