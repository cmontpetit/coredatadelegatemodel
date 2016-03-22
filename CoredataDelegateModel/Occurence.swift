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
}

class Occurence: Occurenceable {
    
    var name: String
    
    var date: NSDate
    
    init(name: String, date: NSDate) {
        self.name = name
        self.date = date
    }
}