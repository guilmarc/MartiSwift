//
//  Event.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-19.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject {

    @NSManaged var done: Bool
    @NSManaged var duration: Int32
    @NSManaged var executionDate: NSTimeInterval
    @NSManaged var plannedDate: NSTimeInterval
    @NSManaged var calendar: Calendar
    @NSManaged var scheduledEvent: ScheduledEvent

}
