//
//  ILstepThumbnail.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILstep;

@interface ILstepThumbnail : NSManagedObject

@property (nonatomic, retain) NSData * stepThumbnail_data;
@property (nonatomic, retain) NSString * stepThumbnail_flags;
@property (nonatomic, retain) NSDate * stepThumbnail_modifiedDate;
@property (nonatomic, retain) NSNumber * stepThumbnail_version;
@property (nonatomic, retain) ILstep *belongToStep;

@end
