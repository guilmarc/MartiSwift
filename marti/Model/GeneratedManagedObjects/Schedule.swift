//
//  Schedule.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class Schedule: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var scheduledEvents: NSSet
    @NSManaged var user: User

}
