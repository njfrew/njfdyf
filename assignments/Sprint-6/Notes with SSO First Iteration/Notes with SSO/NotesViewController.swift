/*
 * Name: Noah Frew
 * Pawprint: njfdyf
 */

import UIKit
import CoreData
import Auth0

class NotesViewController: UIViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var notesTableView: UITableView!
    
    var dateFormatter = DateFormatter()
    var notes = [Note]()
    private var isAuthenticated = false {
        didSet {
            addButton.isEnabled = isAuthenticated
            
            if isAuthenticated {
                loadNotes()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .long
        addButton.isEnabled = isAuthenticated
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isAuthenticated {
            loadNotes()
        }
    }
    
    @IBAction func addNewNote(_ sender: Any) {
        performSegue(withIdentifier: "showNote", sender: self)
    }
    
    @IBAction func displayLogin(_ sender: UIBarButtonItem) {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        
        if !isAuthenticated {
            Auth0
                .webAuth()
                .scope("openid profile")
                .audience("https://" + clientInfo.domain + "/userinfo")
                .start {
                    switch $0 {
                    case .failure(let error):
                        print("Error: \(error)")
                    case .success:
                        DispatchQueue.main.async {
                            self.isAuthenticated = true
                            sender.title = "Log Out"
                        }
                    }
            }
        } else {
            Auth0
                .webAuth()
                .clearSession(federated:false) {
                    switch $0 {
                    case true:
                        DispatchQueue.main.async {
                            sender.title = "Log In"
                            self.isAuthenticated = false
                            self.notes = []
                            self.notesTableView.reloadData()
                        }
                    case false:
                        DispatchQueue.main.async {
                            print("An error occurred")
                        }
                    }
            }
        }
    }
    
    func loadNotes() {
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
        
        func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
            return Auth0.resumeAuth(url, options: options)
        }
    }
    
    func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
        guard
            let path = bundle.path(forResource: "Auth0", ofType: "plist"),
            let values = NSDictionary(contentsOfFile: path) as? [String: Any]
            else {
                print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
                return nil
        }
        
        guard
            let clientId = values["ClientId"] as? String,
            let domain = values["Domain"] as? String
            else {
                print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
                print("File currently has the following entries: \(values)")
                return nil
        }
        return (clientId: clientId, domain: domain)
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
