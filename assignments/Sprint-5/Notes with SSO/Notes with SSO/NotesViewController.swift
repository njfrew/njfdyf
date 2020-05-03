//
//  NotesViewController.swift
//  Notes with SSO
//
//  Created by Noah Frew on 4/30/20.
//  Copyright © 2020 NOAH FREW. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    var dateFormatter = DateFormatter()

    var notes = [Note]()

    @IBOutlet weak var notesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long
        // Do any additional setup after loading the view.
    }
    
    @IBAction func displayLogin(_ sender: Any) {
        let alert = UIAlertController(title: "Log In", message: nil, preferredStyle: .alert)
        
    }
    
    @IBAction func addNewNote(_ sender: Any) {
        performSegue(withIdentifier: "showNote", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            notes = try managedContext.fetch(fetchRequest)
            notesTableView.reloadData()
        } catch {
            print("Fetch could not be performed")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DisplayNoteViewController, let selectedRow = self.notesTableView.indexPathForSelectedRow?.row else {
                return
        }
        
        destination.existingNote = notes[selectedRow]
    }
    
    func deleteNote(at indexPath: IndexPath) {
        let note = notes[indexPath.row]
        
        if let managedContext = note.managedObjectContext {
            managedContext.delete(note)
            
            do {
                try managedContext.save()
                
                self.notes.remove(at: indexPath.row)
                
                notesTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Delete failed")
                
                notesTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    


}

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesTableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        let note = notes[indexPath.row]
        
        cell.textLabel?.text = note.title
        
        if let date = note.date {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(at: indexPath)
        }
    }
    
}


extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNote", sender: self)
    }
}
