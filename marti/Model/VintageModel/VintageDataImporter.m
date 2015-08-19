//
//  VintageDataImporter.m
//  MartiPro
//
//  Created by Marco Guilmette on 2/13/2014.
//  Copyright (c) 2014 Infologique. All rights reserved.
//

#import "VintageDataImporter.h"

#import "VintageMartiCDManager.h"
#import "MartiCDManager.h"

//Vintage Model
#import "ILgroup.h"
#import "ILstep.h"
#import "ILstepAudio.h"
#import "ILstepAudioShort.h"
#import "ILstepImage.h"
#import "ILstepThumbnail.h"
#import "ILstepVideo.h"
#import "ILtask.h"
#import "ILtaskAudio.h"
#import "ILtaskAudioShort.h"
#import "ILtaskImage.h"
#import "ILtasksList.h"
#import "ILtasksListAudio.h"
#import "ILtasksListThumbnail.h"
#import "ILtaskThumbnail.h"

//New Model
#import "Task.h"
#import "MediaStep.h"
#import "RoutingStep.h"
#import "Media+Human.h"
#import "User.h"
#import "Calendar.h"


@implementation VintageDataImporter {
    NSManagedObjectContext* sourceMOC;
    NSManagedObjectContext* destinationMOC;
    
    User *newUser;
}

+ (VintageDataImporter*)sharedInstance
{
    
    static VintageDataImporter *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[VintageDataImporter alloc] init];
    });
    return _sharedInstance;
}


-(Task*)importVintageTask:(ILtask*)vintageTask{
    
    NSEntityDescription *taskEntity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:destinationMOC];
    Task* newTask = (Task*)[[NSManagedObject alloc] initWithEntity:taskEntity insertIntoManagedObjectContext:destinationMOC];
    
    newTask.name = vintageTask.task_title;
    newTask.audioAssistant = vintageTask.task_audio.taskAudio_data;
    newTask.index =  vintageTask.task_fakeIndex;
    newTask.mediaAssistant.data =  vintageTask.task_image.taskImage_data;
    //newTask vintageTask.task_language;
    newTask.thumbnail = vintageTask.task_thumbnail.taskThumbnail_data;
    
    newTask.user = newUser;
    
    for( ILstep* vintageStep in vintageTask.steps) {
        //NSLog(@"StepStyle = %@", vintageStep.step_style);
        if( [vintageStep.step_style isEqualToString:@"simpleStep"]  ) {

            [self importVintageSimpleStep:vintageStep].task = newTask;
            
        } else { //choiceStep
            
            [self importVintageTaskList:vintageStep.subTasks].task = newTask;
        }
        
    }
    
    
    
    return newTask;
}


-(Media*)importMediaData:(NSData*)data ofType:(enum MediaType)mediaType{
    
    NSEntityDescription *taskEntity = [NSEntityDescription entityForName:@"Media" inManagedObjectContext:destinationMOC];
    Media* newMedia = (Media*)[[NSManagedObject alloc] initWithEntity:taskEntity insertIntoManagedObjectContext:destinationMOC];
    
    newMedia.type = [NSNumber numberWithInt:mediaType];
    newMedia.data = data;
    
    return newMedia;
}

-(MediaStep*)importVintageSimpleStep:(ILstep*)vintageStep{
    NSEntityDescription *taskEntity = [NSEntityDescription entityForName:@"MediaStep" inManagedObjectContext:destinationMOC];
    MediaStep* newMediaStep = (MediaStep*)[[NSManagedObject alloc] initWithEntity:taskEntity insertIntoManagedObjectContext:destinationMOC];
    
    newMediaStep.name = vintageStep.step_title;
    newMediaStep.textualAssistant = vintageStep.step_description;
    newMediaStep.thumbnail = vintageStep.step_thumbnail.stepThumbnail_data;
    
    //NSLog(@"%@", vintageStep.step_contentStyle);
    
    if ( [vintageStep.step_contentStyle isEqualToString:@"imageAndAudio"] ) {

        newMediaStep.audioAssistant = vintageStep.step_audio.stepAudio_data;
        
        if( vintageStep.step_image.stepImage_data != nil)
        newMediaStep.mediaAssistant = [self importMediaData: vintageStep.step_image.stepImage_data ofType:MediaTypeImage];
        
        NSLog(@"%@ is imageAndAudio", vintageStep.step_title);
        
    }
    
    if ( [vintageStep.step_contentStyle isEqualToString:@"video"] ) {
        
        if( vintageStep.step_video.stepVideo_data != nil)
        newMediaStep.mediaAssistant = [self importMediaData: vintageStep.step_video.stepVideo_data ofType:MediaTypeVideo];
        
        NSLog(@"%@ is video", vintageStep.step_title);
    }
    
    return newMediaStep;
}

-(RoutingStep*)importVintageTaskList:(ILtasksList*)vintageTaskList{
    NSEntityDescription *taskEntity = [NSEntityDescription entityForName:@"RoutingStep" inManagedObjectContext:destinationMOC];
    RoutingStep* newRoutingStep = (RoutingStep*)[[NSManagedObject alloc] initWithEntity:taskEntity insertIntoManagedObjectContext:destinationMOC];
    
    newRoutingStep.name = vintageTaskList.tasksList_title;
    
    //Loop throught all task in this ILtaskList
    for ( ILtask* vintageTask in vintageTaskList.tasks) {
        
        //TODO: Find how to link task to RoutingStep HERE
        //[newRoutingStep addTasksObject:[self importVintageTask:vintageTask]];
        
        Task* newTask = [self importVintageTask:vintageTask];
        [newTask addRoutingStepsObject:newRoutingStep];
        newTask.isRoot = [NSNumber numberWithBool:NO];
     
    }
    
    return newRoutingStep;
}

-(void)importData{
    
    [self clearStore];
    
    sourceMOC = [[VintageMartiCDManager sharedManager] managedObjectContext];
    destinationMOC = [[MartiCDManager sharedInstance] managedObjectContext];
    
    newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:destinationMOC];
    newUser.name = @"Default";
    
    //Create the default calendar (could be directly linked to user ???)
    Calendar* newCalendar = [NSEntityDescription insertNewObjectForEntityForName:@"Calendar" inManagedObjectContext:destinationMOC];
    newCalendar.user = newUser;
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ILtask"];
    
    NSArray* VintageTasks = [sourceMOC executeFetchRequest:fetchRequest error:nil];
    
    for( ILtask* vintageTask in VintageTasks ) {
        //If this is a root task
        if ( [vintageTask.belongToTasksList.tasksList_type isEqualToString:@"root"] ) {
            [self importVintageTask:vintageTask];
            [[MartiCDManager sharedInstance] saveContext];
            
            NSLog(@"Importing vintage task : %@", vintageTask.task_title);
        }
    }

}

-(void)clearStore{
    [[MartiCDManager sharedInstance] deleteAllObjects:@"User"];
    [[MartiCDManager sharedInstance] deleteAllObjects:@"Media"];
}

@end
