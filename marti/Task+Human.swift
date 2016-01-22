//
//  Task+Human.swift
//  marti
//
//  Created by Marco Guilmette on 2015-08-26.
//  Copyright (c) 2015 Infologique. All rights reserved.
//

import Foundation

extension Task {
    
    func addToGroup(group: Group){
        let mutableItems = self.groups.mutableCopy() as! NSMutableOrderedSet
        mutableItems.addObject(group)
        self.groups = mutableItems.copy() as! NSOrderedSet
    }
    
    func removeFromGroup(group: Group){
        let mutableItems = self.groups.mutableCopy() as! NSMutableOrderedSet
        mutableItems.removeObject(group)
        self.groups = mutableItems.copy() as! NSOrderedSet
    }
    
    
}