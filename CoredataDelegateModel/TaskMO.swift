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
        wakeup()
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
        super.willSave()
        if (deleted) {
            return
        }
        
        var occurenceMOs: [OccurenceMO] = []
        let occurences = delegate.occurences
        var i = 0
        var newEntity = false
        for o in occurences {
            if let o = o as? OccurenceMO {
                occurenceMOs.append(o)
                // Note that this assert is only true if an occurence cannot end up in another
                // task after its previous task has been deleted.
                assert(o.taskMO == self)
            } else {
                newEntity = true
                let occurenceMO = NSEntityDescription.insertNewObjectForEntityForName("OccurenceMO", inManagedObjectContext: self.managedObjectContext!) as! OccurenceMO
                occurences[i] = occurenceMO
                occurenceMO.delegate = o
                occurenceMOs.append(occurenceMO)
            }
            i += 1
        }
        
        // check changes before assigning to MOs to avoid infinite save loop calls
        
        if (newEntity) {
            // todo: handle deletion of occurernces!
            self.occurencesMO = NSOrderedSet(array:occurenceMOs)
        }
        
        if delegate.name != nameMO {
            nameMO = delegate.name
        }
    }
    
    private class OccurencesMO: Occurences {
        
        var taskMO: TaskMO
        
        init(taskMO: TaskMO, occurences: [Occurenceable]) {
            self.taskMO = taskMO
            super.init(task: taskMO)
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
