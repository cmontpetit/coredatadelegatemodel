//
//  TaskMO.swift
//  CoredataDelegateModel
//
//  Created by Claude Montpetit on 16-03-20.
//  Copyright © 2016 Claude Montpetit. All rights reserved.
//

import Foundation
import CoreData


class TaskMO: NSManagedObject {

    internal var delegate: Taskable!
    
    private func touch() {
        lastModifiedMO = NSDate()
    }
    
    private func wakeup() {
        if (delegate != nil) {
            return
        }
        
        var occurences: [Occurenceable] = []
        if let occurencesMO = occurencesMO {
            for o in occurencesMO {
                let o = o as! OccurenceMO
                occurences.append(o)
            }
        }

        let task = Task(name: nameMO!, occurences: occurences)
        self.delegate = task
        self.delegate.occurences = OccurencesMO(taskMO: self, occurences: occurences)
    }
    
    override func willSave() {
        
        var occurenceMOs: [OccurenceMO] = []
        let occurences = delegate.occurences
        var i = 0
        var newEntity = false
        for o in occurences {
            if let o = o as? OccurenceMO {
                // nothing to do, already a managed object
                occurenceMOs.append(o)
                assert(o.owner == self)
            } else {
                newEntity = true
                let entity =  NSEntityDescription.entityForName("OccurenceMO", inManagedObjectContext:self.managedObjectContext!)
                let occurenceMO = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext) as! OccurenceMO
                occurences[i] = occurenceMO
                occurenceMO.delegate = o
                occurenceMOs.append(occurenceMO)
            }
            i += 1
        }
        
        if (newEntity) {
            self.occurencesMO = NSSet(array:occurenceMOs)
        }
        

        if delegate.name != nameMO {
            nameMO = delegate.name
        }
    }
    
    private class OccurencesMO: Occurences {
        
        var taskMO: TaskMO
        
        init(taskMO: TaskMO, occurences: [Occurenceable]) {
            self.taskMO = taskMO
            super.init()
            self.occurences = occurences
        }
        override subscript(index: Int) -> Occurenceable {
            get {
                taskMO.wakeup()
                return super[index]
            }
            set(newValue) {
                taskMO.touch()
                super[index] = newValue
            }
        }
        override func generate() -> IndexingGenerator<[Occurenceable]> {
            taskMO.wakeup()
            return super.generate()
        }
        override func append(occurence: Occurenceable) {
            taskMO.touch()
            super.append(occurence)
        }
        override var count: Int {
            taskMO.wakeup()
            return super.count
        }
    }
    private class xOccurencesMO: Occurences {
        var taskMO: TaskMO
        var delegate: Occurences
        init(taskMO: TaskMO, delegate: Occurences) {
            self.taskMO = taskMO
            self.delegate = delegate
        }
        override subscript(index: Int) -> Occurenceable {
            get {
                taskMO.wakeup()
                return delegate[index]
            }
            set(newValue) {
                taskMO.touch()
                delegate[index] = newValue
            }
        }
        override func generate() -> IndexingGenerator<[Occurenceable]> {
            taskMO.wakeup()
            return delegate.generate()
        }
        override func append(occurence: Occurenceable) {
            taskMO.touch()
            delegate.append(occurence)
        }
        override var count: Int {
            taskMO.wakeup()
            return delegate.count
        }
    }
}

extension TaskMO: Taskable {
    
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
    
    var occurences: Occurences {
        get {
            wakeup()
            return delegate.occurences
        }
        set {
            touch()
            delegate.occurences = newValue
        }
    }
    
}