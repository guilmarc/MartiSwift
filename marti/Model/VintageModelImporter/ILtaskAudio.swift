//
//  ILtaskAudio.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILtaskAudio: NSManagedObject {

    @NSManaged var taskAudio_data: NSData
    @NSManaged var taskAudio_flags: String
    @NSManaged var taskAudio_modifiedDate: NSDate
    @NSManaged var taskAudio_version: NSNumber
    @NSManaged var belongToTask: ILtask

}
