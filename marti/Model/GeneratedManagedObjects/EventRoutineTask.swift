//
//  EventRoutineTask.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-26.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class EventRoutineTask: NSManagedObject {

    @NSManaged var done: NSNumber
    @NSManaged var duration: NSNumber
    @NSManaged var eventRoutine: EventRoutine
    @NSManaged var routineTask: RoutineTask

}
