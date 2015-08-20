//
//  ILtaskAudioShort.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILtaskAudioShort: NSManagedObject {

    @NSManaged var taskAudioShort_data: NSData
    @NSManaged var taskAudioShort_flags: String
    @NSManaged var taskAudioShort_modifiedDate: NSDate
    @NSManaged var taskAudioShort_version: NSNumber
    @NSManaged var belongToTask: ILtask

}
