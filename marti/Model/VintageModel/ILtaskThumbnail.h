//
//  ILtaskThumbnail.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILtask;

@interface ILtaskThumbnail : NSManagedObject

@property (nonatomic, retain) NSData * taskThumbnail_data;
@property (nonatomic, retain) NSString * taskThumbnail_flags;
@property (nonatomic, retain) NSDate * taskThumbnail_modifiedDate;
@property (nonatomic, retain) NSNumber * taskThumbnail_version;
@property (nonatomic, retain) ILtask *belongToTask;

@end
