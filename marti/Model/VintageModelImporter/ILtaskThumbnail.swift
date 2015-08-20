//
//  ILtaskThumbnail.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILtaskThumbnail: NSManagedObject {

    @NSManaged var taskThumbnail_data: NSData
    @NSManaged var taskThumbnail_flags: String
    @NSManaged var taskThumbnail_modifiedDate: NSDate
    @NSManaged var taskThumbnail_version: NSNumber
    @NSManaged var belongToTask: ILtask

}
