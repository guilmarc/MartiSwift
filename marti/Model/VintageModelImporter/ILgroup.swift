//
//  ILgroup.swift
//  
//
//  Created by Marco Guilmette on 2015-08-20.
//
//

import Foundation
import CoreData

class ILgroup: NSManagedObject {

    @NSManaged var group_accessRights: String
    @NSManaged var group_description: String
    @NSManaged var group_fakeIndex: NSNumber
    @NSManaged var group_flags: String
    @NSManaged var group_language: String
    @NSManaged var group_modifiedDate: NSDate
    @NSManaged var group_name: String
    @NSManaged var group_title: String
    @NSManaged var group_useState: String
    @NSManaged var group_version: NSNumber
    @NSManaged var tasksList: ILtasksList

}
