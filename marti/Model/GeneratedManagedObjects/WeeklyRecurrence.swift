//
//  WeeklyRecurrence.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-20.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class WeeklyRecurrence: RecursiveEvent {

    @NSManaged var day0: NSNumber
    @NSManaged var day1: NSNumber
    @NSManaged var day2: NSNumber
    @NSManaged var day3: NSNumber
    @NSManaged var day4: NSNumber
    @NSManaged var day5: NSNumber
    @NSManaged var day6: NSNumber
    @NSManaged var recurrence: NSNumber

}
