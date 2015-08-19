//
//  CDManager.h
//  MartiPro
//
//  Created by Marco Guilmette on 12/18/2013.
//  Copyright (c) 2013 Infologique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VintageMartiCDManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,readonly) NSFetchedResultsController* taskFetchedResultsController;

+ (VintageMartiCDManager*)sharedManager;
- (void)saveContext;

@end
