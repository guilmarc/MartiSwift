//
//  ILstepAudioShort.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILstepAudioShort: NSManagedObject {

    @NSManaged var stepAudioShort_data: NSData
    @NSManaged var stepAudioShort_flags: String
    @NSManaged var stepAudioShort_modifiedDate: NSDate
    @NSManaged var stepAudioShort_version: NSNumber
    @NSManaged var belongToStep: ILstep

}
