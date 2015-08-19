//
//  ILtaskImage.m
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ILtaskImage.h"
#import "ILtask.h"


@implementation ILtaskImage

@dynamic taskImage_data;
@dynamic taskImage_flags;
@dynamic taskImage_modifiedDate;
@dynamic taskImage_version;
@dynamic belongToTask;
@dynamic taskpictogramid;

-(void) setPictogramid:(NSString*)pid{
    self.taskpictogramid = pid;
}

@end
