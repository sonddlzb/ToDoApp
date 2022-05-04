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
class ListOptionViewController: UIViewController, UIViewControllerTransitioningDelegate {

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
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
            return OneFifthSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
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
        case 1: presentColorViewController()
        default: "wrong option!"
        }
    }
}

// MARK: -ColorViewControllerDelegate
extension ListOptionViewController: ColorViewControllerDelegate
{
    func colorViewController(Opacity opacity: Float) {
        delegate?.listOptionViewController(Opacity: opacity)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
