/*
* Name: Noah Frew
* Pawprint: njfdyf
*/

import UIKit
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    convenience init?(title: String, content:String, date: Date) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: Note.entity(), insertInto: managedContext)
        
        self.title = title
        self.content = content
        self.date = date
    }
}
