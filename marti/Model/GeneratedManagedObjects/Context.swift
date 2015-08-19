//
//  Context.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-19.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class Context: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var schedulables: NSSet

}