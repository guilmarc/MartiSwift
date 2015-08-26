//
//  Routine.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-26.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class Routine: Schedulable {

    @NSManaged var active: NSNumber
    @NSManaged var audioAssistant: NSData
    @NSManaged var duration: NSNumber
    @NSManaged var index: NSNumber
    @NSManaged var name: String
    @NSManaged var textualAssistant: String
    @NSManaged var thumbnail: NSData
    @NSManaged var eventRoutines: NSOrderedSet
    @NSManaged var routineTasks: NSOrderedSet
    @NSManaged var user: User

}
