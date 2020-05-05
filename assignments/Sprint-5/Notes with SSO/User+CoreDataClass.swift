//
//  User+CoreDataClass.swift
//  Notes with SSO
//
//  Created by Noah Frew on 5/5/20.
//  Copyright © 2020 NOAH FREW. All rights reserved.
//
//

import UIKit
import CoreData

@objc(User)
public class User: NSManagedObject {
    convenience init?(userID: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: User.entity(), insertInto: managedContext)
        
        self.userID = userID
    }
}
