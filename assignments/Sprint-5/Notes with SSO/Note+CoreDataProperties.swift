/*
* Name: Noah Frew
* Pawprint: njfdyf
*/

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?

}
