//
//  MonthlyRecurrence.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class MonthlyRecurrence: RecursiveEvent {

    @NSManaged var recurrence: NSNumber
    @NSManaged var recurrenceMonthDay: NSNumber

}
