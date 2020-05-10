//
//  Note+CoreDataProperties.swift
//  Notes with SSO
//
//  Created by Noah Frew on 5/5/20.
//  Copyright © 2020 NOAH FREW. All rights reserved.
//
//

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
