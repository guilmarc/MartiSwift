//
//  ILstep.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILstep, ILstepAudio, ILstepAudioShort, ILstepImage, ILstepThumbnail, ILstepVideo, ILtask, ILtasksList;

@interface ILstep : NSManagedObject

@property (nonatomic, retain) NSString * step_contentStyle;
@property (nonatomic, retain) NSString * step_description;
@property (nonatomic, retain) NSString * step_flags;
@property (nonatomic, retain) NSDate * step_modifiedDate;
@property (nonatomic, retain) NSString * step_style;
@property (nonatomic, retain) NSString * step_title;
@property (nonatomic, retain) NSString * step_useState;
@property (nonatomic, retain) NSNumber * step_version;
@property (nonatomic, retain) ILtask *belongToTask;
@property (nonatomic, retain) ILstepAudio *step_audio;
@property (nonatomic, retain) ILstepAudioShort *step_audioShort;
@property (nonatomic, retain) ILstepImage *step_image;
@property (nonatomic, retain) ILstepThumbnail *step_thumbnail;
@property (nonatomic, retain) ILstepVideo *step_video;
@property (nonatomic, retain) ILstep *subStep;
@property (nonatomic, retain) ILtasksList *subTasks;
@property (nonatomic, retain) ILstep *superStep;

@property (nonatomic) NSUInteger backTrackTaskIndex;
@property (nonatomic) float stepWeight;

+ (ILstep *)createSimpleStepInMOC:(NSManagedObjectContext *)context;
+ (ILstep *)createChoiceStepInMOC:(NSManagedObjectContext *)context;
+ (ILstep *)copyOfStep:(ILstep *)srcStep inMOC:(NSManagedObjectContext *)context;

// Basic Accessors
- (float)getVersion;
- (void)setVersion:(float)version;
- (BOOL)isTitleEquivalentTo:(NSString *)string;
- (NSString *)getTitle;
- (NSString *)getFakeTitle;
- (void)addCopyToTitle;
- (void)setTitle:(NSString *)title;
- (BOOL)hasDescription;
- (BOOL)isDescriptionEquivalentTo:(NSString *)string;
- (NSString *)getDescription;
- (void)setDescription:(NSString *)desc;
- (NSData *)getVideoData;
- (void)setVideoData:(NSData *)videoData;
- (void)deleteVideo;
- (UIImage *)getFakeImage;
- (NSData *)getImageData;
- (void)setImageData:(NSData *)data;
- (void)deleteImage;
- (UIImage *)getSafelyChoiceThumbnailAtIndex:(NSUInteger)index;
- (UIImage *)getFakeThumbnail;
- (NSData *)getThumbnailData;
- (void)setThumbnailData:(NSData *)data;
- (void)deleteThumbnail;
- (NSData *)getFakeAudioData;
- (NSData *)getAudioData;
- (void)setAudioData:(NSData *)audioData;
- (void)deleteAudio;
- (void)setAccessRightsAndCascade:(NSString *)accessRights;
- (BOOL)isWriteProtected;
- (BOOL)isDeleteProtected;

// Choice Step functionals
- (ILtasksList *)getChoicesList;
- (ILtask *)getSafelyChoiceAtIndex:(NSUInteger)index;
- (NSInteger)getNumberOfChoices;
- (BOOL)incNumberOfChoices;
- (BOOL)decNumberOfChoices;
- (void)setNumberOfChoices:(NSInteger)nbTasks;
- (ILtask *)getChoiceAtIndex:(NSUInteger)index;

// Step style
- (NSString *)getStyle;
- (void)setStyle:(NSString *)style;
- (BOOL)isSimpleStep;
- (BOOL)isChoiceStep;
- (BOOL)isLoopStep;

// Simple Step content style
- (NSString *)getContentStyle;
- (void)setContentStyle:(NSString *)contentStyle;
- (BOOL)isVideo;
- (void)setStepIsVideo;
- (void)setStepIsImageAndAudio;
- (BOOL)isAudioExist;
- (BOOL)isImageAndAudio;

// Step Use State
- (BOOL)isStepActive;
- (BOOL)isStepPending;
- (BOOL)isStepInactive;
- (NSString *)getUseState;
- (void)setUseState:(NSString *)useState;
- (void)setUseStateBOOL:(BOOL)on;
- (BOOL)isActive;

// Step Navigation
- (NSUInteger)indexOfChoice:(ILtask *)task;
- (ILstep *)getPrevStep;
- (ILstep *)getNextStep;
- (ILstep *)getNextChoiceStepAtTaskIndex:(NSUInteger)choiceIndex;
- (ILstep *)getLastStepOfSelectedChoice;
- (BOOL)isFirstStep;
- (float)computeStepWeight:(float)weight;

@end
