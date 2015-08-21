//
//  EventRoutineTask.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class EventRoutineTask: NSManagedObject {

    @NSManaged var done: NSNumber
    @NSManaged var duration: NSNumber
    @NSManaged var eventRoutine: EventRoutine
    @NSManaged var routineTask: RoutineTask

}
