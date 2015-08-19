//
//  RoutineTask.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-19.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class RoutineTask: NSManagedObject {

    @NSManaged var active: Bool
    @NSManaged var duration: Int32
    @NSManaged var eventRoutineTasks: NSOrderedSet
    @NSManaged var routine: Routine
    @NSManaged var task: Task

}
