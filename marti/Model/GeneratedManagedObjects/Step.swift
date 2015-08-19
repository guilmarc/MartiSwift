//
//  Step.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-19.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class Step: NSManagedObject {

    @NSManaged var active: Bool
    @NSManaged var audioAssistant: NSData
    @NSManaged var duration: Int32
    @NSManaged var index: Int16
    @NSManaged var name: String
    @NSManaged var textualAssistant: String
    @NSManaged var thumbnail: NSData
    @NSManaged var type: Int16
    @NSManaged var task: Task

}
