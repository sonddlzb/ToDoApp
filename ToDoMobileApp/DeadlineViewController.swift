//
//  DeadlineViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 18/04/2022.
//

import UIKit

protocol DeadlineViewControllerDelegate
{
    func deadlineViewControllerDelagate(didSelectRowAt indexPath: IndexPath)
}

class DeadlineViewController: UIViewController {
    @IBOutlet private weak var deadlineTableView: UITableView!
    var delegate: DeadlineViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        deadlineTableView.delegate = self
        deadlineTableView.dataSource = self
        deadlineTableView.register(UINib(nibName: "PlannedFilterFloatTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PlannedFilterFloatTableViewCell")
    }

    @IBAction func doneWithButton(_ sender: UIBarButtonItem)
    {
        print("dismiss")
        self.dismiss(animated: true, completion: nil)
    }

}

extension DeadlineViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = deadlineTableView.dequeueReusableCell(withIdentifier: "PlannedFilterFloatTableViewCell") as! PlannedFilterFloatTableViewCell
        cell.initCellForDeadlineTableView(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row at \(indexPath.row) is selected")
        delegate?.deadlineViewControllerDelagate(didSelectRowAt: indexPath)
        self.dismiss(animated: true, completion: nil)
    }
}
