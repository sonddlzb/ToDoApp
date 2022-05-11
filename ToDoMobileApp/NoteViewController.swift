//
//  NoteViewController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 25/04/2022.
//

import UIKit

protocol NoteViewControllerDelegate
{
    func noteViewController(_ noteText: String)
}
class NoteViewController: UIViewController {
    @IBOutlet private weak var noteTextField: UITextField!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var previewBarButton: UIBarButtonItem!
    var currentNote: String!
    var task: Task!
    var isEditted: Bool = true
    var delegate: NoteViewControllerDelegate?
    func initGui()
    {
        noteTextField.text = currentNote
        noteTextField.contentMode = .top
        noteTextField.textAlignment = .left
        noteTextField.contentVerticalAlignment = .top
        navigationBar.topItem?.title = task.getDetail()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initGui()
        noteTextField.delegate = self
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem)
    {
        if let note = noteTextField.text, noteTextField.hasText
        {
            delegate?.noteViewController(note)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func previewButtonTapped(_ sender: UIBarButtonItem)
    {
        if(isEditted)
        {
            noteTextField.resignFirstResponder()
            isEditted = false
            previewBarButton.title = "Edit"
        }
        else
        {
            noteTextField.becomeFirstResponder()
            isEditted = true
            previewBarButton.title = "Preview"
        }
    }
}
// MARK: - delegate from textField
extension NoteViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

