//
//  Note+CoreDataClass.swift
//  Notes with SSO
//
//  Created by Noah Frew on 5/5/20.
//  Copyright © 2020 NOAH FREW. All rights reserved.
//
//

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
