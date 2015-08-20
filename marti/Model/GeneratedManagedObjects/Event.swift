//
//  Event.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-20.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject {

    @NSManaged var done: NSNumber
    @NSManaged var duration: NSNumber
    @NSManaged var executionDate: NSDate
    @NSManaged var plannedDate: NSDate
    @NSManaged var calendar: Calendar
    @NSManaged var scheduledEvent: ScheduledEvent

}
