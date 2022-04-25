//
//  StepTableViewCell.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 22/04/2022.
//

import UIKit

protocol StepTableViewCellDelegate
{
    func stepTableViewCell(_ cell: StepTableViewCell, didDeleteButtonAtStep step: Int)
    func stepTableViewCell(_ cell: StepTableViewCell, didFinishButtonAtStep step: Int)
}
class StepTableViewCell: UITableViewCell {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var stepNameTextField: UITextField!
    var currentStep: Int!
    var delegate: StepTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initCellForTaskMoreDetailViewController(indexPath: IndexPath, task: Task)
    {
        currentStep = indexPath.row
        if task.steps[indexPath.row].0
        {
            self.finishButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        else
        {
            self.finishButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        self.deleteButton.setTitle("x", for: .normal)
        self.stepNameTextField.borderStyle = .none
        self.stepNameTextField.text = task.steps[indexPath.row].1

    }
    @IBAction func deleteStep(_ sender: UIButton)
    {
        delegate?.stepTableViewCell(self, didDeleteButtonAtStep: currentStep)
    }
    @IBAction func finishStep(_ sender: UIButton)
    {
        delegate?.stepTableViewCell(self, didFinishButtonAtStep: currentStep)
    }
    
}
