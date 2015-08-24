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
    
    enum MediaType {
        case MediaTypeImage
        case MediaTypeVideo
    }
    
    var sourceMOC : NSManagedObjectContext?
    var destinationMOC : NSManagedObjectContext?
    
    init(){
        sourceMOC = VintageCDManager.sharedInstance.managedObjectContext
        destinationMOC = MartiCDManager.sharedInstance.managedObjectContext
    }
    
    func clearMOC(){
        //MartiCDManager.sharedInstance.
    }
    
    func importVintageTaskList(vintageTaskList : ILtasksList) -> RoutingStep {
        let newRoutingStep = NSEntityDescription.insertNewObjectForEntityForName("RoutingStep", inManagedObjectContext: destinationMOC!) as! RoutingStep
        
        if let name = vintageTaskList.tasksList_title { newRoutingStep.name = name }
        //newRoutingStep.name = vintageTaskList.tasksList_title
        
        for vintageTask in vintageTaskList.tasks {
            
            let newTask = importVintageTask(vintageTask as! ILtask)
            
            //[newTask addRoutingStepsObject:newRoutingStep];
            var mutableItems = newRoutingStep.tasks.mutableCopy() as! NSMutableOrderedSet
            mutableItems.addObject(newTask)
            newRoutingStep.tasks = mutableItems.copy() as! NSOrderedSet
            
            newTask.isRoot = true
        }
        
        return newRoutingStep
    }
    

    func importMediaData(data: NSData, mediaType: MediaType) -> Media {
        let newMedia = NSEntityDescription.insertNewObjectForEntityForName("Media", inManagedObjectContext: destinationMOC!) as! Media
        newMedia.type = mediaType.hashValue
        newMedia.data = data
        
        return newMedia
    }

    func importVintageSimpleStep(vintageStep: ILstep) -> MediaStep{
        //Create a new MediaStep entity in new model
        let newMediaStep = NSEntityDescription.insertNewObjectForEntityForName("MediaStep", inManagedObjectContext: destinationMOC!) as! MediaStep
        
        //Thoses value can be nil so we unwrap the optional
        if let name = vintageStep.step_title {newMediaStep.name = name}
        if let description = vintageStep.step_description { newMediaStep.textualAssistant = description }

        newMediaStep.thumbnail = vintageStep.step_thumbnail.stepThumbnail_data
        
        if vintageStep.step_contentStyle == "imageAndAudio" {
            newMediaStep.audioAssistant = vintageStep.step_audio.stepAudio_data
            if vintageStep.step_image.stepImage_data.length == 0 {
                newMediaStep.mediaAssistant = importMediaData(vintageStep.step_image.stepImage_data, mediaType: .MediaTypeImage)
            }
        }
        
        if vintageStep.step_contentStyle == "video" {
            newMediaStep.mediaAssistant = importMediaData(vintageStep.step_video.stepVideo_data, mediaType: .MediaTypeVideo)
        }
        
        return newMediaStep
    }
    
    func importVintageTask(vintageTask : ILtask) -> Task {
        let newTask = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: destinationMOC!) as! Task
        if let name = vintageTask.task_title { newTask.name = name }
        newTask.audioAssistant = vintageTask.task_audio.taskAudio_data
        newTask.index =  vintageTask.task_fakeIndex
        newTask.mediaAssistant.data =  vintageTask.task_image.taskImage_data
        //newTask vintageTask.task_language;
        newTask.thumbnail = vintageTask.task_thumbnail.taskThumbnail_data
        newTask.user = MartiCDManager.sharedInstance.currentUser

        //TODO: Find out why we are unable to set to a for in loop
        for var index = 0; index < vintageTask.steps.count; index++ {
            var vintageStep = vintageTask.steps[index] as! ILstep
            
            if vintageStep.step_style == "simpleStep" {
                //TODO: Plante quand un attribut est vide (nil).
                importVintageSimpleStep(vintageStep).task = newTask
            } else {
                importVintageTaskList(vintageStep.subTasks).task = newTask
            }
        }
        return newTask
    }
    
    func importData(){
        clearMOC()
        
        var user = MartiCDManager.sharedInstance.currentUser
        
        let fetchRequest = NSFetchRequest(entityName: "ILtask")
        let vintageTasks : [ILtask] = sourceMOC?.executeFetchRequest(fetchRequest, error: nil) as! [ILtask]

        //let vintageTask : ILtask
        for vintageTask in vintageTasks {
            if vintageTask.belongToTasksList.tasksList_type == "root" {
                importVintageTask(vintageTask)
            }
        }
        
        //print("Username = \(user.name)")
       
        MartiCDManager.sharedInstance.saveContext()
    }
    

}