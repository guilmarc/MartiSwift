//
//  Task.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-20.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class Task: Schedulable {

    @NSManaged var active: NSNumber
    @NSManaged var audioAssistant: NSData
    @NSManaged var duration: NSNumber
    @NSManaged var index: NSNumber
    @NSManaged var isRoot: NSNumber
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
