//
//  ILcoreDataStackContext.m
//  marti
//
//  Created by Paul Legault Local on 11-12-12.
//  Copyright (c) 2011 Infologique Innovation inc. All rights reserved.
//

#import "ILcoreDataStackContext.h"
#import <CoreData/CoreData.h>

@implementation MartiCoreDataStackContext

@synthesize isValid;
@synthesize storeURL;
@synthesize managedGroups;              // CORE DATA ILGroup LAYER (CUSTOM)
@synthesize managedObjectContext;       // CORE DATA CONTEXT LAYER
@synthesize managedObjectModel;         // CORE DATA MODEL LAYER
@synthesize storeCoordinator;           // CORE DATA STORE LAYER
@synthesize persistentStore;

- (id)initWithStoreURL:(NSURL *)url
{
   
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:url.path isDirectory:&isDir] &&isDir) {
            return nil;
    }
    self.storeURL = url;
    
    if(!self.managedObjectModel){
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"marti" withExtension:@"momd"]];
    }
    
    if (!self.managedObjectModel){
         if( SHOW_NSLOG )NSLog(@"ILcoreDataStackContext : Cannot initialize managedObjectModel for ressource marti.momd");
        return self;
    }
    if(!self.storeCoordinator ){
        self.storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    }
    if (!self.storeCoordinator){
        if( SHOW_NSLOG )NSLog(@"ILcoreDataStackContext : Cannot initialize storeCoordinator for managedObjectModel of marti.momd");
        return self;
    }
    if(!self.managedObjectContext){
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setPersistentStoreCoordinator:self.storeCoordinator];
    }
    if (!self.managedObjectContext){
        if( SHOW_NSLOG )NSLog(@"ILcoreDataStackContext : Cannot initialize managedObjectContext ");
        return self;
    }
               
    
    if(! self.persistentStore){
    // Force managedObject save to sync the modifications in the file (sqlite) not in the cache
        NSMutableDictionary *pragmaOptions = [NSMutableDictionary dictionary];
        [pragmaOptions setObject:@"FULL" forKey:@"synchronous"];
        [pragmaOptions setObject:@"1" forKey:@"fullfsync"];
        [pragmaOptions setObject:@"FULL" forKey:@"auto_vacuum"];
        NSDictionary *storeOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  NSSQLitePragmasOption , pragmaOptions,nil];
                 
        NSMutableDictionary *options = [storeOptions mutableCopy];
        [options setObject:[NSNumber numberWithBool:YES] forKey: NSMigratePersistentStoresAutomaticallyOption];
        [options setObject:[NSNumber numberWithBool:YES] forKey: NSInferMappingModelAutomaticallyOption ];
        
        //TODO:  Will run one when a database compact is asked in the preference board [Compact DB on reboot]
        //[options setObject:[NSNumber numberWithBool:YES] forKey: NSSQLiteManualVacuumOption ];
        
       // [options setObject:[NSNumber numberWithBool:YES] forKey: NSIgnorePersistentStoreVersioningOption];
        NSError *error = nil;
        [self.storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:self.storeURL
                                              options:options
                                                error:&error];
        if(error){
            if( SHOW_NSLOG )NSLog(@"ILcoreDataStackContext : Error adding persistentStore in URL %@ storeCoordinator %@",self.storeURL, error );
        }
                    
        self.persistentStore = [self.storeCoordinator persistentStoreForURL:self.storeURL];
    
        if(!self.persistentStore){
            if( SHOW_NSLOG )NSLog(@"ILcoreDataStackContext : Error retrieving persistentStore from storeCoordinator ");
            return self;
        }
        managedGroups = [NSMutableArray array];
        [[self.managedObjectContext undoManager] disableUndoRegistration];
        isValid = (managedGroups != nil);
    }
    return self;
}

// TODO LATER : MULTI GROUP SUPPORT
//
- (ILgroup *)getFirstGroup
{
    if (self.managedGroups.count > 0)
    {
        return [self.managedGroups objectAtIndex:0];
    }
    return nil;
}

- (BOOL)isItThisStore:(NSURL *)url
{
    return ([[storeURL lastPathComponent] isEqualToString:[url lastPathComponent]]);
}


@end
