//
//  ILtaskImage.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILtask,ILPictogram;

@interface ILtaskImage : NSManagedObject

@property (nonatomic, retain) NSData * taskImage_data;
@property (nonatomic, retain) NSString * taskImage_flags;
@property (nonatomic, retain) NSDate * taskImage_modifiedDate;
@property (nonatomic, retain) NSNumber * taskImage_version;
@property (nonatomic, retain) ILtask *belongToTask;
@property (nonatomic, retain) NSString* taskpictogramid;

-(void) setPictogramid:(NSString*)pid;

@end
