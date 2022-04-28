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
}
class ListOptionViewController: UIViewController {

    var delegate: ListOptionViewControllerDelegate?
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

}

// MARK: - delegate from table View
extension ListOptionViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOptionTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.initCellForListOptionViewController(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row
        {
        case 0:
            delegate?.listOptionViewController()
            delegate?.listOptionViewController(Opacity: 1.0)
            self.dismiss(animated: true, completion: nil)
        default: "wrong option!"
        }
    }
    
}
