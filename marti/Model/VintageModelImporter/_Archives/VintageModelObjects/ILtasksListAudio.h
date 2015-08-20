//
//  ILtasksListAudio.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILtasksList;

@interface ILtasksListAudio : NSManagedObject

@property (nonatomic, retain) NSData * tasksListAudio_data;
@property (nonatomic, retain) NSString * tasksListAudio_flags;
@property (nonatomic, retain) NSDate * tasksListAudio_modifiedDate;
@property (nonatomic, retain) NSNumber * tasksListAudio_version;
@property (nonatomic, retain) ILtasksList *belongToTasksList;

@end
