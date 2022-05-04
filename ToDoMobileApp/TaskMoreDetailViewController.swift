//
//  TaskMoreDetailViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 22/04/2022.
//

import UIKit

protocol TaskMoreDetailViewControllerDelegate
{
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool)
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapImportantButtonAtTask task: Task, didTapImportantButtonToState state: Bool)
    func taskMoreDetailViewController(DeleteTarget target: Task)
    func taskMoreDetailViewController(targetTask target: Task, changeMyDayState state: Bool)
}
class TaskMoreDetailViewController: UIViewController, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var taskNameTextField: UITextField!
   @IBOutlet weak var finishAllButton: UIButton!
   @IBOutlet weak var updateLabel: UILabel!
   @IBOutlet weak var deleteButton: UIButton!
   @IBOutlet weak var timeCreatedLabel: UILabel!
   @IBOutlet weak var importantButton: UIButton!
   @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var stepNameTextField: UITextField!
    @IBOutlet weak var noteLabel: UILabel!
    var task: Task!
    var currentIndexPath: IndexPath!
    var isMyDay: Bool = false
    var delegate: TaskMoreDetailViewControllerDelegate?
       func initGui()
       {
           taskNameTextField.text = task.detail
           stepNameTextField.borderStyle = .none
           taskNameTextField.contentMode = .left
           taskNameTextField.borderStyle = .none
           
           //init state of task
           if(!task.isFinished)
           {
               finishAllButton.setImage(UIImage(systemName: "circle"), for: .normal)
           }
           else
           {
               finishAllButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
           }
           if(!task.isInterested)
           {
               importantButton.setImage(UIImage(systemName: "star"), for: .normal)
           }
           else
           {
               importantButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
               
           }
           //add action for note view
           let gesture = UITapGestureRecognizer(target: self, action: #selector(self.addNote(_:)))
           detailView.addGestureRecognizer(gesture)
           if noteLabel.text == ""
           {
               noteLabel.text = "Add note"
           }
           
       }

    @objc func addNote(_ sender: UITapGestureRecognizer)
    {
        var noteViewController =  NoteViewController()
        noteViewController.modalPresentationStyle = .popover
        noteViewController.modalTransitionStyle = .coverVertical
        noteViewController.delegate = self
        noteViewController.task = task
        if let note = noteLabel.text, !note.isEmpty
        {
            noteViewController.currentNote = note
        }
        else
        {
            noteViewController.currentNote = ""
        }
        self.present(noteViewController, animated: true, completion: nil)
    }
       override func viewDidLoad() {
           initGui()
           super.viewDidLoad()
           taskTableView.delegate = self
           taskTableView.dataSource = self
           self.taskNameTextField.delegate = self
           self.stepNameTextField.delegate = self
           taskTableView.register(UINib(nibName: "TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TableViewCell")
           taskTableView.register(UINib(nibName: "StepTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "StepTableViewCell")
       }
    
    @IBAction func addNewStep(_ sender: UIButton)
    {
        if let stepName = self.stepNameTextField.text, stepNameTextField.hasText
        {
            task.steps.append((false,stepName))
        let index = taskTableView.numberOfRows(inSection: 0)
        let indexPath = IndexPath(row: index, section: 0)
        taskTableView.insertRows(at: [indexPath], with: .automatic)
        self.stepNameTextField.text = ""
        }
    }
    @IBAction func finishClick(_ sender: UIButton) {
        //print(sender.tag)
        if sender.imageView!.image!.description.contains("checkmark.circle.fill")
        {
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
            delegate?.taskMoreDetailViewController(currentIndexPath, didTapFinishButtonAtTask: task, didTapFinishButtonToState: false)
            
        }
        else
        {
            //finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            delegate?.taskMoreDetailViewController(currentIndexPath, didTapFinishButtonAtTask: task, didTapFinishButtonToState: true)
        }
    }
    @IBAction func interestClick(_ sender: UIButton) {
        if sender.imageView!.image!.description.contains("star.fill")
        {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            delegate?.taskMoreDetailViewController(currentIndexPath, didTapImportantButtonAtTask: task, didTapImportantButtonToState: false)
        }
        else
        {
            
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            delegate?.taskMoreDetailViewController(currentIndexPath, didTapImportantButtonAtTask: task, didTapImportantButtonToState: true)
        }
    }
    
    //delete this Task
    @IBAction func deleteTask(_ sender: UIButton)
    {
        let alert = UIAlertController(title: nil, message: "\("\(task.detail)") will be permanently deleted", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Delete task", style: .destructive)
        {
            _ in
            self.delegate?.taskMoreDetailViewController(DeleteTarget: self.task)
            self.navigationController?.popViewController(animated: true)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    //add current task to My Day
    func addToMyDay()
    {
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = taskTableView.cellForRow(at: indexPath) as! TableViewCell
        if(!isMyDay)
        {
            isMyDay = true
            task.secondTaskType = .myDay
        }
        else
        {
            isMyDay = false
            task.secondTaskType = .normal
        }
        cell.changeToMyDay(state: isMyDay)
        delegate?.taskMoreDetailViewController(targetTask: task, changeMyDayState: isMyDay)
    }
    
    //display deadline viewcontroller to pick a due
    func selectDeadline()
    {
        print("Load deadline picker presentation")
        let deadlineViewController = DeadlineViewController()
        deadlineViewController.modalPresentationStyle = .custom
        deadlineViewController.transitioningDelegate = self
        deadlineViewController.modalTransitionStyle = .coverVertical
        deadlineViewController.delegate = self
        self.present(deadlineViewController, animated: true, completion: nil)
        self.view.layer.opacity = 0.5
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    
    
}

// MARK: - delegate from table View
extension TaskMoreDetailViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return task.steps.count
        }
        else
        {
            return 5
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 1)
        {
            let cell = taskTableView.dequeueReusableCell(withIdentifier: "TableViewCell")
            as! TableViewCell
            cell.task = task
            let state = task.taskType == .myDay || ( task.secondTaskType == .myDay)
            cell.initCellForTaskMoreDetailViewController(indexPath: indexPath, myDayState: state)
            return cell
        }
        else
        {
            let cell = taskTableView.dequeueReusableCell(withIdentifier: "StepTableViewCell")
            as! StepTableViewCell
            cell.initCellForTaskMoreDetailViewController(indexPath: indexPath, task: task)
            cell.delegate = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60.0)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            self.task.steps.remove(at: indexPath.row)
            self.taskTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1)
        {
            switch indexPath.row
            {
            case 0: addToMyDay()
            case 2: selectDeadline()
            default: print("Wrong selection")
            }
        }
    }
}

// MARK: - delegate from textField
extension TaskMoreDetailViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if(textField == taskNameTextField)
        {
            if let newName  = textField.text, textField.hasText
            {
                task.detail = newName
            }
        }
        return false
    }
}

// MARK: - delegate from StepTableViewCell
extension TaskMoreDetailViewController: StepTableViewCellDelegate
{
    func stepTableViewCell(_ cell: StepTableViewCell, didDeleteButtonAtStep step: Int) {
        let alert = UIAlertController(title: nil, message: task.steps[cell.currentStep].1 + " will be permanently deleted.", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Delete step", style: .destructive)
        {   _ in
            self.task.steps.remove(at: step)
            let indexPath = IndexPath(row: step, section: 0)
            self.taskTableView.deleteRows(at: [indexPath], with: .automatic)
            self.taskTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert,animated: true, completion: nil)
        
    }
    
    func stepTableViewCell(_ cell: StepTableViewCell, didFinishButtonAtStep step: Int) {
        if cell.finishButton.imageView!.image!.description.contains("checkmark.circle.fill")
        {
            cell.finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
            task.steps[step].0 = false
        }
        else
        {
            cell.finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            task.steps[step].0 = true
        }
    }
    func stepTableViewCell(_ cell: StepTableViewCell, didEditStepNameAt step: Int, toValue newName: String) {
        task.steps[step].1 = newName
    }
}

// MARK: - delegate from deadline viewController

extension TaskMoreDetailViewController: DeadlineViewControllerDelegate
{
    func deadlineViewController(didSelectRowAt indexPath: IndexPath) {
        var dayComponent = DateComponents()
        switch indexPath.row
        {
        case 0: dayComponent.day = 0
        case 1: dayComponent.day = 1
        case 2: dayComponent.day = 7
//        case 3: 
            
        default: print("Wrong deadline selection!")
        }
        if(indexPath.row != 3)
        {
            task.timePlanned = Calendar.current.date(byAdding: dayComponent, to: Date())!
            taskTableView.reloadData()
        }
    }
    
    func deadlineViewController(Opacity opacity: Float) {
        self.view.layer.opacity = opacity
    }
    
    func deadlineViewController(currentDateSelect datePicker: Date) {
        task.timePlanned = datePicker
        taskTableView.reloadData()
    }
    
    
}

// MARK: - delegate from Note ViewController
extension TaskMoreDetailViewController: NoteViewControllerDelegate
{
    func noteViewController(_ noteText: String) {
        noteLabel.text = noteText
    }
    
}

// MARK: - add TapGestureRecognizer
extension TaskMoreDetailViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

