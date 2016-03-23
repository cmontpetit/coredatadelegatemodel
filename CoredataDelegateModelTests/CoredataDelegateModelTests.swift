//
//  CoredataDelegateModelTests.swift
//  CoredataDelegateModelTests
//
//  Created by Claude Montpetit on 16-03-20.
//  Copyright © 2016 Claude Montpetit. All rights reserved.
//

import XCTest
import CoreData

@testable import CoredataDelegateModel

class CoredataDelegateModelTests: XCTestCase {
    
    var moc: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        
        // ---: 1
        let modelURL = NSBundle(forClass: self.dynamicType).URLForResource("Model", withExtension: "momd")!
        
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store coordinator failed")
            assert(false)
        }
        
        self.moc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        self.moc.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStackExample() {
        do {
            var project = try ProjectMO.theProject(moc)
            let projectName = project.name
            
            try moc.save()
            moc.reset()
            
            project = try ProjectMO.theProject(moc)
            assert(project.name == projectName)

            var task = Task(name: "t1") as Taskable
            project.tasks.append(task)
            
            try moc.save()
            moc.reset()

            project = try ProjectMO.theProject(moc)
            assert(project.tasks.count == 1)
            task = project.tasks[0]
            assert(task.name == "t1")
            task.name = "t1.1"
            
            try moc.save()
            moc.reset()
            
            project = try ProjectMO.theProject(moc)
            task = project.tasks[0]
            assert(task.name == "t1.1")
            
            var occurence1 = Occurence(task: task, name: "o1", date: NSDate()) as Occurenceable
            var occurence2 = Occurence(task: task, name: "o2", date: NSDate()) as Occurenceable
            
            task.occurences.append(occurence1)
            task.occurences.append(occurence2)
            
            try moc.save()
            moc.reset()
            
            project = try ProjectMO.theProject(moc)
            task = project.tasks[0]
            print(task.occurences.count)
            assert(task.occurences.count == 2)
            assert(task.occurences[0].name == "o1")
            assert(task.occurences[1].name == "o2")
            assert(task.occurences[0].task.name == "t1.1")
            assert(task.occurences[1].task.name == "t1.1")
            
            occurence1 = task.occurences[0]
            occurence1.name = "o1.1"
            occurence2 = task.occurences[1]
            occurence2.name = "o2.1"
            
            try moc.save()
            moc.reset()

            project = try ProjectMO.theProject(moc)
            task = project.tasks[0]
            assert(task.occurences[0].name == "o1.1")
            assert(task.occurences[1].name == "o2.1")

        } catch let error as NSError  {
            print(error)
            assert(false)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
