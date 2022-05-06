//
//  sortViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 04/05/2022.
//

import UIKit
import Foundation
protocol SortViewControllerDelegate
{
    //dismiss the presented controller, set opacity
    func sortViewController()
}

class SortViewController: UIViewController {
    var delegate: SortViewControllerDelegate?
    @IBOutlet weak var sortTableView: UITableView!
    var taskStore: TaskStore!
    var listStore: ListStore!
    var currentList: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        sortTableView.register(UINib(nibName: "TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TableViewCell")
        sortTableView.dataSource = self
        sortTableView.delegate = self
    }
    // MARK: - done button tapped
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem)
    {
        
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - cancel button tapped
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - sort anphabetically
    func sortAlphabetically()
    {
        if(taskStore != nil)
        {
            taskStore.allTask.sort{
                $0.detail < $1.detail
            }
        }
        else
        {
            listStore.allList[currentList].listOfTask.sort{
                $0.detail < $1.detail
            }
        }
    }
    
    // MARK: - sort by due date
    func sortDueDate()
    {
        if(taskStore != nil)
        {
            taskStore.allTask.sort{
                $0.timePlanned < $1.timePlanned
            }
        }
        else
        {
            listStore.allList[currentList].listOfTask.sort{
                $0.timePlanned < $1.timePlanned
            }
        }
    }
    
    // MARK: -sort by creation date
    func sortCreationDate()
    {
        if(taskStore != nil)
        {
            taskStore.allTask.sort{
                $0.timeCreate < $1.timeCreate
            }
        }
        else
        {
            listStore.allList[currentList].listOfTask.sort{
                $0.timeCreate < $1.timeCreate
            }
        }
    }

}

// MARK: - table render
extension SortViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sortTableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.initCellForSortViewController(indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40.0)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row
        {
        case 0: sortAlphabetically()
        case 1: sortDueDate()
        case 2: sortCreationDate()
        default: print("Wrong selection!")
        }
        self.dismiss(animated: true, completion: nil)
        delegate?.sortViewController()
    }
}
