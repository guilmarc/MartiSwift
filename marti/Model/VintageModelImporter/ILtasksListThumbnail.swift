//
//  ILtasksListThumbnail.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILtasksListThumbnail: NSManagedObject {

    @NSManaged var tasksListThumbnail_data: NSData
    @NSManaged var tasksListThumbnail_flags: String
    @NSManaged var tasksListThumbnail_modifiedDate: NSDate
    @NSManaged var tasksListThumbnail_version: NSNumber
    @NSManaged var belongToTasksList: ILtasksList

}
