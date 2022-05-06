//
//  SearchViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 06/05/2022.
//

import UIKit

class SearchViewController: UIViewController {
    private var searchResult: [Task] = []
    @IBOutlet weak var imageAndTextView: UIView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchImageLabel: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    var listStore: ListStore!
    var taskStore: TaskStore!
    func updateSearchGUI()
    {
        if(searchResult.count == 0)
        {
            imageAndTextView.isHidden = false
            searchTableView.isHidden = true
            if(!searchTextField.hasText)
            {

                searchImageView.image = UIImage(named: "startFoundImage")
                searchImageLabel.text = "What would you like to find?"
            }
            else
            {
                searchImageView.image = UIImage(named: "notFoundImage")
                searchImageLabel.text = "We search high and low but couldn't find what you're looking for"
            }
        }
        else
        {
            imageAndTextView.isHidden = true
            searchTableView.isHidden = false
            searchTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.accessibilityRespondsToUserInteraction = false
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        updateSearchGUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        searchTableView.reloadData()
        updateSearchGUI()
    }

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender.hasText, let searchingKey = sender.text
        {
            searchResult.removeAll()
            searchResult = listStore.findTaskBySearchingKey(searchingKey: searchingKey) + taskStore.searchTaskBySearchingKey(searchingKey: searchingKey)
            if(searchResult.count != 0)
            {
                for value in searchResult
                {
                    print(value.detail)
                }
            }
        }
        else if(!sender.hasText)
        {
            searchResult.removeAll()
        }
        updateSearchGUI()
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - table render
extension SearchViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        cell.task = searchResult[indexPath.row]
        cell.initCellForSearchViewController()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentTask = searchResult[indexPath.row]
        let detailTaskViewController = TaskMoreDetailViewController()
        detailTaskViewController.task = currentTask
        detailTaskViewController.delegate = self
        detailTaskViewController.currentIndexPath = indexPath
        detailTaskViewController.isMyDay = currentTask.taskType == .myDay || currentTask.secondTaskType == .myDay
        self.navigationController?.pushViewController(detailTaskViewController, animated: true)
    }
}

// MARK: delegate from cell
extension SearchViewController: TaskTableViewCellDelegate
{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        task.isFinished = state
        searchTableView.reloadData()
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapInterestButtonAtTask task: Task, didTapInterestButtonToState state: Bool) {
        task.isInterested = state
        if(!state)
        {
            task.taskType = .normal
        }
    }
    
}

// MARK: - Task More Detail ViewController
extension SearchViewController: TaskMoreDetailViewControllerDelegate
{
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapFinishButtonAtTask task: Task, didTapFinishButtonToState state: Bool) {
        task.isFinished = state
        searchTableView.reloadData()
    }
    
    func taskMoreDetailViewController(_ indexPath: IndexPath, didTapImportantButtonAtTask task: Task, didTapImportantButtonToState state: Bool) {
        task.isInterested = state
    }
    
    func taskMoreDetailViewController(DeleteTarget target: Task) {
        if(target.taskType == .listed)
        {
            listStore.removeByID(id: target.taskID)
        }
        else
        {
            taskStore.removeByID(id: target.taskID)
        }
        searchResult = searchResult.filter{
            $0.taskID != target.taskID
        }
        searchTableView.reloadData()
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
        searchTableView.reloadData()
    }
    
    
}
