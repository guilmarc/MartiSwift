//
//  RecursiveEvent.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class RecursiveEvent: ScheduledEvent {

    @NSManaged var endAfterOccurence: NSNumber
    @NSManaged var startDate: NSDate

}
