//
//  ProjectMO+CoreDataProperties.swift
//  CoredataDelegateModel
//
//  Created by Claude Montpetit on 16-03-22.
//  Copyright © 2016 Claude Montpetit. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ProjectMO {

    @NSManaged var lastModifiedMO: NSDate?
    @NSManaged var nameMO: String?
    @NSManaged var tasksMO: NSOrderedSet?

}
