//
//  ListOptionViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 27/04/2022.
//

import UIKit

protocol ListOptionViewControllerDelegate
{
    func listOptionViewController(Opacity opacity: Float)
    func listOptionViewController()
    func listOptionViewController(setBackgroundColorTo newColor: UIColor)
    func listOptionViewController(changeCompletedTaskPropertyTo newState: Bool)
}
class ListOptionViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var taskType: TaskType!
    var delegate: ListOptionViewControllerDelegate?
    var taskStore: TaskStore!
    var listStore: ListStore!
    var currentList: Int!
    var showCompletedTask: Bool!
    @IBOutlet private weak var listOptionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        listOptionTableView.register(UINib(nibName: "TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TableViewCell")
        listOptionTableView.delegate = self
        listOptionTableView.dataSource = self
    }
    
    @IBAction func doneButtonTap(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
        delegate?.listOptionViewController(Opacity: 1.0)
    }
    
    //present theme viewcontroller
    func presentColorViewController()
    {
        let themeViewController = ColorViewController()
        themeViewController.transitioningDelegate = self
        themeViewController.modalTransitionStyle = .coverVertical
        themeViewController.modalPresentationStyle = .custom
        themeViewController.delegate = self
        self.present(themeViewController, animated: true, completion: nil)
    }
    
    // MARK: - show/hide copmpletedTask
    func showOrHideCompletedTask()
    {
        if(!showCompletedTask)
        {
            showCompletedTask = true
            let indexPath = IndexPath(row: 5, section: 0)
            (listOptionTableView.cellForRow(at: indexPath) as! TableViewCell).nameLabel.text = "Hide Completed Tasks"
            
        }
        else
        {
            showCompletedTask = false
            let indexPath = IndexPath(row: 5, section: 0)
            (listOptionTableView.cellForRow(at: indexPath) as! TableViewCell).nameLabel.text = "Show Completed Tasks"
        }
        delegate?.listOptionViewController(changeCompletedTaskPropertyTo: showCompletedTask)
        delegate?.listOptionViewController(Opacity: 1.0)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - sort function
    func presentSortViewController()
    {
        let sortviewController = SortViewController()
        sortviewController.transitioningDelegate = self
        sortviewController.modalTransitionStyle = .crossDissolve
        sortviewController.modalPresentationStyle = .custom
        if taskStore != nil
        {
            sortviewController.taskStore = taskStore
        }
        else
        {
            sortviewController.listStore = listStore
            sortviewController.currentList = currentList
        }
        sortviewController.delegate = self
        self.present(sortviewController, animated: true, completion: nil)
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
            return OneFourthSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
}

// MARK: - delegate from table View
extension ListOptionViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch taskType
        {
        case .important, .planned: return 6
        case .myDay, .normal: return 5
        default: return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOptionTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        if showCompletedTask != nil
        {
        cell.initCellForListOptionViewController(indexPath: indexPath, completedState: showCompletedTask)
        }
        else
        {
            cell.initCellForListOptionViewController(indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row
        {
        case 0:
                //open edit mode
            delegate?.listOptionViewController()
            delegate?.listOptionViewController(Opacity: 1.0)
            self.dismiss(animated: true, completion: nil)
        case 1: presentColorViewController()
        case 4: presentSortViewController()
        case 5: showOrHideCompletedTask()
        default: "wrong option!"
        }
    }
}

// MARK: -ColorViewControllerDelegate
extension ListOptionViewController: ColorViewControllerDelegate
{
    func colorViewController(setBackgroundColorTo newColor: UIColor) {
        delegate?.listOptionViewController(setBackgroundColorTo: newColor)
    }
    
    func colorViewController(Opacity opacity: Float) {
        delegate?.listOptionViewController(Opacity: opacity)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - SortViewController
extension ListOptionViewController: SortViewControllerDelegate
{
    func sortViewController() {
        delegate?.listOptionViewController(Opacity: 1.0)
        self.dismiss(animated: false, completion: nil)
    }

    
}
