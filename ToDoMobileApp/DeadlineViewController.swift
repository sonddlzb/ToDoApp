//
//  DeadlineViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 18/04/2022.
//

import UIKit

protocol DeadlineViewControllerDelegate
{
    func deadlineViewController(didSelectRowAt indexPath: IndexPath)
    //set opacity
    func deadlineViewController(Opacity opacity: Float )
    //pass Date from DatePicker
    func deadlineViewController(currentDateSelect datePicker: Date)
}

class DeadlineViewController: UIViewController, UIViewControllerTransitioningDelegate {
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
        delegate?.deadlineViewController(Opacity: 1.0)
     }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
            return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
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
        if(indexPath.row == 3)
        {
            print("Load Date Picker present ")
            let datePicker = DatePickerViewController()
            datePicker.modalPresentationStyle = .custom
            datePicker.transitioningDelegate = self
            datePicker.modalTransitionStyle = .crossDissolve
            datePicker.delegate = self
            delegate?.deadlineViewController(Opacity: 0.5)
            self.present(datePicker, animated: true, completion: nil)
        }
        else
        {
            delegate?.deadlineViewController(Opacity: 1.0)
        }
        delegate?.deadlineViewController(didSelectRowAt: indexPath)
        if(indexPath.row != 3)
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - delegate from datePicker
extension DeadlineViewController: DatePickerViewControllerDelegate
{
    func datePickerViewController() {
        delegate?.deadlineViewController(Opacity: 0.5)
    }
    
    func datePickerViewController(currentDateSelect datePicker: Date) {
        self.delegate?.deadlineViewController(currentDateSelect: datePicker)
    }
    
    
}

