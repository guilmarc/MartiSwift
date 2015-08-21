//
//  Media.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class Media: NSManagedObject {

    @NSManaged var data: NSData
    @NSManaged var type: NSNumber

}
