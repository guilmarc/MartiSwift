//
//  EventRoutine.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class EventRoutine: Event {

    @NSManaged var eventRoutineTasks: NSOrderedSet
    @NSManaged var routine: Routine

}
