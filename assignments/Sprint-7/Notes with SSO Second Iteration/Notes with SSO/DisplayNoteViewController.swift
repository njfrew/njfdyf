/*
* Name: Noah Frew
* Pawprint: njfdyf
*/

import UIKit

class DisplayNoteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var existingNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        contentTextView.delegate = self
        
        titleTextField.text = existingNote?.title
        contentTextView.text = existingNote?.content
        existingNote?.date = Date()
        
        contentTextView.layer.borderColor = titleTextField.layer.borderColor
        contentTextView.layer.borderWidth = 0.2
        contentTextView.layer.cornerRadius = 4

    }
    
    @IBAction func saveNote(_ sender: UIBarButtonItem) {
        let title = titleTextField.text ?? ""
        let content = contentTextView.text ?? ""
        let date = Date()
        var note: Note?
        
        if let existingNote = existingNote {
            existingNote.title = title
            existingNote.content = content
            existingNote.date = date
            note = existingNote
        } else {
            note = Note(title: title, content: content, date: date)
        }
        
        if let note = note {
            do {
                let managedContext = note.managedObjectContext
                
                try managedContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Context could not be saved")
            }
        }
    }
}

extension DisplayNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
