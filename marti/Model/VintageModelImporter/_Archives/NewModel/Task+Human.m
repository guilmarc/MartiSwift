//
//  Task+Human.m
//  marti
//
//  Created by Marco Guilmette on 2/18/2014.
//
//

#import "Task+Human.h"
#import "MediaStep+Human.h"
#import "RoutingStep+Human.h"
#import "Step+Human.h"
#import "Media+Human.h"

@class MediaStep;

@implementation Task (Human)

@dynamic currentStepIndex;

    NSUInteger mediaStepCount=0;
    NSUInteger routingStepCount=0;
    Step* _currentStep;


+(Task*)createTaskInMOC:(NSManagedObjectContext*)moc forUser:(User*)user {
   
    Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:moc];
    
    newTask.user = user;
    
    //Create an empty MediaStep and associate it to newly created Task entity
    [MediaStep createMediaStepInMOC:moc].task = newTask; //Workaround for -[NSSet intersectsSet:]: set argument is not an NSSet'
    
    return newTask;
}

-(Task*)copy{
    Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    newTask.active = self.active;
    newTask.audioAssistant = self.audioAssistant;
    newTask.duration = self.duration;
    newTask.index = self.index;
    newTask.isRoot = self.isRoot;
    newTask.name = self.name;
    newTask.ownerID = self.ownerID;
    newTask.thumbnail = self.thumbnail;

    
    if (self.mediaAssistant != nil ) {
        newTask.mediaAssistant =  [self.mediaAssistant copy];
    }
    
    for(Step* thisStep in self.steps){
        if ([thisStep isMediaStep]) {
            [(MediaStep*)thisStep copy].task = newTask;
        }
        
        if ([thisStep isRoutingStep]) {
            [(RoutingStep*)thisStep copy].task = newTask;
        }
    }
    
    return newTask;
}

-(BOOL)isWriteProtected{
    return false;
}

-(BOOL)isFirstStep{
    return self.currentStepIndex == 0;
}

-(BOOL)isLastStep{
    return self.currentStepIndex == ([self.steps count] - 1);
}


-(NSOrderedSet*)activeSteps{

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"active == %@", @true];
    return [self.steps filteredOrderedSetUsingPredicate:predicate];
}

-(void)setCurrentStepIndex:(NSUInteger)currentStepIndex {
    _currentStep = [self.steps  objectAtIndex:currentStepIndex];
}

-(NSUInteger)currentStepIndex{
    return [self.steps indexOfObject:_currentStep];
}

-(Step*)currentStep{
    return _currentStep;
}

-(void)setCurrentStep:(Step *)currentStep{
    _currentStep = currentStep;
}


-(UIImage*)thumbnailImage{
    if( self.thumbnail != nil ) {
        return [UIImage imageWithData:self.thumbnail];
    } else {
        return [UIImage imageNamed:@"taskPlaceholder"];
    }
}

-(NSString*)title{
    if( self.name.length > 1 ) {
        return self.name;
    } else {
        return NSLocalizedString(@"DummyTitleTaskKey", @"");
    }
}


-(NSString*)structureDescription{
    mediaStepCount=0;
    routingStepCount=0;
    
    
    [self recursiveCountInTask:self];
    
    
    return [NSString stringWithFormat:@"%i %@ + %i %@",mediaStepCount,
            (mediaStepCount>1?NSLocalizedString(@"labelStepsCellTypeKey", @""):NSLocalizedString(@"labelStepCellTypeKey", @"")),
            routingStepCount,
            (routingStepCount>1?NSLocalizedString(@"labelChoicesCellTypeKey", @""):NSLocalizedString(@"labelChoiceCellTypeKey", @""))];
}

-(void)recursiveCountInTask:(Task*)task{
    for (Step* thisStep in task.steps) {
        if( [thisStep isMediaStep] ) {
            mediaStepCount++;
        }
        
        if( [thisStep isRoutingStep] ) {
            routingStepCount++;
            
            for (Task* thisTask in ((RoutingStep*)thisStep).tasks ) {
                [self recursiveCountInTask:thisTask];
            }
             
        }
    }
}


@end
