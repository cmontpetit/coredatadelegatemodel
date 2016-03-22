//
//  Task.swift
//  CoredataDelegateModel
//
//  Created by Claude Montpetit on 16-03-20.
//  Copyright © 2016 Claude Montpetit. All rights reserved.
//

import Foundation

public protocol Taskable {
    var name: String { get set }
    var occurences: Occurences { get set }
}

public class Occurences: SequenceType {
    
    var occurences: [Occurenceable] = []
    
    public subscript(index: Int) -> Occurenceable {
        get {
            return occurences[index]
        }
        set(newValue) {
            occurences[index] = newValue
        }
    }
    
    public func generate() -> IndexingGenerator<[Occurenceable]> {
        return occurences.generate()
    }
    
    public func append(occurence: Occurenceable) {
        occurences.append(occurence)
    }
    
    public var count: Int {
        return occurences.count
    }
}

class Task: Taskable {
    
    var name: String
    
    var occurences = Occurences()
    
    init(name: String){
        self.name = name
    }
    
    init(name: String, occurences: [Occurenceable]){
        self.name = name
        self.occurences.occurences.insertContentsOf(occurences, at: 0)
    }
}
