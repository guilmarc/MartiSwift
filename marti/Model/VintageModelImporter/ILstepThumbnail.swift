//
//  ILstepThumbnail.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILstepThumbnail: NSManagedObject {

    @NSManaged var stepThumbnail_data: NSData
    @NSManaged var stepThumbnail_flags: String
    @NSManaged var stepThumbnail_modifiedDate: NSDate
    @NSManaged var stepThumbnail_version: NSNumber
    @NSManaged var belongToStep: ILstep

}
