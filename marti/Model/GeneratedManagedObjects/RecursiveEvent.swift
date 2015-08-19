//
//  RecursiveEvent.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-19.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class RecursiveEvent: ScheduledEvent {

    @NSManaged var endAfterOccurence: Int16
    @NSManaged var startDate: NSTimeInterval

}
