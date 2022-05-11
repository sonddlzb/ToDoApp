//
//  ViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 06/04/2022.
//

import UIKit
import RealmSwift
class ViewController: UIViewController {
    
    var realm: [Realm] = []
    var taskStore: TaskStore!
    @IBOutlet weak var tableView: UITableView!
    var listStore: ListStore!
    @IBOutlet weak var addListButton: UIButton!
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var addListTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var allStackView: UIStackView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        print("loadVIew")
        initDatabase()
        initGui()
        self.hideKeyboardWhenTappedAround()
        self.title = "TODO APP"
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TableViewCell")
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        addListTextField.delegate = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    var isMoved: Bool = false
    
    // MARK: - keyboard show
    @objc func keyboardWillShow(notification: NSNotification) {
        if(isMoved)
        {
            return
        }
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
            return
        }
        print("move textField above")
      // move the root view up by the distance of keyboard height
        self.bottomConstraint.constant += keyboardSize.height - 30
        isMoved = true
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin
        print("move textField back")
        self.bottomConstraint.constant = 0
        isMoved = false
    }
    private func initGui()
    {
        addListTextField.placeholder = "New list"
    }
    
    // MARK: - load database for app
    private func initDatabase()
    {
        let defaultPath = Realm.Configuration.defaultConfiguration.fileURL
        print(defaultPath?.path)
        //try! FileManager.default.removeItem(atPath: defaultPath!.path)
        Database.realm = try! Realm(fileURL: defaultPath!)
//        try! Database.realm.write({
//            Database.realm.deleteAll()
//        })
        var noteTasks = Database.realm.objects(Task.self)
        var lists = Database.realm.objects(List.self)
        var steps = Database.realm.objects(Step.self)
        for value in lists
        {
            listStore.allList.append(value)
        }
        for value in noteTasks
        {
            //add steps
            for step in steps
            {
                if(step.getTaskID() == value.getTaskID())
                {
                    value.steps.append(step)
                }
            }
            if(value.getTaskType() != .listed)
            {
                taskStore.allTask.append(value)
            }
            else
            {
                for list in listStore.allList
                {
                    if(value.getListID() == list.getListID())
                    {
                        list.listOfTask.append(value)
                    }
                }
            }
        }
    }
    @IBAction func addNewList(_ sender: UIButton) {
        if let listName = addListTextField.text, addListTextField.hasText
        {
            let index = tableView.numberOfRows(inSection: 1)
            listStore.createNewList(name: listName)
            let newRealm = try! Realm()
            realm.append(newRealm)
            let indexPath = IndexPath(row: index, section: 1)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        addListTextField.text = ""
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: searchButton tapped
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let searchViewController = SearchViewController()
        searchViewController.listStore = self.listStore
        searchViewController.taskStore =
        self.taskStore
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return 5
        }
        else
        {
            if let liststore = listStore
            {
                return liststore.allList.count
            }
            else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.taskStore = taskStore
        cell.listStore = listStore
        if(indexPath.section == 1)
        {
            cell.bindDataForSection1(list: listStore.allList[indexPath.row], indexPath: indexPath)
        }
        else
        {
            cell.bindDataForSection0(indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if(indexPath.section == 1)
        {
            let vc = ListViewController()
            vc.listStore = listStore
            vc.currentList = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            switch indexPath.row
            {
                case 4:
                    let taskViewController = TaskViewController()
                    taskViewController.listStore = listStore
                    taskViewController.taskStore = taskStore
                    self.navigationController?.pushViewController(taskViewController, animated: true)
                case 1:
                    let importantViewController = ImportantViewController()
                    importantViewController.taskStore = taskStore
                    importantViewController.listStore = listStore
                    self.navigationController?.pushViewController(importantViewController, animated: true)
                case 0:
                    let myDayViewController = MyDayViewController()
                    myDayViewController.taskStore = taskStore
                    myDayViewController.listStore = listStore
                    self.navigationController?.pushViewController(myDayViewController, animated: true)
                case 2:
                let plannedViewController = PlannedViewController()
                plannedViewController.taskStore = taskStore
                self.navigationController?.pushViewController(plannedViewController, animated: true)
                
                case 3:
                let assignToMeViewController = AssignToMeViewController()
                self.navigationController?.pushViewController(assignToMeViewController, animated: true)
                default: print("Wrong index!")
                
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        return footerView
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let alert = UIAlertController(title: nil, message: "\("\(listStore.allList[indexPath.row].getName())") will be permanently deleted", preferredStyle: .actionSheet)
            let yesAction = UIAlertAction(title: "Delete List", style: .destructive)
            {
                _ in
                Database.deleteList(list: self.listStore.allList[indexPath.row])
                self.listStore.allList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
}

// MARK: - delegate from text field for returning
extension ViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - add TapGestureRecognizer
extension ViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
