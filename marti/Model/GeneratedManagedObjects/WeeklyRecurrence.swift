//
//  WeeklyRecurrence.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-19.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class WeeklyRecurrence: RecursiveEvent {

    @NSManaged var day0: Bool
    @NSManaged var day1: Bool
    @NSManaged var day2: Bool
    @NSManaged var day3: Bool
    @NSManaged var day4: Bool
    @NSManaged var day5: Bool
    @NSManaged var day6: Bool
    @NSManaged var recurrence: Int16

}
