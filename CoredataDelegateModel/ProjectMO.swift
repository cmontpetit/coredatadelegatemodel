//
//  ProjectMO.swift
//  CoredataDelegateModel
//
//  Created by Claude Montpetit on 16-03-20.
//  Copyright © 2016 Claude Montpetit. All rights reserved.
//

import Foundation
import CoreData


class ProjectMO: NSManagedObject {

    private var delegate: Projectable!
    
    private func touch() {
        lastModifiedMO = NSDate()
    }
    
    private func wakeup() {
        if (delegate != nil) {
            return
        }
        
        var tasks: [Taskable] = []
        if let tasksMO = tasksMO {
            for o in tasksMO {
                let t = o as! TaskMO
                tasks.append(t)
            }
        }

        let project = Project(name: nameMO!)
        self.delegate = project
        self.delegate.tasks = TasksMO(projectMO: self, tasks: tasks)
    }
    
    override func willSave() {
        
        var taskMOs: [TaskMO] = []
        let tasks = delegate.tasks
        var i = 0
        var newEntity = false
        for o in tasks {
            if let o = o as? TaskMO {
                // nothing to do, already a managed object
                assert(o.unused == self) // sanity check
                taskMOs.append(o)
            } else {
                newEntity = true
                let entity =  NSEntityDescription.entityForName("TaskMO", inManagedObjectContext:self.managedObjectContext!)
                let taskMO = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext) as! TaskMO
                tasks[i] = taskMO
                taskMO.delegate = o
                taskMOs.append(taskMO)
            }
            i += 1
        }
        
        // check each value's change
        
        if (newEntity) {
            self.tasksMO = NSOrderedSet(array:taskMOs)
        }
        
        
        if delegate.name != nameMO {
            nameMO = delegate.name
        }
    }
    
    private class TasksMO: Tasks {
        var projectMO: ProjectMO
        init(projectMO: ProjectMO, tasks: [Taskable]) {
            self.projectMO = projectMO
            super.init(project: projectMO)
            self.tasks = tasks
        }
        override subscript(index: Int) -> Taskable {
            get {
                projectMO.wakeup()
                return super[index]
            }
            set(newValue) {
                projectMO.touch()
                super[index] = newValue
            }
        }
        override func generate() -> IndexingGenerator<[Taskable]> {
            projectMO.wakeup()
            return super.generate()
        }
        override func append(task: Taskable) {
            projectMO.touch()
            super.append(task)
        }
        override var count: Int {
            projectMO.wakeup()
            return super.count
        }
    }
}

extension ProjectMO: Projectable {
    
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
    
    var tasks: Tasks {
        get {
            wakeup()
            return delegate.tasks
        }
        set {
            touch()
            delegate.tasks = newValue
        }
    }
}

extension ProjectMO {
    static func theProject(managedContext: NSManagedObjectContext) throws -> ProjectMO {
        
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("ProjectMO", inManagedObjectContext: managedContext)
        fetchRequest.entity = entityDescription
        
        let result = try managedContext.executeFetchRequest(fetchRequest)
        if result.count == 0 {
            let projectMO = NSManagedObject(entity: entityDescription!,
                insertIntoManagedObjectContext: managedContext) as! ProjectMO
            let project = Project(name: "New Project")
            projectMO.delegate = project
            return projectMO
        } else {
            return result[0] as! ProjectMO
        }
    }
}
