//
//  ScheduledEvent.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-20.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class ScheduledEvent: NSManagedObject {

    @NSManaged var duration: NSNumber
    @NSManaged var endDate: NSDate
    @NSManaged var isExclusionEvent: NSNumber
    @NSManaged var note: String
    @NSManaged var events: NSOrderedSet
    @NSManaged var schedulable: Schedulable
    @NSManaged var schedule: Schedule

}
