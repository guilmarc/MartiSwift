//
//  ILtask.m
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ILtask.h"
#import "ILstep.h"
#import "ILtaskAudio.h"
#import "ILtaskAudioShort.h"
#import "ILtaskImage.h"
#import "ILtaskThumbnail.h"
#import "ILtasksList.h"

@implementation ILtask

@dynamic task_accessRights;
@dynamic task_description;
@dynamic task_fakeIndex;
@dynamic task_flags;
@dynamic task_language;
@dynamic task_modifiedDate;
@dynamic task_title;
@dynamic task_useState;
@dynamic task_version;
@dynamic belongToTasksList;
@dynamic steps;
@dynamic task_audio;
@dynamic task_audioShort;
@dynamic task_image;
@dynamic task_thumbnail;

@synthesize taskWeight;
int numberOfStepChoice=0, numberofSimpleStep=0;

- (id)initWithCoder:(NSCoder*)aDecoder {
    //self = [super init];
    self = [aDecoder decodeObjectForKey:@"task"];
    //NSLog(@"Task init with Coder :: %@", [self task_title]);
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:self forKey:@"task"];
}


#pragma mark CREATION

// parameter sub is not used -> 
//
+ (ILtask *)createTaskWithSimpleStep:(BOOL)isSub InMOC:(NSManagedObjectContext *)context
{
    ILtask *task = [ILtask createEmptyTaskInMOC:context];
    if (task)
    {
        [task createSimpleStepAtTheEndOfTask];
    }
    return task;
}

+ (ILtask *)createEmptyTaskInMOC:(NSManagedObjectContext *)context
{
    
    return [[ILtask alloc] initWithEntity:[NSEntityDescription entityForName:@"ILtask" inManagedObjectContext:context]
           insertIntoManagedObjectContext:context];
}

- (ILstep *)duplicateStep:(ILstep *)srcStep atIndex:(NSUInteger)index
{
    ILstep* dstStep = [ILstep copyOfStep:srcStep inMOC:self.managedObjectContext];
    [dstStep addCopyToTitle];
    if (dstStep)
    {
        [[self mutableOrderedSetValueForKeyPath:@"steps"] insertObject:dstStep atIndex:index];
    }
    return dstStep;
}

// Not included in the copy
//
// task_fakeIndex           // not required (run context)
// task_flags               // not used
// task_modifiedDate        // not used
// task_audioShort          // not used
// belongToTasksList        // Done by caller
//
+ (ILtask *)copyOfTask:(ILtask *)srcTask inMOC:(NSManagedObjectContext *)context
{
    ILtask *dstTask = [ILtask createEmptyTaskInMOC:context];
    
    [dstTask setTitle:[srcTask getTitle]];
    [dstTask setDescription:[srcTask getDescription]];
    [dstTask setLanguage:[srcTask getLanguage]];
    [dstTask setUseState:[srcTask getUseState]];
    [dstTask setAccessRights:[srcTask getAccessRights]];
    [dstTask setVersion:[srcTask getVersion]];
    [dstTask setAudioData:[srcTask getAudioData]];
    [dstTask setImageData:[srcTask getImageData]];
    [dstTask setThumbnailData:[srcTask getThumbnailData]];
    
    for (NSUInteger index = 0; index < [srcTask getNumberOfSteps]; index++)
    {
        ILstep* dstStep = [ILstep copyOfStep:[srcTask getStepAtIndex:index] inMOC:context];
        if (!dstStep)
        {
            return nil;
        }
        [[dstTask mutableOrderedSetValueForKeyPath:@"steps"] addObject:dstStep];
//        if( SHOW_NSLOG )NSLog(@"\ndstTask ; %@", dstTask);
//        if( SHOW_NSLOG )NSLog(@"\ndstStep.belongToTask ; %@", dstStep.belongToTask);        
    }
    return dstTask;
}

- (ILstep *)createSimpleStepAtTheEndOfTask
{
    ILstep *newStep = [ILstep createSimpleStepInMOC:self.managedObjectContext];
    if (newStep)
    {
        [[self mutableOrderedSetValueForKeyPath:@"steps"] addObject:newStep];
    }
    return newStep;
}

- (ILstep *)createChoiceStepAtTheEndOfTask
{
    ILstep *newStep = [ILstep createChoiceStepInMOC:self.managedObjectContext];
    if (newStep)
    {
        [[self mutableOrderedSetValueForKeyPath:@"steps"] addObject:newStep];
    }
    return newStep;
}

#pragma mark Basic Accessors

- (UIImage *)getFakeImage
{
    NSData* imData = [self getImageData];
    if (imData)
        return [UIImage imageWithData:imData];
    return ([self isRootTask] ? [mediaManager getDefaultTaskImage] : [mediaManager getDefaultChoiceImage]);
}

- (NSData *)getImageData
{
    
    //return ((self.task_image && self.task_image.taskImage_data)? self.task_image.taskImage_data :
    //        [pictoPersistentManager getPictogramWithId: self.task_image.taskpictogramid].pictogram);
    return self.task_image.taskImage_data;
}   


- (void)setImageData:(NSData *)data
{
    if (!self.task_image)
    {
        self.task_image = [[ILtaskImage alloc] initWithEntity:[NSEntityDescription entityForName:@"ILtaskImage"
                                                                           inManagedObjectContext:self.managedObjectContext]
                                insertIntoManagedObjectContext:self.managedObjectContext];
        self.task_image.belongToTask = self;
    }
    self.task_image.taskImage_data = data;
}

- (void)deleteImage
{
    if (self.task_image)
    {
        [self.managedObjectContext deleteObject:self.task_image];
        self.task_image = nil;
        self.task_image.taskpictogramid = nil;
    }
}

- (UIImage *)getFakeThumbnail
{
    NSData* thData = [self getThumbnailData];
    if (thData)
        return [UIImage imageWithData:thData];
    return ([self isRootTask] ? [mediaManager getDefaultTaskThumbnail] : [mediaManager getDefaultChoiceThumbnail]);
}

- (NSData *)getThumbnailData
{
    //return ((self.task_thumbnail && self.task_thumbnail.taskThumbnail_data)? self.task_thumbnail.taskThumbnail_data :
    //        [pictoPersistentManager getPictogramThumbnailWithId: self.task_image.taskpictogramid].pictogram);
    return self.task_thumbnail.taskThumbnail_data;
}

- (void)setThumbnailData:(NSData *)data
{
    if (!self.task_thumbnail)
    {
        self.task_thumbnail = [[ILtaskThumbnail alloc] initWithEntity:[NSEntityDescription entityForName:@"ILtaskThumbnail"
                                                                               inManagedObjectContext:self.managedObjectContext]
                                    insertIntoManagedObjectContext:self.managedObjectContext];
        self.task_thumbnail.taskThumbnail_data = data;
    }
    self.task_thumbnail.taskThumbnail_data = data;
}

- (void)deleteThumbnail
{
    if (self.task_thumbnail)
    {
        [self.managedObjectContext deleteObject:self.task_thumbnail];
        self.task_thumbnail = nil;
         self.task_image.taskpictogramid = @"0";
    }
}

- (NSData *)getFakeAudioData
{
    NSData* audioData = [self getAudioData];
    if (audioData)
        return audioData;
    return ([self isRootTask] ? [mediaManager getDefaultSoundPressAgainTask] : [mediaManager getDefaultSoundPressAgainChoice]);
}

- (NSData *)getAudioData
{
    return self.task_audio.taskAudio_data;
}

- (void)setAudioData:(NSData *)audioData
{
    if (!audioData)
    {
        [self deleteAudio];
        return;
    }
    if (!self.task_audio)
    {        
        self.task_audio = [[ILtaskAudio alloc] initWithEntity:[NSEntityDescription entityForName:@"ILtaskAudio"
                                                                           inManagedObjectContext:self.managedObjectContext]
                                insertIntoManagedObjectContext:self.managedObjectContext];
        self.task_audio.belongToTask = self;
    }
    self.task_audio.taskAudio_data = audioData;
}

- (void)deleteAudio
{
    if (self.task_audio)
    {
        [self.managedObjectContext deleteObject:self.task_audio];
        self.task_audio = nil;
    }
}

- (NSData *)getAudioShortData
{
    return self.task_audioShort.taskAudioShort_data;
}

- (void)setAudioShortData:(NSData *)data
{
    if (!self.task_audioShort)
    {        
        self.task_audioShort = [[ILtaskAudioShort alloc] initWithEntity:[NSEntityDescription entityForName:@"ILtaskAudioShort"
                                                                                    inManagedObjectContext:self.managedObjectContext]
                                         insertIntoManagedObjectContext:self.managedObjectContext];
        self.task_audioShort.belongToTask = self;
    }
    self.task_audioShort.taskAudioShort_data = data;
}

- (BOOL)isTitleEquivalentTo:(NSString *)string
{
    if (self.task_title)
    {
        return [self.task_title isEqualToString:string];
    }
    return (string.length == 0);
}

- (NSString *)getTitle
{
    return self.task_title;
}

- (NSString *)getFakeTitle
{
    if (!self.task_title || !self.task_title.length)
    {
        return NSLocalizedString(@"DummyTitleTaskKey", @"");
    }
    return self.task_title;
}

-(NSUInteger) getNumberOfSteps
 {
     return [[self steps] count];
 }

- (void)addCopyToTitle
{
    NSMutableString *newString = [NSMutableString stringWithString:NSLocalizedString(@"CopyOfKey", @"")];
    [newString appendString:[self getFakeTitle]];
    [self setTitle:newString];
}

- (void)setTitle:(NSString *)title
{
    if (!title || !title.length)
    {
        self.task_title = nil;
    }
    else if (title.length > 30)
    {
        self.task_title = [title substringToIndex:30];
    }
    else
    {
        self.task_title = title;
    }
}

- (NSString *)getDescription
{   numberofSimpleStep=0;
    numberOfStepChoice=0;
    
    
    [self recusrsCount:self];
    
    
    
    
    
    return [NSString stringWithFormat:@"%i %@ + %i %@",numberofSimpleStep,
            (numberofSimpleStep>1?NSLocalizedString(@"labelStepsCellTypeKey", @""):NSLocalizedString(@"labelStepCellTypeKey", @"")), 
            numberOfStepChoice,
            (numberOfStepChoice>1?NSLocalizedString(@"labelChoicesCellTypeKey", @""):NSLocalizedString(@"labelChoiceCellTypeKey", @""))]; 
}

- (void)recusrsCount:(ILtask*)task
{  if(!task)
    return ;
    
    for(int i=0;i< task.steps.count;i++)
    { ILstep* stepi=[task.steps objectAtIndex: i];
        if([stepi isSimpleStep])
            numberofSimpleStep++;
        else
        {numberOfStepChoice++;
            for(int i=0;i<[stepi.subTasks getNumberOfTasks];i++)
            {ILtask* subtask =[stepi.subTasks getTaskAtIndex:i];
                [self recusrsCount :subtask];
            }
            
            
        }
        
    }
    
    
}
    

- (void)setDescription:(NSString *)desc
{
    if (!desc || !desc.length)
    {
        self.task_description = nil;
    }
    else
    {
        self.task_description = desc;
    }
}

- (float)getVersion
{
    return  (self.task_version ? self.task_version.floatValue : 1.02);  // TODO softCode
}

- (void)setVersion:(float)version
{
    self.task_version = [NSNumber numberWithFloat:version];
}



- (ILstep *)getStepAtIndex:(NSUInteger)index
{
    return [self.steps objectAtIndex:index];
}

- (ILstep *)getSafelyStepAtIndex:(NSUInteger)index
{
    if (index < self.steps.count)
    {
        return [self.steps objectAtIndex:index];
    }
    return nil;
}

- (BOOL)isRootTask
{
    return [self.belongToTasksList isRootTasksList];
}

- (NSString *)getLanguage
{
    return self.task_language;
}

- (void)setLanguage:(NSString *)language
{
    if (!language || !language.length)
    {
        self.task_language = nil;
    }
    else
    {
        self.task_language = language;
    }
}

- (NSString *)getAccessRights
{
    return self.task_accessRights;
}

- (void)setAccessRights:(NSString *)accessRights
{
    if (!accessRights || !accessRights.length)
    {
        self.task_accessRights = nil;
    }
    else
    {
        self.task_accessRights = accessRights;
    }
}

- (BOOL)isWriteProtected
{
    return (self.task_accessRights && ![self.task_accessRights rangeOfString:ACCESS_RIGHTS_WRITE].length);
}

- (BOOL)isDeleteProtected
{
    return (self.task_accessRights && ![self.task_accessRights rangeOfString:ACCESS_RIGHTS_DELETE].length);
}

- (void)setAccessRightsAndCascade:(NSString *)accessRights
{
    [self setAccessRights:accessRights];
    for (NSUInteger index = 0; index < self.steps.count; index++)
    {
        [[self getStepAtIndex:index] setAccessRightsAndCascade:accessRights];
    }
}

- (NSString *)getUseState
{
    return self.task_useState;
}

- (void)setUseState:(NSString *)useState
{
    if (!useState || !useState.length)
    {
        self.task_useState = nil;
    }
    else
    {
        self.task_useState = useState;
    }
}

- (void)setUseStateBOOL:(BOOL)on
{
    [self setUseState:(on ? USE_STATE_ACTIVE : USE_STATE_INACTIVE)];
}

- (BOOL)isActive
{
    return (!self.task_useState || [self.task_useState isEqualToString:USE_STATE_ACTIVE]);
}

#pragma mark FUNCTIONALS

- (BOOL)isFakeIndexed
{
    return (self.task_fakeIndex && (self.task_fakeIndex >= 0));
}

- (NSInteger)getFakeIndex
{
    return  (self.task_fakeIndex ? self.task_fakeIndex.integerValue : -1);
}

- (void)setFakeIndex:(NSInteger)fakeIndex
{
    if (!self.task_fakeIndex || ([self getFakeIndex] != fakeIndex))
    {
        self.task_fakeIndex = [NSNumber numberWithInteger:fakeIndex];
    }
}

#pragma mark DELETING and MOVING steps

- (BOOL)deleteItself
{
    return [self.belongToTasksList deleteTask:self];
}

- (BOOL)deleteStepAtIndex:(NSUInteger)index
{
    if (index < self.steps.count)
    {
        [self.managedObjectContext deleteObject:[self getStepAtIndex:index]];
        [[self mutableOrderedSetValueForKeyPath:@"steps"] removeObjectAtIndex:index];
        return YES;
    }    
    return NO;
}

- (BOOL)moveStepAtIndex:(NSUInteger)srcIndex toIndex:(NSUInteger)dstIndex
{
    NSUInteger nbSteps = self.steps.count;
    if (dstIndex >= nbSteps)
    {
        dstIndex = nbSteps-1;
    }
    if (srcIndex != dstIndex)
    {
        [[self mutableOrderedSetValueForKeyPath:@"steps"]
                    moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:srcIndex] toIndex:dstIndex];
        return YES;
    }
    return NO;
}

#pragma mark STEP NAVIGATION

- (NSUInteger)indexOfStep:(ILstep *)step
{
    return [self.steps indexOfObject:step];
}

- (ILstep *)getFirstActiveStep
{
    NSInteger index = 0;
    while (index < self.steps.count)
    {
        ILstep *firstStep = [self.steps objectAtIndex:index];
        if ([firstStep isActive])
        {
            return firstStep;
        }
        index++;
    }
    return nil;
}

- (ILstep *)getLastActiveStep
{
    NSInteger index = self.steps.count;
    while(index > 0)
    {
        index--;
        ILstep *lastStep = [self.steps objectAtIndex:index];
        if ([lastStep isActive])
        {
            if ([lastStep isChoiceStep])
            {
                return [lastStep getLastStepOfSelectedChoice];
            }
            return lastStep;
        }
    }
    return nil;
}

- (ILstep *)getPrevStepInTask:(ILstep *)step
{
    NSInteger index = [self indexOfStep:step];
//    if( SHOW_NSLOG )NSLog(@"\n --- PREV step: %@, atIndex %d", [step getTitle], index);
    while (index > 0)
    {
        index--;
        ILstep *prevStep = [self.steps objectAtIndex:index];
        if ([prevStep isActive])
        {
            if ([prevStep isChoiceStep])
            {
                return [prevStep getLastStepOfSelectedChoice];
            }
            return prevStep;
        }
    }
    if ([self isRootTask])
    {
        return nil;
    }
    return self.belongToTasksList.belongToStep;
}

- (ILstep *)getNextStepInTask:(ILstep *)step
{
    NSInteger index = [self indexOfStep:step];
//    if( SHOW_NSLOG )NSLog(@"\n --- NEXT step: %@, atIndex %d", [step getTitle], index);
    NSInteger lastIndex = (self.steps.count-1);
    while (index < lastIndex)
    {
        index++;
        ILstep *nextStep = [self.steps objectAtIndex:index];
        if ([nextStep isActive])
        {
            return nextStep;
        }
    }
    if ([self isRootTask])
    {
        return nil;
    }
    return [self.belongToTasksList.belongToStep getNextStep];
}

- (float)computeTaskWeight:(float)weight
{
    if ([self isActive])
    {
        for (NSUInteger index = 0; index < self.steps.count; index++)
        {
            weight = [[self getStepAtIndex:index] computeStepWeight:weight];
        }
        self.taskWeight = weight;
        return self.taskWeight;
    }
    return weight;
}



@end
