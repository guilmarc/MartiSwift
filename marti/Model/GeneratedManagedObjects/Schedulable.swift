//
//  Schedulable.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class Schedulable: NSManagedObject {

    @NSManaged var contexts: NSSet
    @NSManaged var sheduledEvents: NSSet

}
