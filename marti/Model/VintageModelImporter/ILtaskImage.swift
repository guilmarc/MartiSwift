//
//  ILtaskImage.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILtaskImage: NSManagedObject {

    @NSManaged var taskImage_data: NSData
    @NSManaged var taskImage_flags: String
    @NSManaged var taskImage_modifiedDate: NSDate
    @NSManaged var taskImage_version: NSNumber
    @NSManaged var belongToTask: ILtask

}
