//
//  ILstepVideo.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILstepVideo: NSManagedObject {

    @NSManaged var stepVideo_data: NSData
    @NSManaged var stepVideo_flags: String
    @NSManaged var stepVideo_modifiedDate: NSDate
    @NSManaged var stepVideo_version: NSNumber
    @NSManaged var belongToStep: ILstep

}
