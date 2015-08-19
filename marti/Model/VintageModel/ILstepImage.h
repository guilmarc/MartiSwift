//
//  ILstepImage.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILstep;

@interface ILstepImage : NSManagedObject

@property (nonatomic, retain) NSData * stepImage_data;
@property (nonatomic, retain) NSString * stepImage_flags;
@property (nonatomic, retain) NSDate * stepImage_modifiedDate;
@property (nonatomic, retain) NSNumber * stepImage_version;
@property (nonatomic, retain) ILstep *belongToStep;
@property (nonatomic, retain) NSString* steppictogramid;

-(void)setPictogramid:(NSString*) pictId;


@end
