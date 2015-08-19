//
//  ILcoreDataStackContext.h
//  marti
//
//  Created by Paul Legault Local on 11-12-12.
//  Copyright (c) 2011 Infologique Innovation inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILgroup.h"

@interface MartiCoreDataStackContext : NSObject

@property (nonatomic) BOOL isValid;
@property (strong, nonatomic) NSURL *storeURL;
@property (strong, nonatomic) NSMutableArray *managedGroups;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *storeCoordinator;
@property (strong, nonatomic) NSPersistentStore *persistentStore;

- (id)initWithStoreURL:(NSURL *)url;
- (ILgroup *)getFirstGroup;
- (BOOL)isItThisStore:(NSURL *)url;

@end
