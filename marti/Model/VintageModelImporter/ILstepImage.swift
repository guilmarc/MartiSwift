//
//  ILstepImage.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILstepImage: NSManagedObject {

    @NSManaged var stepImage_data: NSData
    @NSManaged var stepImage_flags: String
    @NSManaged var stepImage_modifiedDate: NSDate
    @NSManaged var stepImage_version: NSNumber
    @NSManaged var belongToStep: ILstep

}
