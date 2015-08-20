//
//  ILmartiStore.m
//  marti
//
//  Created by Paul Legault Local on 11-12-08.
//  Copyright (c) 2011 Infologique Innovation inc. All rights reserved.
//

//////////////////////////////////////////////////
//                                              //
//          STARTUP CALLING ORDER               //
//                                              //
// createHelpDatabaseIfRequired                 //
// createNewMartiDatabaseOnlyIfNotExisting      //
// createNewMartiDatabaseFromRes     (optional) //
// createNewMartiDatabaseFromScratch (optional) //
// detectAllMartiDataBase                       //
// getAdminFakeManagedTasksSet                  //
// constructAdminFakeTasksList                  //
// constructUserFakeTasksList                   //
// saveDataContext (save if new FakeOrder)      //
// getNumberOfAdminFakeManagedTasks             //
//                                              //
//////////////////////////////////////////////////

//#import "AppDelegate.h"
#import "ILstepImage.h"
#import "ILstepAudio.h"
#import "ILstepVideo.h"
#import "ILstep.h"
#import "ILtaskImage.h"
#import "ILtaskAudio.h"
#import "ILtask.h"
#import "ILtasksList.h"
#import "ILgroup.h"
#import "ILcoreDataStackContext.h"
//#import "UIAlertView+MKBlockAdditions.h"

#include <sys/xattr.h>

@implementation MartiStoreManager

// CORE DATA STACKS
@synthesize managedStacks;
@synthesize adminFakeManagedTasks;
@synthesize userFakeManagedTasks;
@synthesize helpLanguage;




+ (MartiStoreManager*)defaultStore
{
    static MartiStoreManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MartiStoreManager alloc] init];
        // TODO : Init the default store HERE
    });
    return sharedInstance;
}

#pragma mark - STORES HANDLING




//Loop throught all files in Document folder and for each ".marti" look if a valid Group is available.
//If so, we add this store (SQLite) into the store stack
- (void)detectAllMartiDataBase
{
    
    NSError *error = nil;
    self.managedStacks = [[NSMutableOrderedSet alloc] init];
    
    
    NSArray *urls = [[NSFileManager defaultManager]
                           contentsOfDirectoryAtURL:[metrics applicationDocumentsDirectory]
                           includingPropertiesForKeys:nil
                           options:(NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsHiddenFiles)
                           error:&error];
    
    for( NSURL* url in urls ) {
        if ( [url isFileURL] )
            if ([[url pathExtension] isEqualToString:@"marti"]){
                NSLog(@"%@", [url absoluteString]);
                
                MartiCoreDataStackContext *cdStack = [[MartiCoreDataStackContext alloc] initWithStoreURL:url];
                if (cdStack.isValid)
                {
                    
                    // Execute the fetch request to collect all the groups
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ILgroup"];
                    NSArray* fetchedObjects = [cdStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                    

                    //At least a group has been found
                    if (fetchedObjects)
                    {
                        for (ILgroup* group in fetchedObjects ) {
                            NSLog(@"Groupe :%@ dans %@", group.group_name, [url path]);
                            [cdStack.managedGroups addObject:group];
                        }
                        
                    }
                    
                    //If there is at lest a group in SQLite database, we will add the store in the stack (array).
                    if (cdStack.managedGroups.count > 0)
                    {
                        [self.managedStacks addObject:cdStack];
                    }
                    
                    
                }
            }  
    }

}



-(void)addMartiDatabaseFromName:(NSString *)dbname
{
    NSURL *url=[[metrics applicationDocumentsDirectory] URLByAppendingPathComponent:dbname];
    NSError *error = nil;
    //NSLog(@"on store Handler 0 :%@", url);
    
    MartiCoreDataStackContext *cdStack = [[MartiCoreDataStackContext alloc] initWithStoreURL:url];
    if (cdStack.isValid)
    {
        // NSLog(@"on store Handler 1 :%@", url);
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ILgroup" inManagedObjectContext:cdStack.managedObjectContext];
        [fetchRequest setEntity:entityDesc];
        
        // NSLog(@"on store Handler 2:%@", url);
        
        
        // Execute the fetch request to collect all the groups
        NSArray* fetchedObjects = [cdStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        //  NSLog(@"on store Handler 3:%@", url);
        
        if (fetchedObjects)
        {
            for (NSUInteger index = 0; index < fetchedObjects.count; index++)
            {
                //  NSLog(@"Object :%@", [fetchedObjects objectAtIndex:index]);
                
                [cdStack.managedGroups addObject:[fetchedObjects objectAtIndex:index]];
            }
        }
        if (cdStack.managedGroups.count > 0)
        { // NSLog(@"Mange group count :%i", cdStack.managedGroups.count);
            [self.managedStacks addObject:cdStack];
        }
        
    }
    
    
}

// Return the ILcoreDataStackContext of user.marti
// In theory, the user.marti context exist and should always exist
// However things being what they are, they might be a stormy season
// when no such context exist (bad user or bad system or bad bug!)
// Then if it doesn't exist, there is ONE attempt to create one.
//
- (MartiCoreDataStackContext *)getDefaultMartiStoreContext
{
    MartiCoreDataStackContext *cdStack = [self getMartiStoreContext:[metrics martiUserDatabaseURL]];
    if (!cdStack) // safety valve (not full proof)
    {
        NSLog(@"YOU SHOULD NOT PASS HERE. defaultMartiStore is missing %@", self.managedStacks);
        if ([self createNewMartiDatabaseOnlyIfNotExisting])
        {
            [self detectAllMartiDataBase];
            [self resetAdminFakeManagedTasksSet];
            cdStack = [self getMartiStoreContext:[metrics martiUserDatabaseURL]];
        }
    }
    return cdStack;
}


- (MartiCoreDataStackContext *)getHelpMartiStoreContext
{
    return [self getMartiStoreContext:[metrics applicationDocumentsDirectoryHelpStoreURL:helpLanguage]];
}


//Return a Marti Store Context object (ILcoreDataStackContext) user a specific URL
- (MartiCoreDataStackContext *)getMartiStoreContext:(NSURL *)storeURL
{
    for (MartiCoreDataStackContext *thisContext in self.managedStacks ) {
        if ([[storeURL lastPathComponent] isEqualToString:[[thisContext storeURL] lastPathComponent]])
        {
            return thisContext;
        }
    }
    
    return NULL;

}


//
// Check if the help store exist
// if not in application document directory -> use one in application resources from supported language
// Web service update TODO
//
- (BOOL)createHelpDatabaseIfRequired
{
    // helpLanguage contains only HELP supported languages strings (see MARTI_SUPPORTED_LANGUAGES)
    //
    self.helpLanguage = ([metrics isLocalLanguageSupported] ? [[NSLocale preferredLanguages] objectAtIndex:0] : @"en");
    
    // Test if the database exists in the documents directory
    
    NSURL *helpURL = [metrics applicationDocumentsDirectoryHelpStoreURL:helpLanguage];
    
    
    ////////////////////
    //Patch for Difference between name from 1.0 and older.. we remove old help to avoid problems of duplication
    NSURL *oldHelpURL = [metrics applicationDocumentsDirectory_old_HelpStoreURL];
    BOOL olddbExist = [[NSFileManager defaultManager] fileExistsAtPath:[oldHelpURL path]];
    if(olddbExist)
    {
        [[NSFileManager defaultManager] removeItemAtURL:oldHelpURL error:nil];
    }
    
    ////////////////////
    
    
    BOOL dbExist = [[NSFileManager defaultManager] fileExistsAtPath:[helpURL path]];
    if (!dbExist)
    {
        NSURL *resDBpath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:MARTI_DB_HELP_FORMAT_NAME, self.helpLanguage]
                                                   withExtension:nil];
        if (resDBpath)
        {
            dbExist = [[NSFileManager defaultManager] copyItemAtURL:resDBpath toURL:helpURL error:nil];
        }
    }
    //Set "do not backup" attribute
    [self addSkipBackupAttributeToItemAtURL:helpURL];
    
    return dbExist;

}

//
// Check if the store exist
// if not in app document directory -> use the one in application resources
// if not in resource -> create a minimal package
- (BOOL)createNewMartiDatabaseOnlyIfNotExisting
{
    
    // Test if the database exists in the documents directory
    NSURL *storeURL = [metrics martiUserDatabaseURL];
    BOOL dbExist = [[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]];
    
    
    if (!dbExist)
    {
        dbExist = [self createNewMartiDatabaseFromRes];
    }
    if (!dbExist)
    {
        
        dbExist = [self createNewMartiDatabaseFromScratch];
    }
    
    
    //Set "do not backup" attribute (reason of rejection by Apple)
    [self addSkipBackupAttributeToItemAtURL:storeURL];
    
    return dbExist;
}

//  Try to locate a resource to use as store
//  if exist ->  copy the provided DB in resources upon installation
//
- (BOOL)createNewMartiDatabaseFromRes
{
    NSURL *resDBpath = [[NSBundle mainBundle] URLForResource:MARTI_DB_DOC_NAME withExtension:nil];
    if (!resDBpath)
        return NO;
    NSURL *storeURL = [metrics martiUserDatabaseURL];
    
    bool ok=[[NSFileManager defaultManager] copyItemAtURL:resDBpath toURL:storeURL error:nil];
    //Set "do not backup" attribute
    [self addSkipBackupAttributeToItemAtURL:storeURL];
    
    return ok;
}

// Create dynamically a new Store upon installation
//
- (BOOL)createNewMartiDatabaseFromScratch
{
    
    
    NSURL *storeURL = [metrics martiUserDatabaseURL];

    
    MartiCoreDataStackContext *cdStack = [[MartiCoreDataStackContext alloc] initWithStoreURL:storeURL];

    
    // Create one root empty tasksList in one group
    if ([[ILgroup alloc] initEmptyGroup:MARTI_GENERAL_GROUP_NAME inMOC:cdStack.managedObjectContext])
    { //NSLog(@"2.3");
        NSError *error = nil;
        if ([cdStack.managedObjectContext save:&error])
        {
            [self addSkipBackupAttributeToItemAtURL:storeURL];
            //NSLog(@"New Default Store saved : %@", [storeURL lastPathComponent]);
            return YES;
        }
        else
        { [self addSkipBackupAttributeToItemAtURL:storeURL];
            //  NSLog(@"New Default NOT saved! \nUnresolved error %@, \n%@, \n%@", storeURL, error, [error userInfo]);
            return NO;
        }
    }
    //NSLog(@"2.6");
    //     DUMP_GROUP(generalGroup);
    
    //Set "do not backup" attribute
    [self addSkipBackupAttributeToItemAtURL:storeURL];
    return NO;
}

//Required by Apple, ensure that files won't be backup on icloud (do not backup attribute)
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

/*- (BOOL) isFullVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"ILFullVersion"] boolValue];
}

- (BOOL) isFremiumVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"ILFremiumVersion"] boolValue];
}*/

/*- (NSUInteger)getNumberOfTasksAllowed
{
#ifdef FULL_VERSION
    return NB_MAX_TASKS_IN_MARTI1;
#else
    return NB_MAX_TASKS_IN_MARTI_FREMIUM;;
#endif
}*/

/*- (BOOL)isMaximumTasksReached
{
    return ([self getNumberOfAdminFakeManagedTasks] >= ([self isFullVersion] ? NB_MAX_TASKS_IN_MARTI1 : NB_MAX_TASKS_IN_MARTI_FREMIUM));
}*/

- (BOOL)canCreateNewTask
{
    
#ifdef FULL_VERSION
    
    NSLog(@"%i AdminFakeManagedTasks", [[self adminTasks] count]);
    
    if ([[self adminTasks] count] < NB_MAX_TASKS_IN_MARTI1) {
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
    
    NSLog(@"%i AdminFakeManagedTasks", [[self adminTasks] count]);
    
    if ([[self adminTasks] count] < NB_MAX_TASKS_IN_MARTI_FREEMIUM) {
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


- (BOOL)canCreateNewStepInTask:(NSUInteger)nbSteps
{
    
    if (nbSteps < NB_MAX_STEPS_PER_TASK_IN_MARTI1)
    {
        return YES;
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alertTitle_MaxNumberOfStepsInTask", @"")
                                    message:NSLocalizedString(@"alertDescription_MaxNumberOfStepsInTask", @"")
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"cancelButtonKey", @"") otherButtonTitles:nil, nil] show];
        
        return NO;
    }
    

}

//Creating a new Root Task
//Returns NO if limit reached or error occured
- (BOOL)createRootTaskWithSimpleStep
{
    if ( [self canCreateNewTask] )
    {
        MartiCoreDataStackContext *context = [self getDefaultMartiStoreContext];
        if (!context)
        {
            return NO;
        }
        ILgroup *group = [context getFirstGroup];
        if (!group)
        {
            return NO;
        }
        ILtask* dstTask = [ILtask createTaskWithSimpleStep:NO InMOC:group.managedObjectContext];
        if (dstTask)
        {
            [[group getTasksList] addTaskAtTheEndOfTasksList:dstTask];
            [adminFakeManagedTasks addObject:[group getLastTask]];
            [self reOrderAdminFakeTasksListFromIndex:(adminFakeManagedTasks.count - 1)];
        }
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)duplicateMainTask:(ILtask*)srcTask atIndex:(NSUInteger)index
{
    if ( [self canCreateNewTask] )
    {
        MartiCoreDataStackContext *dstContext = [self getDefaultMartiStoreContext];
        if (!dstContext)
        {
            return NO;
        }
        ILgroup *group = [dstContext getFirstGroup];
        if (!group)
        {
            return NO;
        }
        ILtask* dstTask = [ILtask copyOfTask:srcTask inMOC:group.managedObjectContext];
        if (dstTask)
        {
            [dstTask addCopyToTitle];
            [[group getTasksList] addTaskAtTheEndOfTasksList:dstTask];
            [adminFakeManagedTasks insertObject:dstTask atIndex:index];
            [self reOrderAdminFakeTasksListFromIndex:index];
            return YES;
        }
    }
    return NO;
}




//dispatch_async(dispatch_get_main_queue(), ^{
//    [martiStore saveDataContext]; // LATER OPTIMIZE
//    [martiStore resetUserFakeManagedTasksSet];
//    [self refreshTasks];
//});

- (BOOL)saveDataContext
{
    NSError *error = nil;
    BOOL wasSave = NO;
    for (NSUInteger index = 0; index < self.managedStacks.count; index++)
    {
        NSManagedObjectContext *moc = [[self.managedStacks objectAtIndex:index] managedObjectContext];
        // NSPersistentStoreCoordinator *psc = [[self.managedStacks objectAtIndex:index] storeCoordinator];
        if (moc &&  [moc hasChanges])
        {
            wasSave = YES;
            if ([moc save:&error])
            {
                 NSLog(@"%@ saved", [[self.managedStacks objectAtIndex:index] storeURL]);
                // LOOK_OPTIONS(psc);
                // LOOK_INSIDE(moc);
            }
            else
            {
                // NSLog(@"%@ NOT saved! \nUnresolved error %@, %@", [[self.managedStacks objectAtIndex:index] storeURL], error, [error userInfo]);
            }
        }
    }
    return wasSave;
}

#pragma mark - FAKE MANAGED TASK LIST


/*- (NSUInteger)getNumberOfAdminFakeManagedTasks
{
    return [[self getAdminFakeManagedTasksSet] count];
}*/

/*- (NSUInteger)getNumberOfUserFakeManagedTasks
{
    return [[self getUserFakeManagedTasksSet] count];
}*/

- (void)resetAdminFakeManagedTasksSet
{
    adminFakeManagedTasks = nil;
    userFakeManagedTasks = nil;
}

- (NSMutableOrderedSet *)adminTasks
{
    if (!adminFakeManagedTasks)
    {
        [self constructAdminFakeTasksList];
        //[martiStore saveDataContext];
    }
    return adminFakeManagedTasks;
}

- (void)resetUserFakeManagedTasksSet
{
    userFakeManagedTasks = nil;
}

- (NSMutableOrderedSet *)userTasks
{
    //if (!userFakeManagedTasks)
    //{
        [self constructUserFakeTasksList];
    //}
    return userFakeManagedTasks;
}

- (NSMutableOrderedSet *)getActiveTasks
{
    if (!userFakeManagedTasks)
    {
        [self constructUserFakeTasksList];
    }
    return userFakeManagedTasks;
}


-(NSMutableOrderedSet*)receivedTasks
{
    NSMutableOrderedSet* tasks = [NSMutableOrderedSet orderedSet];
    
    //MartiCoreDataStackContext *context = [[MartiCoreDataStackContext alloc] initWithStoreURL:[metrics martiFlashShareSessionTempDatabaseURL]];
    MartiCoreDataStackContext *context = [[MartiCoreDataStackContext alloc] initWithStoreURL:[metrics martiFlashShareSessionTempDatabaseURL]];
    
    if (context.isValid)
    {
        // NSLog(@"stores :%@", [storesURLS objectAtIndex:index]);
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ILgroup" inManagedObjectContext:context.managedObjectContext];
        [fetchRequest setEntity:entityDesc];
        
        // Execute the fetch request to collect all the groups
        NSArray* fetchedObjects = [context.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        //  NSLog(@"Objects :%i", fetchedObjects.count);
        
        if (fetchedObjects)
        {
            for (NSUInteger index = 0; index < fetchedObjects.count; index++)
            {
                //  NSLog(@"Object :%@", [fetchedObjects objectAtIndex:index]);
                
                [context.managedGroups addObject:[fetchedObjects objectAtIndex:index]];
            }
        }
        if (context.managedGroups.count > 0)
        { // NSLog(@"Mange group count :%i", cdStack.managedGroups.count);
            [self.managedStacks addObject:context];
        }
        
    }
    
    
    NSArray *groups = [context managedGroups];
    
    //NSLog(@"InitTasks = %i", [context count]);
    
    for (NSUInteger i = 0; i < groups.count; i++) //Lopp throught ALL group on this database
    {
        ILgroup *group = [groups objectAtIndex:i];
        
        // release code (keep only valid task according to language context)
        //
        //if ([self isGroupValidInThisLanguageContext:group])
        //{
        // scanning the tasksList
        ILtasksList *tasksList = [group getTasksList];
        for (NSUInteger j = 0; j < [tasksList getNumberOfTasks]; j++)
        {
            ILtask *task = [tasksList getTaskAtIndex:j];
            if ([self isTaskValidInThisLanguageContext:task])
            {
                if ([task isFakeIndexed])
                {
                    [tasks addObject:task];
                    //[indexedTasks addObject:task];
                }
                else
                {
                    [tasks addObject:task];
                    //[notIndexedTasks addObject:task];
                }
            }
        }
        //}
    }
    //NSLog(@"ReceivedTasks = %i", [tasks count]);
    return tasks;
}



-(NSMutableOrderedSet*)availableTasksForShare
{
    NSMutableOrderedSet* tasks = [NSMutableOrderedSet orderedSet];
    
    MartiCoreDataStackContext *context = [[MartiCoreDataStackContext alloc] initWithStoreURL:[metrics martiUserDatabaseURL]];
    
    if (context.isValid)
    {

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ILgroup" inManagedObjectContext:context.managedObjectContext];
        [fetchRequest setEntity:entityDesc];
        
        // Execute the fetch request to collect all the groups
        NSArray* fetchedObjects = [context.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        if (fetchedObjects)
        {
            for (NSUInteger index = 0; index < fetchedObjects.count; index++)
            {
                //  NSLog(@"Object :%@", [fetchedObjects objectAtIndex:index]);
                
                [context.managedGroups addObject:[fetchedObjects objectAtIndex:index]];
            }
        }
        if (context.managedGroups.count > 0)
        { // NSLog(@"Mange group count :%i", cdStack.managedGroups.count);
            [self.managedStacks addObject:context];
        }
        
    }

    
    NSArray *groups = [context managedGroups];
    
    //NSLog(@"InitTasks = %i", [context count]);
    
    for (NSUInteger i = 0; i < groups.count; i++) //Lopp throught ALL group on this database
    {
        ILgroup *group = [groups objectAtIndex:i];
    
    // release code (keep only valid task according to language context)
    //
        //if ([self isGroupValidInThisLanguageContext:group])
        //{
            // scanning the tasksList
            ILtasksList *tasksList = [group getTasksList];
            for (NSUInteger j = 0; j < [tasksList getNumberOfTasks]; j++)
            {
                ILtask *thisTask = [tasksList getTaskAtIndex:j];
                if (![thisTask isWriteProtected])
                {
                    [tasks addObject:thisTask];
                }
            }
        //}
    }
    NSLog(@"ReceivedTasks = %i", [tasks count]);
    return tasks;
}

- (void)constructUserFakeTasksList
{
    // 1- reset the set
    //
    userFakeManagedTasks = [NSMutableOrderedSet orderedSet];
    
    // 2- scan the adminFakeManagedTasksSet keeping only active tasks
    //
    NSMutableOrderedSet *adminFakeManagedTasksSet = [self adminTasks];
    for (NSUInteger ii = 0; ii < adminFakeManagedTasksSet.count; ii++)
    {
        ILtask *task = [adminFakeManagedTasksSet objectAtIndex:ii];
        if ([task isActive])
        {
            [userFakeManagedTasks addObject:task];
        }
    }
    
    // 3- if no task -> add help task
    //    if help present -> put it at the beginning
    //
    MartiCoreDataStackContext *helpStoreContext = [self getHelpMartiStoreContext];
    ILgroup *helpGroup = [helpStoreContext.managedGroups objectAtIndex:0];
    ILtask *helpTask = [[helpGroup getTasksList] getTaskAtIndex:0];
    if (helpTask) // safety valve
    {
        if (userFakeManagedTasks.count == 0)
        {
            [userFakeManagedTasks addObject:helpTask];
        }
        else if ([userFakeManagedTasks containsObject:helpTask])
        {
            NSInteger index = [userFakeManagedTasks indexOfObject:helpTask];
            if ((index != 0) && (index != NSNotFound))
                
            {
                [userFakeManagedTasks removeObjectAtIndex:index];
                [userFakeManagedTasks insertObject:helpTask atIndex:0];
            }
        }
    }
}

// LATER active checks
- (void)constructAdminFakeTasksList
{
    // 1- reset the sets
    //
    NSMutableOrderedSet *indexedTasks = [NSMutableOrderedSet orderedSet];
    NSMutableOrderedSet *notIndexedTasks = [NSMutableOrderedSet orderedSet];
    adminFakeManagedTasks = [NSMutableOrderedSet orderedSet];
    
    // 2- scan the core stacks to collect indexedTasks and notIndexedTasks
    // for valid tasks according to language (see isLanguageValid for criteria)
    //
    for (NSUInteger ii = 0; ii < self.managedStacks.count; ii++)
    {
        MartiCoreDataStackContext *cDstack = [self.managedStacks objectAtIndex:ii];
        // scanning the groups
        NSArray *groups = [cDstack managedGroups];
        for (NSUInteger jj = 0; jj < groups.count; jj++)
        {
            ILgroup *group = [groups objectAtIndex:jj];
            
            // scanning the tasksList
            //
            
#ifdef SUPER_MARTI_KEEP_ALL_TASKS
            
            // debug version only
            //
            ILtasksList *tasksList = [group getTasksList];
            for (NSUInteger kk = 0; kk < [tasksList getNumberOfTasks]; kk++)
            {
                ILtask *task = [tasksList getTaskAtIndex:kk];
                if ([task isFakeIndexed])
                {
                    [indexedTasks addObject:task];
                }
                else
                {
                    [notIndexedTasks addObject:task];
                }
            }
            
#else       // release code (keep only valid task according to language context)
            //
            if ([self isGroupValidInThisLanguageContext:group])
            {
                // scanning the tasksList
                ILtasksList *tasksList = [group getTasksList];
                for (NSUInteger kk = 0; kk < [tasksList getNumberOfTasks]; kk++)
                {
                    ILtask *task = [tasksList getTaskAtIndex:kk];
                    if ([self isTaskValidInThisLanguageContext:task])
                    {
                        if ([task isFakeIndexed])
                        {
                            [indexedTasks addObject:task];
                        }
                        else
                        {
                            [notIndexedTasks addObject:task];
                        }
                    }
                }
            }
            
#endif
            
        }
    }
    
    // 3- scan the indexedTasks to keep same old order
    //
    while(indexedTasks.count > 0)
    {
        ILtask *task = [indexedTasks objectAtIndex:0];
        NSInteger bestIndexIndex = 0;
        NSInteger bestIndex = [task getFakeIndex];
        for (NSUInteger ii = 1; ii < indexedTasks.count; ii++)
        {
            task = [indexedTasks objectAtIndex:ii];
            if ([task getFakeIndex] < bestIndex)
            {
                bestIndexIndex = ii;
                bestIndex = [task getFakeIndex];
            }
        }
        task = [indexedTasks objectAtIndex:bestIndexIndex];
        [task setFakeIndex:adminFakeManagedTasks.count];
        [adminFakeManagedTasks addObject:task];
        [indexedTasks removeObjectAtIndex:bestIndexIndex];
    }
    
    // 4- append notIndexedTasks
    //
    for (NSUInteger ii = 1; ii < notIndexedTasks.count; ii++)
    {
        ILtask *task = [notIndexedTasks objectAtIndex:ii];
        [task setFakeIndex:adminFakeManagedTasks.count];
        [adminFakeManagedTasks addObject:task];
    }
}

- (BOOL)isGroupValidInThisLanguageContext:(ILgroup *)group
{
    return [self isLanguageValid:[group getLanguage]];
}

- (BOOL)isTaskValidInThisLanguageContext:(ILtask *)task
{
    return [self isLanguageValid:[task getLanguage]];
}

- (BOOL)isLanguageValid:(NSString *)EntityLanguage
{
    // if entity is not language signed, then entity is valid
    //
    if (!EntityLanguage)
        return YES;
    
    // if entity is same language as local language, then entity is valid
    //
    if ([metrics isEqualToLocalLanguage:EntityLanguage])
        return YES;
    
    // if entity is not english, then entity is NOT valid
    //
    if (![metrics isEnglish:EntityLanguage])
        return NO;
    
    // Entity is english
    // if local language is not supported, then entity is valid
    //
    return (![metrics isLocalLanguageSupported]);
}

- (void)reOrderAdminFakeTasksListFromIndex:(NSUInteger)index1 orIndex:(NSUInteger)index2
{
    [self reOrderAdminFakeTasksListFromIndex:((index1 > index2) ? index2 : index1)];
}

- (void)reOrderAdminFakeTasksListFromIndex:(NSUInteger)index
{
    for (NSUInteger ii = index; ii < adminFakeManagedTasks.count; ii++)
    {
        ILtask *task = [adminFakeManagedTasks objectAtIndex:ii];
        [task setFakeIndex:ii];
    }
}

/////////////////////////////////
//
#pragma mark - DEBUGGING TOOLS
//
/////////////////////////////////

#ifdef SUPER_MARTI_DEBUG

void LOOK_OPTIONS(NSPersistentStoreCoordinator *psc)
{
    NSLog(@"\n*** LOOK_OPTIONS ***\n");
    NSArray *arrayPs = [psc persistentStores];
    if (arrayPs.count > 0)
    {
        NSPersistentStore *ps = [arrayPs objectAtIndex:0];
        NSLog(@"Options of %@ are : %@\n", [ps URL], [ps options]);
    }
}

void LOOK_INSIDE(NSManagedObjectContext *moc)
{
    NSLog(@"\n*** LOOK_INSIDE ***\n");
    NSError *error = nil;
    NSArray* fetchedObjects;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILgroup" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILgroup(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILtasksList" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILtaslksList(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILtask" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILtask(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILstep" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILstep(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILtaskThumbnail" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILtaskThumbnail(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILstepThumbnail" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILstepThumbnail(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILtasksListAudio" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILtasksListAudio(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILtaskAudio" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILtaskAudio(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILstepAudio" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILstepAudio(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILtaskAudioShort" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILtaskAudioShort(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILstepAudioShort" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILstepAudioShort(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILtaskImage" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILtaskImage(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILstepImage" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILstepImage(s)\n %@", fetchedObjects);
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILstepVideo" inManagedObjectContext:moc]];
    fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    NSLog(@"\n\nILstepVideo(s)\n %@", fetchedObjects);
    
}


void DUMP_GROUP(ILgroup *group) // LATER EXPAND
{
    NSLog(@"\n\nDUMP_GROUP\n ILgroup %@", group);
    if (group.tasksList)
    {
        DUMP_TASKSLIST(group.tasksList);
    }
}

void DUMP_TASKSLIST(ILtasksList *tasksList) // LATER EXPAND
{
    NSLog(@"\n\nDUMP_TASKLIST\n ILTaskList %@", tasksList);
    NSOrderedSet *oset = tasksList.tasks;
    if (oset)
    {
        NSLog(@"[set count] : %d", [oset count]);
        for (NSUInteger i=0; i < [oset count]; i++)
        {
            DUMP_TASK([oset objectAtIndex:i]);
        }
    }
}

void DUMP_TASK(ILtask *task) // LATER EXPAND
{
    NSLog(@"\n\nDUMP_TASK\n ILTask %@", task);
    if (task.task_audio)
    {
        DUMP_TASKAUDIO(task.task_audio);
    }
    if (task.task_image)
    {
        DUMP_TASKIMAGE(task.task_image);
    }
    NSOrderedSet *set = task.steps;
    NSLog(@"set : %@", set);
    if (set)
    {
        for (NSUInteger i=0; i < [set count]; i++)
        {
            DUMP_STEP([set objectAtIndex:i]);
        }
    }
}

void DUMP_STEP(ILstep *step) // LATER EXPAND
{
    NSLog(@"\n\nDUMP_STEP\n ILStep %@", step);
    if (step.step_audio)
    {
        DUMP_STEPAUDIO(step.step_audio);
    }
    if (step.step_image)
    {
        DUMP_STEPIMAGE(step.step_image);
    }
    if (step.step_video)
    {
        DUMP_STEPVIDEO(step.step_video);
    }
    if (step.subTasks)
    {
        DUMP_TASKSLIST(step.subTasks);
    }
}

void DUMP_TASKAUDIO(ILtaskAudio *taskAudio)
{
    NSLog(@"\n\nDUMP_TASKAUDIO\n ILtaskAudio %@", taskAudio);
}

void DUMP_TASKIMAGE(ILtaskImage *taskImage)
{
    NSLog(@"\n\nDUMP_TASKIMAGE\n ILtaskImage %@", taskImage);
}

void DUMP_STEPAUDIO(ILstepAudio *stepAudio)
{
    NSLog(@"\n\nDUMP_STEPAUDIO\n ILstepAudio %@", stepAudio);
}

void DUMP_STEPIMAGE(ILstepImage *stepImage)
{
    NSLog(@"\n\nDUMP_STEPIMAGE\n ILstepImage %@", stepImage);
}

void DUMP_STEPVIDEO(ILstepVideo *stepVideo)
{
    NSLog(@"\n\nDUMP_STEPVIDEO\n ILstepVideo %@", stepVideo);
}

#endif //  SUPER_MARTI_DEBUG



-(void) insertTasksFromDatabaseURL:(NSURL *)sourceURL{

    
    //TODO: Rebuild this code using NSPredicate properly, see: http://www.peterfriese.de/using-nspredicate-to-filter-data/
    

    MartiCoreDataStackContext *sourceContext = [[MartiCoreDataStackContext alloc] initWithStoreURL:sourceURL];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILtask" inManagedObjectContext:sourceContext.managedObjectContext]];
    
    
    NSError *error;
    NSArray* fetchedObjects = [sourceContext.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(fetchedObjects && fetchedObjects.count <= 0){
        return;
    }
    
    
    
    NSLog(@" %d Tâches trouvées", fetchedObjects.count);
    
    ILtask* sourceTask;
    
    for (int i = 0; i < fetchedObjects.count; i++){
        
        sourceTask = [fetchedObjects objectAtIndex:i];
        
        if( sourceTask.belongToTasksList.isRootTasksList ) {
                      
            //MartiCoreDataStackContext *stack = [[MartiCoreDataStackContext alloc] initWithStoreURL:url];
            ILgroup *group=[[ILgroup alloc] initEmptyGroup:@"FlashShare" inMOC:[martiStore getDefaultMartiStoreContext].managedObjectContext];
            
            //===========
            ILtask *newTask = [ILtask createEmptyTaskInMOC:[martiStore getDefaultMartiStoreContext].managedObjectContext];
            
            [newTask setTitle:[sourceTask getTitle]];
            NSLog(@"Received Task Name :: %@", [sourceTask getTitle]);
            [newTask setDescription:[sourceTask getDescription]];
            [newTask setLanguage:[sourceTask getLanguage]];
            [newTask setUseState:[sourceTask getUseState]];
            [newTask setAccessRights:[sourceTask getAccessRights]];
            [newTask setVersion:[sourceTask getVersion]];
            [newTask setAudioData:[sourceTask getAudioData]];
            
            [newTask setImageData:[sourceTask getImageData]];
            [newTask setThumbnailData:[sourceTask getThumbnailData]];
            
            
            for (NSUInteger index = 0; index < [sourceTask getNumberOfSteps]; index++){
                ILstep* dstStep = [ILstep copyOfStep:[sourceTask getStepAtIndex:index] inMOC:[martiStore getDefaultMartiStoreContext].managedObjectContext];
                [[newTask mutableOrderedSetValueForKeyPath:@"steps"] addObject:dstStep];
            }
            
            [[group getTasksList] addTaskAtTheEndOfTasksList:newTask];
            
        }
    }

    [[martiStore getDefaultMartiStoreContext].managedObjectContext save:&error];
    
}


//-(void) insertTasksOnMainDataBase

-(void) copyTasksFromDatabaseURL:(NSURL *)sourceURL toDatabaseURL:(NSURL *)destinationURL{
    MartiCoreDataStackContext *stack = [[MartiCoreDataStackContext alloc] initWithStoreURL:sourceURL];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILtask" inManagedObjectContext:stack.managedObjectContext]];
    NSError *error;
    NSArray* fetchedObjects = [stack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(fetchedObjects && fetchedObjects.count <= 0){
        return;
    }
    
    ILtask* sourceTask;
    
    for (int i = 0; i < fetchedObjects.count; i++){
        
        sourceTask = [fetchedObjects objectAtIndex:i];
        
        if( sourceTask.belongToTasksList.isRootTasksList ) {
            [self insertTasksOnDataBase:[fetchedObjects objectAtIndex:i] inStore:destinationURL];
        }
            
    }
    
}

-(void)insertTasksOnDataBase:(ILtask *)srcTask inStore:(NSURL *)url
{
    
    MartiCoreDataStackContext *destinationContext = [[MartiCoreDataStackContext alloc] initWithStoreURL:url];
    
    ILgroup *group=[[ILgroup alloc] initEmptyGroup:@"FlashShare" inMOC:destinationContext.managedObjectContext];
    
    //===========
    ILtask *newTask = [ILtask createEmptyTaskInMOC:destinationContext.managedObjectContext];
    
    [newTask setTitle:[srcTask getTitle]];
    NSLog(@"Received Task Name :: %@", [srcTask getTitle]);
    [newTask setDescription:[srcTask getDescription]];
    [newTask setLanguage:[srcTask getLanguage]];
    [newTask setUseState:[srcTask getUseState]];
    [newTask setAccessRights:[srcTask getAccessRights]];
    [newTask setVersion:[srcTask getVersion]];
    [newTask setAudioData:[srcTask getAudioData]];
    
    [newTask setImageData:[srcTask getImageData]];
    [newTask setThumbnailData:[srcTask getThumbnailData]];
    
    
    for (NSUInteger index = 0; index < [srcTask getNumberOfSteps]; index++){
        ILstep* newStep = [ILstep copyOfStep:[srcTask getStepAtIndex:index] inMOC:destinationContext.managedObjectContext];
        [[newTask mutableOrderedSetValueForKeyPath:@"steps"] addObject:newStep];
    }
    
    [[group getTasksList] addTaskAtTheEndOfTasksList:newTask];
    
    NSError *error = nil;
    [destinationContext.managedObjectContext save:&error] ;
    
}


-(void) insertTasksOnFlashShareSessionDataBase{
    
    MartiCoreDataStackContext *stack = [[MartiCoreDataStackContext alloc] initWithStoreURL:[metrics martiFlashShareClientTempDatabaseURL]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILtask" inManagedObjectContext:stack.managedObjectContext]];
    NSError *error;
    NSArray* fetchedObjects = [stack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(fetchedObjects && fetchedObjects.count <= 0){
        return;
    }
    [self insertTasksOnDataBase:[fetchedObjects objectAtIndex:0] inStore:[metrics martiUserDatabaseURL]];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtURL:[metrics martiFlashShareClientTempDatabaseURL]  error:NULL];
    
}


/*-(NSURL*) insertTasksOnTemporaryDataBase:(ILtask *)srcTask {
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                          inDomains:NSUserDomainMask] lastObject]
                  URLByAppendingPathComponent:@"BTtemps"];
    
    [self insertTasksOnDataBase:srcTask inStore:url];
    return url;
}*/


#pragma mark - New Methods by Marco Guilmette
//
// Added by Marco Guilmette
//

-(NSURL*)addTask:(ILtask *)task inStoreURL:(NSURL *)url
{
    
    MartiCoreDataStackContext *stack = [[MartiCoreDataStackContext alloc] initWithStoreURL:url];
    ILgroup *group=[[ILgroup alloc] initEmptyGroup:@"FlashShare" inMOC:stack.managedObjectContext];
    
    //===========
    ILtask *newTask = [ILtask createEmptyTaskInMOC:stack.managedObjectContext];
    
    [newTask setTitle:[task getTitle]];
    NSLog(@"%@", [task getTitle]);
    [newTask setDescription:[task getDescription]];
    
    [newTask setLanguage:[task getLanguage]];
    [newTask setUseState:[task getUseState]];
    [newTask setAccessRights:[task getAccessRights]];
    [newTask setVersion:[task getVersion]];
    [newTask setAudioData:[task getAudioData]];
    
    [newTask setImageData:[task getImageData]];
    [newTask setThumbnailData:[task getThumbnailData]];
    
    for (NSUInteger index = 0; index < [task getNumberOfSteps]; index++){
        ILstep* dstStep = [ILstep copyOfStep:[task getStepAtIndex:index] inMOC:stack.managedObjectContext];
        
        [[newTask mutableOrderedSetValueForKeyPath:@"steps"] addObject:dstStep];
        
    }
    
    [[group getTasksList] addTaskAtTheEndOfTasksList:newTask];
    
    
    
    NSError *error = nil;
    [stack.managedObjectContext save:&error] ;
    
    return url;
}


-(void) insertFlashShareTasksOnMainDataBase{

    MartiCoreDataStackContext *stack = [[MartiCoreDataStackContext alloc] initWithStoreURL:[metrics martiFlashShareClientTempDatabaseURL]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ILtask" inManagedObjectContext:stack.managedObjectContext]];
    NSError *error;
    NSArray* fetchedObjects = [stack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(fetchedObjects && fetchedObjects.count <= 0){
        return;
    }
    [self insertTasksOnDataBase:[fetchedObjects objectAtIndex:0] inStore:[metrics martiUserDatabaseURL]];
    
    
    [self deleteFlashShareClientTempDatabase];
    
}

-(NSURL*)addTask:(ILtask *)task onDataBase:(NSString*)database {
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                          inDomains:NSUserDomainMask] lastObject]
                  URLByAppendingPathComponent:database];
    
    [self insertTasksOnDataBase:task inStore:url];
    return url;
}

-(void)deleteDataBase:(NSString*)database {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                          inDomains:NSUserDomainMask] lastObject]
                  URLByAppendingPathComponent:database];
    [fileManager removeItemAtURL:url  error:NULL];
}

-(NSURL*)addTaskToFlashShareServerTempDatabase:(ILtask*)task{
    return [self addTask:task inStoreURL:[metrics martiFlashShareServerTempDatabaseURL]];
}

-(NSURL*)addTaskToFlashShareClientTempDatabase:(ILtask*)task{
    return[self addTask:task inStoreURL:[metrics martiFlashShareClientTempDatabaseURL]];
}

-(NSURL*)addTaskToFlashShareSessionTempDatabase:(ILtask*)task{
    return [self addTask:task inStoreURL:[metrics martiFlashShareSessionTempDatabaseURL]];
}

//Was storing buffered tasks on a single receiving task(s) transfer on client side
-(void)deleteFlashShareServerTempDatabase{ [self deleteDataBase:FLASHSHARE_SERVERBUFFER_DOC_NAME]; }

//Was storing buffered tasks on a single receiving task(s) transfer on client side
-(void)deleteFlashShareClientTempDatabase{ [self deleteDataBase:FLASHSHARE_CLIENTBUFFER_DOC_NAME]; }

//Was storing all the received tasks on an actual sharing session
-(void)deleteFlashShareSessionTempDatabase{ [self deleteDataBase:FLASHSHARE_SESSION_DOC_NAME]; }

@end
