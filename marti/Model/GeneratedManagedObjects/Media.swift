//
//  Media.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-20.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class Media: NSManagedObject {

    @NSManaged var data: NSData
    @NSManaged var type: NSNumber

}
