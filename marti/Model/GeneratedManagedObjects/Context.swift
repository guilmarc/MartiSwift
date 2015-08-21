//
//  Context.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class Context: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var schedulables: NSSet

}
