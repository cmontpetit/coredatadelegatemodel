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
        lastModifiedMO = NSDate()
    }
    
    private func wakeup() {
        if (delegate != nil) {
            return
        }
        let occurence = Occurence(name: nameMO!, date: dateMO!)
        self.delegate = occurence
    }
    
    override func willSave() {
        if delegate.name != nameMO {
            nameMO = delegate.name
        }
        if delegate.date != dateMO {
            dateMO = delegate.date
        }
    }
}

extension OccurenceMO: Occurenceable {
    
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
