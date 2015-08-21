//
//  Step.swift
//  
//
//  Created by Marco Guilmette on 2015-08-21.
//
//

import Foundation
import CoreData

class Step: NSManagedObject {

    @NSManaged var active: NSNumber
    @NSManaged var audioAssistant: NSData
    @NSManaged var duration: NSNumber
    @NSManaged var index: NSNumber
    @NSManaged var name: String
    @NSManaged var textualAssistant: String
    @NSManaged var thumbnail: NSData
    @NSManaged var type: NSNumber
    @NSManaged var task: Task

}
