//
//  MartiCoreDataManager.m
//  MartiPro
//
//  Created by Marco Guilmette on 2/13/2014.
//  Copyright (c) 2014 Infologique. All rights reserved.
//

#import "NewMartiCDManager.h"
#import "Task+Human.h"
#import "MediaStep+Human.h"
#import "RoutingStep+Human.h"
#import "Media+Human.h"
#import "EventTask.h"
#import "PlannedEvent.h"

@interface NewMartiCDManager() {
    User* _currentUser;
}

// static will be used for pre build content (if needed)
//@property (readonly, strong, nonatomic) NSManagedObjectContext *staticDataManagedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *staticDataManagedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *staticDataPersistentStoreCoordinator;

// dynamic
//@property (readonly, strong, nonatomic) NSManagedObjectContext *dynamicDataManagedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *dynamicDataManagedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *dynamicDataPersistentStoreCoordinator;

@end


@implementation NewMartiCDManager {
    NSFetchedResultsController* _tasksFetchedResultsController;
    NSFetchedResultsController* _activeTasksFetchedResultsController;
    NSFetchedResultsController* _stepsFetchedResultsController;
    NSFetchedResultsController* _activeStepsFetchedResultsController;
}


//@synthesize staticDataManagedObjectContext = _staticDataManagedObjectContext;
//@synthesize staticDataManagedObjectModel = _staticDataManagedObjectModel;
//synthesize staticDataPersistentStoreCoordinator = _staticDataPersistentStoreCoordinator;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Singleton
// return a singleton of the filterCD manager

+ (MartiCDManager*)sharedInstance
{

    static MartiCDManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[MartiCDManager alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - FetchedUser
-(User*)currentUser{
    
    if( self->_currentUser) {return _currentUser;}
    
    NSError *error = nil;
    
    NSArray* users = [self.managedObjectContext executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"User"] error:&error];
    if( !error ){
        _currentUser = [users firstObject];
    }
    return _currentUser;
}

#pragma mark - NSFetchedResultsController

-(NSFetchedResultsController*)activeTasksFetchedResultsController
{
    if (self->_activeTasksFetchedResultsController)
    {
        return self->_activeTasksFetchedResultsController;
    }
    //Create the fetchRequest for a specific entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRoot == 1 AND active == 1"];
    [fetchRequest setPredicate:predicate];
    
    
    // Sort using the page property.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    self->_activeTasksFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return self->_activeTasksFetchedResultsController;
}


-(NSFetchedResultsController*)tasksFetchedResultsController
{
    if (self->_tasksFetchedResultsController)
    {
        return self->_tasksFetchedResultsController;
    }
    //Create the fetchRequest for a specific entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRoot == 1"];
    [fetchRequest setPredicate:predicate];
    
    
    // Sort using the page property.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    self->_tasksFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return self->_tasksFetchedResultsController;
}


-(NSFetchedResultsController*)stepsFetchedResultsControllerForTask:(Task*)task
{
    if (self->_stepsFetchedResultsController)
    {
        return self->_stepsFetchedResultsController;
    }
    //Create the fetchRequest for a specific entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Step"];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"active == 1"];
    //[fetchRequest setPredicate:predicate];
    
    
    // Sort using the page property.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    self->_stepsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return self->_stepsFetchedResultsController;
}

-(NSFetchedResultsController*)activeStepsFetchedResultsControllerForTask:(Task*)task
{
    if (self->_activeStepsFetchedResultsController)
    {
        return self->_activeStepsFetchedResultsController;
    }
    //Create the fetchRequest for a specific entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Step"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"active == 1"];
    [fetchRequest setPredicate:predicate];
    
    
    // Sort using the page property.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    self->_activeStepsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return self->_activeStepsFetchedResultsController;
}



-(Task*)createTask {
    if( [self allowNewTaskCreation] ) {
        Task* newTask = [Task createTaskInMOC:self.managedObjectContext forUser:self.currentUser];
        [self saveContext];
        return newTask;
    } else {
        return nil;
    }
}


-(MediaStep*)createMediaStepInTask:(Task*)task{
    MediaStep* newMediaStep = [MediaStep createMediaStepInMOC:self.managedObjectContext];
    
    newMediaStep.task = task;
    
    [self saveContext];
    return newMediaStep;
}

-(RoutingStep*)createRoutingStepInTask:(Task*)task{
    
    RoutingStep* newRoutingStep = [RoutingStep createRoutingStepInMOC:self.managedObjectContext];
    newRoutingStep.task = task;
    
    [self saveContext];
    
    return newRoutingStep; //Not Yet Implemented
}

-(Task*)createTaskInRoutingStep:(RoutingStep*)routingStep {
    Task* newTask = [routingStep createTaskInMOC:self.managedObjectContext];
    [self saveContext];
    return newTask;
}

-(Media*)createMedia:(NSData*)data ofType:(enum MediaType)mediaType{
    
    Media *newMedia = [Media createMediaOfType:mediaType withData:data inMOC:self.managedObjectContext];
    
    newMedia.type = [NSNumber numberWithInt:mediaType];
    newMedia.data = data;
    
    return newMedia;
}

-(EventTask*)createEventTaskFromPlannedEvent:(PlannedEvent*)plannedEvent{
    EventTask *newEventTask = [NSEntityDescription insertNewObjectForEntityForName:@"EventTask" inManagedObjectContext:self.managedObjectContext];
    
    newEventTask.task = (Task*)plannedEvent.scheduledEvent.schedulable;
    newEventTask.plannedDate = plannedEvent.date;
    
    newEventTask.scheduledEvent = plannedEvent.scheduledEvent;
    newEventTask.calendar = self.currentUser.calendar;
    
    [self saveContext];
    
    return newEventTask;
}

-(Task*)duplicateTask:(Task*)task{
    
    Task *newTask = [task copy];

    //Updating Task Name with "Copy of..."
    NSMutableString *newString = [NSMutableString stringWithString:NSLocalizedString(@"CopyOfKey", @"")];
    [newString appendString:task.title];
    newTask.name = newString;
    

    [self saveContext];
    return newTask;
}

-(MediaStep*)duplicateMediaStep:(MediaStep*)mediaStep{
    
    MediaStep *newMediaStep = [mediaStep copy];
    
    newMediaStep.task = mediaStep.task;
    
    //Updating Task Name with "Copy of..."
    NSMutableString *newString = [NSMutableString stringWithString:NSLocalizedString(@"CopyOfKey", @"")];
    [newString appendString:newMediaStep.title];
    newMediaStep.name = newString;
    
    
    [self saveContext];
    return newMediaStep;
}

-(RoutingStep*)duplicateRoutingStep:(RoutingStep*)routingStep{
    
    RoutingStep *newRoutingStep = [routingStep copy];
    
    newRoutingStep.task = routingStep.task;
    
    //Updating Task Name with "Copy of..."
    NSMutableString *newString = [NSMutableString stringWithString:NSLocalizedString(@"CopyOfKey", @"")];
    [newString appendString:newRoutingStep.title];
    newRoutingStep.name = newString;
    
    
    [self saveContext];
    return newRoutingStep;
}

-(void)deleteManagedObject:(NSManagedObject*)managedObject {
    [managedObject.managedObjectContext deleteObject:managedObject];
    [self saveContext];
}

-(void) deleteAllObjects: (NSString *)entityName  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    for (NSManagedObject *managedObject in items) {
    	[self.managedObjectContext deleteObject:managedObject];
    	NSLog(@"%@ object deleted",entityName);
    }
    if (![self.managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityName,error);
    }
    
}

- (BOOL)allowNewTaskCreation
{
    
#ifdef FULL_VERSION
    
    //NSLog(@"%i AdminFakeManagedTasks", [[self adminTasks] count]);
    
    [[self.tasksFetchedResultsController fetchedObjects] count];
    
    if ([[self.tasksFetchedResultsController fetchedObjects] count] < NB_MAX_TASKS_IN_MARTI1) {
        return YES;
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alertTitle_MaxNumberOfTasks", @"")
                                    message:NSLocalizedString(@"alertDescription_MaxNumberOfTasks", @"")
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"cancelButtonKey", @"") otherButtonTitles:nil, nil] show];
        return NO;
    }
#endif
    
#ifdef FREEMIUM_VERSION
    
    //NSLog(@"%i AdminFakeManagedTasks", [[self adminTasks] count]);
    
    if ([[self.tasksFetchedResultsController fetchedObjects] count] < NB_MAX_TASKS_IN_MARTI_FREEMIUM) {
        return YES;
    } else
    {
        [UIAlertView alertViewWithTitle:NSLocalizedString(@"alertTitle_MaxNumberOfTasks", nil)
                                message:NSLocalizedString(@"alertDescription_MaxNumberOfTasksLite", nil)
                      cancelButtonTitle:NSLocalizedString(@"buyMarti_cancelButtonKey", nil)
                      otherButtonTitles:[NSArray arrayWithObjects:NSLocalizedString(@"alertChoice_Buy", nil), nil]
                              onDismiss:^(int buttonIndex)
         {
             NSString *str = @"itms-apps://itunes.apple.com/ca/app/marti/id489615229?ls=1&mt=8";
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
             
         }
         
                               onCancel:^()
         {
             //Do Nothing!
         }
         ];
        return NO;
    }
#endif
    
}


#pragma mark - Core Data Stack (Dynamic)

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"martiPro" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"userPro.marti"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// save all contexts
- (void)saveContext
{
    NSError *error = nil;
    
    // only need to save dynamic db cause static is read-only!
    if (self.managedObjectContext != nil)
    {
        if ([self.managedObjectContext hasChanges]){
            
             NSLog(@"CoreData changed SAVED !");
            
            if( ![self.managedObjectContext save:&error])
            {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }[[MartiCDManager sharedInstance] saveContext];
        } else {
            NSLog(@"No changes to save");
        }
    }
}




@end
