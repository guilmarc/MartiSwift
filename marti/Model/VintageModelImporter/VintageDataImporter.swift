//
//  VintageDataImporter.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-19.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation
import CoreData

class VintageDataImporter {
    
    var sourceMOC : NSManagedObjectContext?
    var destinationMOC : NSManagedObjectContext?
    
    init(){
        sourceMOC = nil
        destinationMOC = MartiCDManager.sharedInstance.managedObjectContext
    }
    
    func clearMOC(){
        //MartiCDManager.sharedInstance.
    }

    func importData(){
        clearMOC()
        
        var user = MartiCDManager.sharedInstance.currentUser
        
        print("Username = \(user.name)")
       
        MartiCDManager.sharedInstance.saveContext()
    }
    

}