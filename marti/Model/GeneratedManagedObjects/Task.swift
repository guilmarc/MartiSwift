//
//  Task.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-19.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class Task: Schedulable {

    @NSManaged var active: Bool
    @NSManaged var audioAssistant: NSData
    @NSManaged var duration: Int32
    @NSManaged var index: Int16
    @NSManaged var isRoot: Bool
    @NSManaged var name: String
    @NSManaged var ownerID: String
    @NSManaged var thumbnail: NSData
    @NSManaged var eventTasks: NSOrderedSet
    @NSManaged var mediaAssistant: Media
    @NSManaged var routineTasks: RoutineTask
    @NSManaged var routingSteps: NSSet
    @NSManaged var steps: NSOrderedSet
    @NSManaged var user: User

}
