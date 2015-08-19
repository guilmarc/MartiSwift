//
//  MonthlyRecurrence.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-19.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class MonthlyRecurrence: RecursiveEvent {

    @NSManaged var recurrence: Int16
    @NSManaged var recurrenceMonthDay: Int16

}