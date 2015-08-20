//
//  ILstepAudio.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILstepAudio: NSManagedObject {

    @NSManaged var stepAudio_data: NSData
    @NSManaged var stepAudio_flags: String
    @NSManaged var stepAudio_modifiedDate: NSDate
    @NSManaged var stepAudio_version: NSNumber
    @NSManaged var belongToStep: ILstep

}
