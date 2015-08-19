//
//  ILstepVideo.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILstep;

@interface ILstepVideo : NSManagedObject

@property (nonatomic, retain) NSData * stepVideo_data;
@property (nonatomic, retain) NSString * stepVideo_flags;
@property (nonatomic, retain) NSDate * stepVideo_modifiedDate;
@property (nonatomic, retain) NSNumber * stepVideo_version;
@property (nonatomic, retain) ILstep *belongToStep;

@end
