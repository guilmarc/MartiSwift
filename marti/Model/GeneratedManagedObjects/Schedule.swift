//
//  Schedule.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-26.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class Schedule: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var scheduledEvents: NSOrderedSet
    @NSManaged var user: User

}
