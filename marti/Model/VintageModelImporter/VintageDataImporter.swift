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
        sourceMOC = VintageCDManager.sharedInstance.managedObjectContext
        destinationMOC = MartiCDManager.sharedInstance.managedObjectContext
    }
    
    func clearMOC(){
        //MartiCDManager.sharedInstance.
    }

    
    
    func importVintageTask(vintageTask : ILtask) -> Task {
        let newTask = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: destinationMOC!) as! Task
        newTask.name = vintageTask.task_title
        newTask.audioAssistant = vintageTask.task_audio.taskAudio_data
        newTask.index =  vintageTask.task_fakeIndex
        newTask.mediaAssistant.data =  vintageTask.task_image.taskImage_data
        //newTask vintageTask.task_language;
        newTask.thumbnail = vintageTask.task_thumbnail.taskThumbnail_data
        newTask.user = MartiCDManager.sharedInstance.currentUser
        
        
        for var index = 0; index < vintageTask.steps.count; index++ {
            var vintageStep = vintageTask.steps[index] as! ILstep
            
            if vintageStep.step_style == "simpleStep" {
               
                if (vintageStep.step_title == "") {
                    print("Simple Step: \(vintageStep.step_title)\n")
                } else {
                     print("Simple Step: TO TITLE\n")
                }
                
            
            } else {
                print("Choice Step: \(vintageStep.step_title)\n")
            }
        }
        return newTask
    }
    
    func importData(){
        clearMOC()
        
        var user = MartiCDManager.sharedInstance.currentUser
        
        let fetchRequest = NSFetchRequest(entityName: "ILtask")
        let vintageTasks : [NSManagedObject]? = sourceMOC?.executeFetchRequest(fetchRequest, error: nil) as? [NSManagedObject]
        
        for var index = 0; index < vintageTasks!.count; index++ {
            let vintageTask : ILtask = vintageTasks![index] as! ILtask
            

            if vintageTask.belongToTasksList.tasksList_type == "root" {
                importVintageTask(vintageTask)
            }
        }

        print("Username = \(user.name)")
       
        MartiCDManager.sharedInstance.saveContext()
    }
    

}