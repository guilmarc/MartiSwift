//
//  ILtasksList.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILtasksList: NSManagedObject {

    @NSManaged var tasksList_accessRights: String
    @NSManaged var tasksList_flags: String
    @NSManaged var tasksList_groupName: String
    @NSManaged var tasksList_modifiedDate: NSDate
    @NSManaged var tasksList_title: String
    @NSManaged var tasksList_type: String
    @NSManaged var tasksList_useState: String
    @NSManaged var tasksList_version: NSNumber
    @NSManaged var belongToGroup: ILgroup
    @NSManaged var belongToStep: ILstep
    @NSManaged var tasks: NSOrderedSet
    @NSManaged var tasksList_audio: ILtasksListAudio
    @NSManaged var tasksList_thumbnail: ILtasksListThumbnail

}
