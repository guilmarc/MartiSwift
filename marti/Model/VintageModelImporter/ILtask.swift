//
//  ILtask.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILtask: NSManagedObject {

    @NSManaged var task_accessRights: String
    @NSManaged var task_description: String?
    @NSManaged var task_fakeIndex: NSNumber
    @NSManaged var task_flags: String
    @NSManaged var task_language: String
    @NSManaged var task_modifiedDate: NSDate
    @NSManaged var task_title: String?
    @NSManaged var task_useState: String
    @NSManaged var task_version: NSNumber
    @NSManaged var belongToTasksList: ILtasksList
    @NSManaged var steps: NSOrderedSet
    @NSManaged var task_audio: ILtaskAudio
    @NSManaged var task_audioShort: ILtaskAudioShort
    @NSManaged var task_image: ILtaskImage
    @NSManaged var task_thumbnail: ILtaskThumbnail

}
