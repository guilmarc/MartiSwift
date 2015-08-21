//
//  RoutineTask.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class RoutineTask: NSManagedObject {

    @NSManaged var active: NSNumber
    @NSManaged var duration: NSNumber
    @NSManaged var eventRoutineTasks: NSOrderedSet
    @NSManaged var routine: Routine
    @NSManaged var task: Task

}
