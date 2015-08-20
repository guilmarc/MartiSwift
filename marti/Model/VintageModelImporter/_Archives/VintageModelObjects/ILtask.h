//
//  ILtask.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILstep, ILtaskAudio, ILtaskAudioShort, ILtaskImage, ILtaskThumbnail, ILtasksList;

@interface ILtask : NSManagedObject

@property (nonatomic, retain) NSString * task_accessRights;
@property (nonatomic, retain) NSString * task_description;
@property (nonatomic, retain) NSNumber * task_fakeIndex;
@property (nonatomic, retain) NSString * task_flags;
@property (nonatomic, retain) NSString * task_language;
@property (nonatomic, retain) NSDate * task_modifiedDate;
@property (nonatomic, retain) NSString * task_title;
@property (nonatomic, retain) NSString * task_useState;
@property (nonatomic, retain) NSNumber * task_version;

@property (nonatomic, retain) ILtasksList *belongToTasksList;
@property (nonatomic, retain) NSOrderedSet *steps;
@property (nonatomic, retain) ILtaskAudio *task_audio;
@property (nonatomic, retain) ILtaskAudioShort *task_audioShort;
@property (nonatomic, retain) ILtaskImage *task_image;
@property (nonatomic, retain) ILtaskThumbnail *task_thumbnail;

@property (nonatomic) float taskWeight;

// CREATION
+ (ILtask *)createTaskWithSimpleStep:(BOOL)isSub InMOC:(NSManagedObjectContext *)context;
+ (ILtask *)createEmptyTaskInMOC:(NSManagedObjectContext *)context;
- (ILstep *)duplicateStep:(ILstep *)srcStep atIndex:(NSUInteger)index;
+ (ILtask *)copyOfTask:(ILtask *)srcTask inMOC:(NSManagedObjectContext *)context;

- (ILstep *)createSimpleStepAtTheEndOfTask;
- (ILstep *)createChoiceStepAtTheEndOfTask;

// BASIC ACCESSORS

//- (UIImage *)getFakeImage;
- (NSData *)getImageData;
- (void)setImageData:(NSData *)data;
- (void)deleteImage;
//- (UIImage *)getFakeThumbnail;
- (NSData *)getThumbnailData;
- (void)setThumbnailData:(NSData *)data;
- (void)deleteThumbnail;
- (NSData *)getFakeAudioData;
- (NSData *)getAudioData;
- (void)setAudioData:(NSData *)audioData;
- (void)deleteAudio;
- (NSData *)getAudioShortData;
- (void)setAudioShortData:(NSData *)data;
- (BOOL)isTitleEquivalentTo:(NSString *)string;
- (NSString *)getTitle;
- (NSString *)getFakeTitle;
- (void)addCopyToTitle;
- (void)setTitle:(NSString *)title;
- (NSString *)getDescription;
- (void)setDescription:(NSString *)desc;
- (float)getVersion;
- (void)setVersion:(float)version;
- (NSUInteger)getNumberOfSteps;
- (ILstep *)getStepAtIndex:(NSUInteger)index;
- (ILstep *)getSafelyStepAtIndex:(NSUInteger)index;
- (BOOL)isRootTask;

- (NSString *)getLanguage;
- (void)setLanguage:(NSString *)language;
- (NSString *)getAccessRights;
- (void)setAccessRights:(NSString *)accessRights;
- (BOOL)isWriteProtected;
- (BOOL)isDeleteProtected;
- (NSString *)getUseState;
- (void)setUseState:(NSString *)useState;
- (void)setUseStateBOOL:(BOOL)on;
- (void)setAccessRightsAndCascade:(NSString *)accessRights;
- (BOOL)isActive;

// Functionals
- (BOOL)isFakeIndexed;
- (NSInteger)getFakeIndex;
- (void)setFakeIndex:(NSInteger)fakeIndex;

// DELETING and MOVING
- (BOOL)deleteItself;
- (BOOL)deleteStepAtIndex:(NSUInteger)index;
- (BOOL)moveStepAtIndex:(NSUInteger)srcIndex toIndex:(NSUInteger)dstIndex;

// Steps Navigation
- (NSUInteger)indexOfStep:(ILstep *)step;
- (ILstep *)getFirstActiveStep;
- (ILstep *)getLastActiveStep;
- (ILstep *)getPrevStepInTask:(ILstep *)step;
- (ILstep *)getNextStepInTask:(ILstep *)step;
- (float)computeTaskWeight:(float)weight;
- (void)recusrsCount:(ILtask*)task;
@end

// Unused BE AWARE need some thinking to use properly
//
@interface ILtask (CoreDataGeneratedAccessors)

- (void)insertObject:(ILstep *)value inStepsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromStepsAtIndex:(NSUInteger)idx;
- (void)insertSteps:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeStepsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInStepsAtIndex:(NSUInteger)idx withObject:(ILstep *)value;
- (void)replaceStepsAtIndexes:(NSIndexSet *)indexes withSteps:(NSArray *)values;
- (void)addStepsObject:(ILstep *)value;
- (void)removeStepsObject:(ILstep *)value;
- (void)addSteps:(NSOrderedSet *)values;
- (void)removeSteps:(NSOrderedSet *)values;
@end
