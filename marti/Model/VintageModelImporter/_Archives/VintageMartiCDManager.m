//
//  CDManager.m
//  MartiPro
//
//  Created by Marco Guilmette on 12/18/2013.
//  Copyright (c) 2013 Infologique. All rights reserved.
//

#import "VintageMartiCDManager.h"



@interface VintageMartiCDManager()

// we don't need(want) to expose that
// static
//@property (readonly, strong, nonatomic) NSManagedObjectContext *staticDataManagedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *staticDataManagedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *staticDataPersistentStoreCoordinator;

// dynamic


@end



@implementation VintageMartiCDManager
{
    NSFetchedResultsController* _taskFetchedResultsController;
    //NSFetchedResultsController* _cardFetchedResultsController;
    //NSFetchedResultsController* _distorsionsSelectionFetchedResultsController;
    //NSFetchedResultsController* _sessionsFetchedResultsController;
    //NSFetchedResultsController* _currentSessionCardInfosFetchedResultsController;
    
    //NSArray* _localizedThemes;
    
    //NSArray* _availableLocales;
}

//@synthesize staticDataManagedObjectContext = _staticDataManagedObjectContext;
//@synthesize staticDataManagedObjectModel = _staticDataManagedObjectModel;
//@synthesize staticDataPersistentStoreCoordinator = _staticDataPersistentStoreCoordinator;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


-(NSFetchedResultsController*)taskFetchedResultsController
{
    if (self->_taskFetchedResultsController)
    {
        return self->_taskFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ILtask" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"session = %@",self.currentSession];
    //[fetchRequest setPredicate:predicate];
    
    // Sort using the page property
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"task_description" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor ]];
    
    // Use the sectionIdentifier property to group into sections.
    self->_taskFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return self->_taskFetchedResultsController;
}


#pragma mark - Singleton
// return a singleton of the filterCD manager
+ (VintageMartiCDManager*)sharedManager
{
    static VintageMartiCDManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initOnce];
    });
    return sharedManager;
}

- (id)init
{
    NSLog(@"Use sharedRealityFilterCDManager to get a copy of this singleton!");
    return nil;
}

- (id)initOnce
{
    if (self = [super init])
    {
    }
    return self;
}


#pragma mark - Core Data stack dynamic


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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"marti" withExtension:@"momd"];
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
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"user.marti"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
