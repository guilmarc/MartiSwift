//
//  Schedulable.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-26.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class Schedulable: NSManagedObject {

    @NSManaged var contexts: NSOrderedSet
    @NSManaged var sheduledEvents: NSOrderedSet
    @NSManaged var groups: NSOrderedSet

}
