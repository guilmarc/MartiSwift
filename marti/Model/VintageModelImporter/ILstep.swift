//
//  ILstep.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILstep: NSManagedObject {

    @NSManaged var step_contentStyle: String
    @NSManaged var step_description: String
    @NSManaged var step_flags: String
    @NSManaged var step_modifiedDate: NSDate
    @NSManaged var step_style: String
    @NSManaged var step_title: String
    @NSManaged var step_useState: String
    @NSManaged var step_version: NSNumber
    @NSManaged var belongToTask: ILtask
    @NSManaged var step_audio: ILstepAudio
    @NSManaged var step_audioShort: ILstepAudioShort
    @NSManaged var step_image: ILstepImage
    @NSManaged var step_thumbnail: ILstepThumbnail
    @NSManaged var step_video: ILstepVideo
    @NSManaged var subStep: ILstep
    @NSManaged var subTasks: ILtasksList
    @NSManaged var superStep: ILstep

}
