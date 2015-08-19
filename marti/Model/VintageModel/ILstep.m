//
//  ILstep.m
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ILstep.h"
#import "ILstep.h"
#import "ILstepAudio.h"
#import "ILstepAudioShort.h"
#import "ILstepImage.h"
#import "ILstepThumbnail.h"
#import "ILstepVideo.h"
#import "ILtask.h"
#import "ILtasksList.h"

@implementation ILstep

@dynamic step_contentStyle;
@dynamic step_description;
@dynamic step_flags;
@dynamic step_modifiedDate;
@dynamic step_style;
@dynamic step_title;
@dynamic step_useState;
@dynamic step_version;
@dynamic belongToTask;
@dynamic step_audio;
@dynamic step_audioShort;
@dynamic step_image;
@dynamic step_thumbnail;
@dynamic step_video;
@dynamic subStep;
@dynamic subTasks;
@dynamic superStep;

@synthesize backTrackTaskIndex;
@synthesize stepWeight;

#pragma mark CREATION

+ (ILstep *)createSimpleStepInMOC:(NSManagedObjectContext *)context
{
    ILstep *newStep = [[ILstep alloc] initWithEntity:[NSEntityDescription entityForName:@"ILstep" inManagedObjectContext:context]
                      insertIntoManagedObjectContext:context];
    if (newStep)
    {
        newStep.step_style = STEP_STYLE_SIMPLE;
        [newStep setStepIsImageAndAudio];
    }
    return newStep;
}
    
+ (ILstep *)createChoiceStepInMOC:(NSManagedObjectContext *)context
{
    ILstep *newStep = [[ILstep alloc] initWithEntity:[NSEntityDescription entityForName:@"ILstep" inManagedObjectContext:context]
                      insertIntoManagedObjectContext:context];
    if (newStep)
    {
        newStep.step_style = STEP_STYLE_CHOICE;
        [newStep setStepIsImageAndAudio];
        ILtasksList *tasksList = [ILtasksList createSubTasksListInMOC:context];
        // Create 2 tasks
        if (tasksList)
        {
            newStep.subTasks = tasksList;
            [tasksList addTaskAtTheEndOfTasksList:[ILtask createTaskWithSimpleStep:YES InMOC:context]];
            [tasksList addTaskAtTheEndOfTasksList:[ILtask createTaskWithSimpleStep:YES InMOC:context]];
            return newStep;
        }
    }
    return nil;
}

// Not included in the copy
//
// step_flags          // not used
// step_modifiedDate   // not used
// step_audioShort     // not used
// subStep             // not used
// superStep           // not used
// belongToTask        // Done by caller
//
+ (id)copyOfStep:(ILstep *)srcStep inMOC:(NSManagedObjectContext *)context
{
    ILstep *dstStep = [[ILstep alloc] initWithEntity:[NSEntityDescription entityForName:@"ILstep" inManagedObjectContext:context]
                       insertIntoManagedObjectContext:context];

    if (!dstStep)
    {
        return nil;
    }
    [dstStep setTitle:[srcStep getTitle]];
    [dstStep setDescription:[srcStep getDescription]];
    [dstStep setStyle:[srcStep getStyle]];
    [dstStep setContentStyle:[srcStep getContentStyle]];
    [dstStep setUseState:[srcStep getUseState]];
    [dstStep setVersion:[srcStep getVersion]];
    [dstStep setAudioData:[srcStep getAudioData]];
    [dstStep setImageData:[srcStep getImageData]];
    [dstStep setThumbnailData:[srcStep getThumbnailData]];
    [dstStep setVideoData:[srcStep getVideoData]];

    if ([srcStep getNumberOfChoices] == 0)
    {
        return dstStep;
    }
    ILtasksList *dstTasksList = [ILtasksList copyOfTasksList:[srcStep getChoicesList] inMOC:context];
    if (dstTasksList)
    {
        dstStep.subTasks = dstTasksList;
//        if( SHOW_NSLOG )NSLog(@"\ndstStep ; %@", dstStep);
//        if( SHOW_NSLOG )NSLog(@"\ndstTasksList.belongToStep ; %@", dstTasksList.belongToStep);
        return dstStep;
    }
    return nil;
}

#pragma mark - Basic Accessors

- (float)getVersion
{
    return  (self.step_version ? self.step_version.floatValue : 1.02);  // TODO softCode
}

- (void)setVersion:(float)version
{
    self.step_version = [NSNumber numberWithFloat:version];
}

- (BOOL)isTitleEquivalentTo:(NSString *)string
{
    if (self.step_title)
    {
        return [self.step_title isEqualToString:string];
    }
    return (string.length == 0);
}

- (NSString *)getTitle
{
    return self.step_title;
}

- (NSString *)getFakeTitle
{
    if (!self.step_title || !self.step_title.length)
    {
        return ([self isSimpleStep] ? NSLocalizedString(@"DummyTitleSimpleStepKey", @"")
                                    : NSLocalizedString(@"DummyTitleChoiceStepKey", @""));
    }
    return self.step_title;
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
        self.step_title = nil;
    }
    else if ([title length] > 30)
    {
        self.step_title = [title substringToIndex:30];
    }
    else
    {
        self.step_title = title;
    }
}

- (BOOL)hasDescription
{
    return (self.step_description && self.step_description.length);
}

- (BOOL)isDescriptionEquivalentTo:(NSString *)string
{
    if (self.step_description)
    {
        return [self.step_description isEqualToString:string];
    }
    return (string.length == 0);
}

- (NSString *)getDescription
{
    return self.step_description;
}

- (void)setDescription:(NSString *)desc
{
    if (!desc || !desc.length)
    {
        self.step_description = nil;
    }
    else
    {
        self.step_description = desc;
    }
}

- (NSData *)getVideoData
{
    return (self.step_video ? self.step_video.stepVideo_data : nil);
}

- (void)setVideoData:(NSData *)videoData
{
    if (!videoData)
    {
        [self deleteVideo];
    }
    else
    {
        if (!self.step_video)
        {
            self.step_video = [[ILstepVideo alloc] initWithEntity:[NSEntityDescription entityForName:@"ILstepVideo"
                                                                              inManagedObjectContext:self.managedObjectContext]
                                   insertIntoManagedObjectContext:self.managedObjectContext];
            self.step_video.belongToStep = self;
        }
        self.step_video.stepVideo_data = videoData;
    }
}

- (void)deleteVideo
{
    if (self.step_video)
    {
        [self.managedObjectContext deleteObject:self.step_video];
        self.step_video = nil;
    }
}

- (UIImage *)getFakeImage
{
    NSData* imData = [self getImageData];
    //if(!imData){
    //    imData =[pictoPersistentManager getPictogramWithId: self.step_image.steppictogramid].pictogram;
    //}
    if (imData)
        return [UIImage imageWithData:imData];
    
       
    return ([self isSimpleStep] ? [mediaManager getDefaultSimpleStepImage] : nil);
}

- (NSData *)getImageData
{
    if( SHOW_NSLOG )NSLog(@"getImage %@",self.step_image.steppictogramid);
    
    //return ((self.step_image && self.step_image.stepImage_data) ? self.step_image.stepImage_data :
    //        [pictoPersistentManager getPictogramWithId: self.step_image.steppictogramid].pictogram);
    return self.step_image.stepImage_data;

}


- (void)setImageData:(NSData *)data
{
    if (!data)
    {
        [self deleteImage];
    }
    else
    {
        if (!self.step_image)
        {
            self.step_image = [[ILstepImage alloc] initWithEntity:[NSEntityDescription entityForName:@"ILstepImage"
                                                                              inManagedObjectContext:self.managedObjectContext]
                                   insertIntoManagedObjectContext:self.managedObjectContext];
            self.step_image.belongToStep = self;
            
            
        }
        self.step_image.stepImage_data = data;
    }
}

- (void)deleteImage
{
    if (self.step_image)
    {
        [self.managedObjectContext deleteObject:self.step_image];
        self.step_image = nil;
        self.step_image.steppictogramid = @"-1";
    }
}

- (UIImage *)getSafelyChoiceThumbnailAtIndex:(NSUInteger)index
{
    ILtask *task = [self getSafelyChoiceAtIndex:index];
    if (task)
    {
        return [task getFakeThumbnail];
    }
    return nil;
}

- (UIImage *)getFakeThumbnail
{
    NSData* thData = [self getThumbnailData];
    
    
    if (thData)
        return [UIImage imageWithData:thData];
    return ([self isSimpleStep] ? [mediaManager getDefaultSimpleStepThumbnail] : nil);
}

- (NSData *)getThumbnailData
{
    //return ((self.step_thumbnail && self.step_thumbnail.stepThumbnail_data)? self.step_thumbnail.stepThumbnail_data :
    //        [pictoPersistentManager getPictogramThumbnailWithId: self.step_image.steppictogramid].pictogram);
    return self.step_thumbnail.stepThumbnail_data;
}

- (void)setThumbnailData:(NSData *)data
{
    if (!data)
    {
        [self deleteThumbnail];
    }
    else
    {
        if (!self.step_thumbnail)
        {
            self.step_thumbnail = [[ILstepThumbnail alloc] initWithEntity:[NSEntityDescription entityForName:@"ILstepThumbnail"
                                                                                      inManagedObjectContext:self.managedObjectContext]
                                           insertIntoManagedObjectContext:self.managedObjectContext];
            self.step_thumbnail.belongToStep = self;
        }
        self.step_thumbnail.stepThumbnail_data = data;
    }
}

- (void)deleteThumbnail
{
    if (self.step_thumbnail)
    {
        [self.managedObjectContext deleteObject:self.step_thumbnail];
        self.step_thumbnail = nil;
    }
}

- (NSData *)getFakeAudioData
{
    NSData* audioData = [self getAudioData];
    if (audioData || [self isSimpleStep])
        return audioData;
    return ([self isChoiceStep] ? [mediaManager getDefaultSoundMakeChoice] : nil);
}

- (NSData *)getAudioData
{
    return (self.step_audio ? self.step_audio.stepAudio_data : nil);
}

- (void)setAudioData:(NSData *)audioData
{
    if (!audioData)
    {
        [self deleteAudio];
    }
    else
    {
        if (!self.step_audio)
        {
            self.step_audio = [[ILstepAudio alloc] initWithEntity:[NSEntityDescription entityForName:@"ILstepAudio"
                                                                              inManagedObjectContext:self.managedObjectContext]
                                   insertIntoManagedObjectContext:self.managedObjectContext];
            self.step_audio.belongToStep = self;
        }
        self.step_audio.stepAudio_data = audioData;
    }
}

- (void)deleteAudio
{
    if (self.step_audio)
    {
        [self.managedObjectContext deleteObject:self.step_audio];
        self.step_audio = nil;
    }
}

// NB: step are using task accessRights flags to determine their rights 
//
- (void)setAccessRightsAndCascade:(NSString *)accessRights
{
    if ([self isChoiceStep] && [self getChoicesList])
    {
        [[self getChoicesList] setAccessRightsAndCascade:accessRights];
    }
}

- (BOOL)isWriteProtected
{
    return [self.belongToTask isWriteProtected];
}

- (BOOL)isDeleteProtected
{
    return [self.belongToTask isDeleteProtected];
}

#pragma mark - Choice Step functionals

- (ILtasksList *)getChoicesList
{
    return self.subTasks;
}

- (ILtask *)getSafelyChoiceAtIndex:(NSUInteger)index
{
    if (index < [self getNumberOfChoices])
    {
        return [self.subTasks getTaskAtIndex:index];
    }
    return nil;
}

- (NSInteger)getNumberOfChoices
{
    if (!self.subTasks)
        return 0;
    return [self.subTasks getNumberOfTasks];
}

// Use in Choice step Context only with caution
//
- (BOOL)incNumberOfChoices
{
    if ([self getNumberOfChoices] < 4)
    {
        [self setNumberOfChoices:([self getNumberOfChoices]+1)];
        return YES;
    }
    return NO;
}

// Use in Choice step Context only with caution
//
- (BOOL)decNumberOfChoices
{
    if ([self getNumberOfChoices] > 2)
    {
        [self setNumberOfChoices:([self getNumberOfChoices]-1)];
        return YES;
    }
    return NO;
}

// Use in Choice step Context only with caution
//
- (void)setNumberOfChoices:(NSInteger)nbTasks
{
    [self.subTasks setNumberOfTasks:nbTasks];
}

- (ILtask *)getChoiceAtIndex:(NSUInteger)index
{
    return [self.subTasks getTaskAtIndex:index];
}

#pragma mark - Step style

- (NSString *)getStyle
{
    return self.step_style;
}

- (void)setStyle:(NSString *)style
{
    if (!style || !style.length)
    {
        self.step_style = nil;
    }
    else
    {
        self.step_style = style;
    }
}

- (BOOL)isSimpleStep
{
    return (!self.step_style || [self.step_style isEqualToString:STEP_STYLE_SIMPLE]);
}

- (BOOL)isChoiceStep
{
    return (self.step_style && [self.step_style isEqualToString:STEP_STYLE_CHOICE]);
}

- (BOOL)isLoopStep
{
    return (self.step_style && [self.step_style isEqualToString:STEP_STYLE_LOOP]);   // LATER future development
}

#pragma mark - Simple Step content style

- (NSString *)getContentStyle
{
    return self.step_contentStyle;
}

- (void)setContentStyle:(NSString *)contentStyle
{
    if (!contentStyle || !contentStyle.length)
    {
        self.step_contentStyle = nil;
    }
    else
    {
        self.step_contentStyle = contentStyle;
    }
}

- (BOOL)isVideo
{
    return (self.step_contentStyle && [self.step_contentStyle isEqualToString:STEP_CONTENT_VIDEO]);
}

- (void)setStepIsVideo
{
    if (![self isVideo])
    {
        self.step_contentStyle = STEP_CONTENT_VIDEO;
    }
}

- (void)setStepIsImageAndAudio
{
    if (![self isImageAndAudio])
    {
        self.step_contentStyle = STEP_CONTENT_IMAGE_AND_AUDIO;
    }
}

- (BOOL)isAudioExist
{
    return ([self isChoiceStep] || self.step_audio);
}

- (BOOL)isImageAndAudio
{
    return (!self.step_contentStyle || [self.step_contentStyle isEqualToString:STEP_CONTENT_IMAGE_AND_AUDIO]);
}

#pragma mark - Step Use State

- (BOOL)isStepActive
{
    return (!self.step_useState || [self.step_useState isEqualToString:USE_STATE_ACTIVE]);
}

- (BOOL)isStepPending
{
    return (self.step_useState && [self.step_useState isEqualToString:USE_STATE_PENDING]);
}

- (BOOL)isStepInactive
{
    return (self.step_useState && [self.step_useState isEqualToString:USE_STATE_INACTIVE]);
}

- (NSString *)getUseState
{
    return self.step_useState;
}

- (void)setUseState:(NSString *)useState
{
    if (!useState || !useState.length)
    {
        self.step_useState = nil;
    }
    else
    {
        self.step_useState = useState;
    }
}

- (void)setUseStateBOOL:(BOOL)on
{
    [self setUseState:(on ? USE_STATE_ACTIVE : USE_STATE_INACTIVE)];
}

- (BOOL)isActive
{
    return (!self.step_useState || [self.step_useState isEqualToString:USE_STATE_ACTIVE]);
}

#pragma mark STEP NAVIGATION

- (NSUInteger)indexOfChoice:(ILtask *)task
{
    return [self.subTasks.tasks indexOfObject:task];
}

- (ILstep *)getPrevStep
{
    return [self.belongToTask getPrevStepInTask:self];
}

- (ILstep *)getNextStep
{
    return [self.belongToTask getNextStepInTask:self];
}

- (ILstep *)getNextChoiceStepAtTaskIndex:(NSUInteger)choiceIndex
{
    ILtask *task = [self getChoiceAtIndex:choiceIndex]; // [self.subTasks getTaskAtIndex:index]
    NSInteger stepIndex = 0;
    while (stepIndex < [task getNumberOfSteps])
    {
        ILstep *nextStep = [task getStepAtIndex:stepIndex];
        if ([nextStep isActive])
        {
            return nextStep;
        }
        stepIndex++;
    }
    return [self getNextStep];
}

- (ILstep *)getLastStepOfSelectedChoice
{
    ILtask *task = [self getChoiceAtIndex:backTrackTaskIndex];
    ILstep *step = [task getLastActiveStep];
    if (!step)
    {
        return self;
    }
    else if ([step isChoiceStep])
    {
        return [step getLastStepOfSelectedChoice];
    }
    else
    {
        return step;
    }
}

- (BOOL)isFirstStep
{
    return (![self getPrevStep]);
}

- (float)computeStepWeight:(float)weight
{
    if ([self isActive])
    {
        weight += 1.0;
        self.stepWeight = weight;
        float maxWeight = weight;
        if ([self isChoiceStep])
        {
            for (NSUInteger index = 0; index < [self getNumberOfChoices]; index++)
            {
                float choiceWeight = [[self getChoiceAtIndex:index] computeTaskWeight:weight];
                if (choiceWeight > maxWeight)
                {
                    maxWeight = choiceWeight;
                }
            }
        }
        return maxWeight;
    }
    return weight;
}

@end
