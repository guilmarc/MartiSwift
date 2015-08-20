//
//  ILtasksListAudio.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILtasksListAudio: NSManagedObject {

    @NSManaged var tasksListAudio_data: NSData
    @NSManaged var tasksListAudio_flags: String
    @NSManaged var tasksListAudio_modifiedDate: NSDate
    @NSManaged var tasksListAudio_version: NSNumber
    @NSManaged var belongToTasksList: ILtasksList

}
