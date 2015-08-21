//
//  Calendar.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class Calendar: NSManagedObject {

    @NSManaged var events: NSSet
    @NSManaged var user: User

}
