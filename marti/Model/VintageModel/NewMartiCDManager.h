//
//  MartiCoreDataManager.h
//  MartiPro
//
//  Created by Marco Guilmette on 2/13/2014.
//  Copyright (c) 2014 Infologique. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>

@class Task, Step, RoutingStep, MediaStep, User, EventTask, PlannedEvent;

@interface NewMartiCDManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (nonatomic, strong) NSFetchedResultsController* tasksFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController* activeTasksFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController* stepsFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController* activeStepsFetchedResultsController;

+ (NewMartiCDManager*)sharedInstance;
- (void)saveContext;

-(User*)currentUser;

-(Task*)createTask;
-(MediaStep*)createMediaStepInTask:(Task*)task;
-(RoutingStep*)createRoutingStepInTask:(Task*)task;
-(Task*)createTaskInRoutingStep:(RoutingStep*)routingStep;
-(Task*)duplicateTask:(Task*)task;
-(MediaStep*)duplicateMediaStep:(MediaStep*)mediaStep;
-(RoutingStep*)duplicateRoutingStep:(RoutingStep*)routingStep;

-(EventTask*)createEventTaskFromPlannedEvent:(PlannedEvent*)plannedEvent;

-(void)deleteManagedObject:(NSManagedObject*)managedObject;
-(void) deleteAllObjects:(NSString*)entityName;

@end