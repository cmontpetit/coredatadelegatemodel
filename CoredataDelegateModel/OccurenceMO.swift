//
//  OccurenceMO.swift
//  CoredataDelegateModel
//
//  Created by Claude Montpetit on 16-03-20.
//  Copyright © 2016 Claude Montpetit. All rights reserved.
//

import Foundation
import CoreData


class OccurenceMO: NSManagedObject {

    var delegate: Occurenceable!

    private func touch() {
        wakeup()
        lastModifiedMO = NSDate()
    }
    
    private func wakeup() {
        if (delegate != nil) {
            return
        }
        let occurence = Occurence(task: taskMO!, name: nameMO!, date: dateMO!)
        self.delegate = occurence
    }
    
    override func willSave() {
        super.willSave()        
        if (deleted) {
            return
        }

        
        if delegate.name != nameMO {
            nameMO = delegate.name
        }
        if delegate.date != dateMO {
            dateMO = delegate.date
        }
        if (taskMO == nil) {
            // no need to set the reverse, framework will set it.
        }
    }
}

extension OccurenceMO: Occurenceable {
    
    var task: Taskable {
        wakeup()
        return delegate.task
    }
    
    var name: String {
        get {
            wakeup()
            return delegate.name
        }
        set {
            touch()
            delegate.name = newValue
        }
    }
    
    var date: NSDate {
        get {
            wakeup()
            return delegate.date
        }
        set {
            touch()
            delegate.date = newValue
        }
    }
}
