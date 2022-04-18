//
//  PlannedFilterFloatViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 15/04/2022.
//

import UIKit

class PlannedFilterFloatViewController: UIViewController {
    
    @IBOutlet weak private var filterTableView: UITableView!
    var delegate: PlannedFilterFloatViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.register(UINib(nibName: "PlannedFilterFloatTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PlannedFilterFloatTableViewCell")
        view.isOpaque = true
        view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }

    @IBAction func doneWithButton(_ sender: UIBarButtonItem)
    {
        print("dismiss")
        self.dismiss(animated: true, completion: nil)
    }

}

extension PlannedFilterFloatViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filterTableView.dequeueReusableCell(withIdentifier: "PlannedFilterFloatTableViewCell") as! PlannedFilterFloatTableViewCell
        cell.initCellForPlannedFilterTableView(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row at \(indexPath.row) is selected")
        delegate?.plannedFilterFloatViewController(tableView, didSelectRowAt: indexPath)
        self.dismiss(animated: true, completion: nil)
    }
}

protocol PlannedFilterFloatViewControllerDelegate
{
    func plannedFilterFloatViewController(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}
