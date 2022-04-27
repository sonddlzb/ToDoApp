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
    override func viewDidLoad() {
        print("loadVIew")
        initGui()
        self.hideKeyboardWhenTappedAround()
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TableViewCell")
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        addListTextField.delegate = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
            return
        }
        print("move textField above")
      // move the root view up by the distance of keyboard height
        self.stackView.frame.origin.y = view.bounds.height - keyboardSize.height - stackView.bounds.height
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin
        print("move textField back")
        self.stackView.frame.origin.y = view.bounds.height - stackView.bounds.height - view.safeAreaInsets.bottom
    }
    private func initGui()
    {
        addListButton.imageView?.image = UIImage(named: "add-icon")
        addListTextField.placeholder = "New list"
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
    

    
}

// MARK: - delegate from text field for returning
extension ViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

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
