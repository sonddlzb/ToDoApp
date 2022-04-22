//
//  DatePickerViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 20/04/2022.
//

import UIKit

protocol DatePickerViewControllerDelegate
{
    func datePickerViewController(currentDateSelect datePicker: Date)
    //set opacity
    func datePickerViewController()
}
class DatePickerViewController: UIViewController {
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    var delegate: DatePickerViewControllerDelegate?
    var currentDate: Date = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.preferredDatePickerStyle = .inline
    
    }
    
    @IBAction func datePickerChange(_ sender: UIDatePicker)
    {
        print("DatePicker change")
        currentDate = datePicker.date
    }
    @IBAction func setDate(_ sender: UIBarButtonItem)
    {
        print("set is touched!")
        delegate?.datePickerViewController(currentDateSelect: currentDate)
        delegate?.datePickerViewController()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelTouch(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
