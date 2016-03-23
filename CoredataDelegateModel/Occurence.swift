//
//  Occurence.swift
//  CoredataDelegateModel
//
//  Created by Claude Montpetit on 16-03-20.
//  Copyright © 2016 Claude Montpetit. All rights reserved.
//

import Foundation

public protocol Occurenceable {
    var name: String {get set}
    var date: NSDate { get set}
    var task: Taskable { get }
}

class Occurence: Occurenceable {
    
    var task: Taskable
    var name: String
    var date: NSDate
    
    init(task: Taskable, name: String, date: NSDate) {
        self.task = task
        self.name = name
        self.date = date
    }
}