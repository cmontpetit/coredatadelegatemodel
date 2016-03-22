//
//  Project.swift
//  CoredataDelegateModel
//
//  Created by Claude Montpetit on 16-03-20.
//  Copyright © 2016 Claude Montpetit. All rights reserved.
//

import Foundation

public protocol Projectable {
    var name: String { get set }
    var tasks: Tasks { get set }
}


public class Tasks: SequenceType {
    
    var tasks: [Taskable] = []
    
    public subscript(index: Int) -> Taskable {
        get {
            return tasks[index]
        }
        set(newValue) {
            tasks[index] = newValue
        }
    }
    
    public func generate() -> IndexingGenerator<[Taskable]> {
        return tasks.generate()
    }
    
    public func append(task: Taskable) {
        tasks.append(task)
    }
    
    public var count: Int {
        return tasks.count
    }
}

class Project: Projectable {
    
    var name: String
    
    var tasks = Tasks()
    
    init(name: String){
        self.name = name
    }
    
    init(name: String, tasks: [Taskable]){
        self.name = name
        self.tasks.tasks.insertContentsOf(tasks, at: 0)
    }
    
}
