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
    var listStore: ListStore!
    var taskStore: TaskStore!
    var importantTask: [Task]
    {
        let res = listStore.importantTaskListStore + taskStore.importantTaskTaskStore
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
        importantTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        importantTableView.reloadData()
        importantTableView.delegate = self
        importantTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(ImportantViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ImportantViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        importantTableView.reloadData()
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
            let index = importantTask.count - 1
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

extension ImportantViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importantTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = importantTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        cell.taskStore = taskStore
        cell.initCellForImportantViewController(indexPath: indexPath, listOfImportantTask: importantTask)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //display task detail screen for each task
        let detailTaskViewController = TaskMoreDetailViewController()
        detailTaskViewController.task = importantTask[indexPath.row]
        detailTaskViewController.delegate = self
        detailTaskViewController.currentIndexPath = indexPath
        detailTaskViewController.isMyDay = (importantTask[indexPath.row].secondTaskType == .myDay)
        self.navigationController?.pushViewController(detailTaskViewController, animated: true)
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
        task.isFinished = state
        let indexPath = importantTableView.indexPath(for: cell)
        importantTableView.deleteRows(at: [indexPath!], with: .automatic)
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        print("update finished database of \(task.detail)!")
        task.isInterested = state
        let indexPath = importantTableView.indexPath(for: cell)
        importantTableView.deleteRows(at: [indexPath!], with: .automatic)
    }
    
    
}

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
        importantTableView.reloadData()
    }
    
    func deadlineViewController(Opacity opacity: Float) {
        self.view.layer.opacity = opacity
    }
    
    func deadlineViewController(currentDateSelect datePicker: Date) {
        nextDate = datePicker
        dueButton.setTitle("Due \(nextDate.dayofTheWeek), \(nextDate.day) \(nextDate.monthString)", for: .normal)

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
