//
//  User.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var activeRootTasks: NSOrderedSet
    @NSManaged var calendar: Calendar
    @NSManaged var routines: NSOrderedSet
    @NSManaged var schedules: NSSet
    @NSManaged var tasks: NSOrderedSet

}
