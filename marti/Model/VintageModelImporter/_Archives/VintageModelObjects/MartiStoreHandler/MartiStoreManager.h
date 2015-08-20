//
//  ILmartiStore.h
//  marti
//
//  Created by Paul Legault Local on 11-12-08.
//  Copyright (c) 2011 Infologique Innovation inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ILstepAudio;
@class ILstepImage;
@class ILstepVideo;
@class ILtaskAudio;
@class ILtaskImage;
@class ILtask;
@class ILstep;
@class ILtasksList;
@class ILgroup;
@class MartiCoreDataStackContext;

@interface MartiStoreManager : NSObject <UIAlertViewDelegate>
{
}

@property (strong, nonatomic) NSMutableOrderedSet *managedStacks;           //List all .marti databases found
@property (strong, nonatomic) NSMutableOrderedSet *adminFakeManagedTasks;
@property (strong, nonatomic) NSMutableOrderedSet *userFakeManagedTasks;
@property (strong, nonatomic) NSString *helpLanguage;

//Singleton
+ (MartiStoreManager*)defaultStore;

// STORES HANDLING
-(void)addMartiDatabaseFromName:(NSString *)dbname;
- (void)detectAllMartiDataBase;
- (MartiCoreDataStackContext *)getDefaultMartiStoreContext;
- (MartiCoreDataStackContext *)getHelpMartiStoreContext;
- (MartiCoreDataStackContext *)getMartiStoreContext:(NSURL *)storeURL;
- (BOOL)createHelpDatabaseIfRequired;
- (BOOL)createNewMartiDatabaseOnlyIfNotExisting;
- (BOOL)createNewMartiDatabaseFromRes;
- (BOOL)createNewMartiDatabaseFromScratch;
//- (NSUInteger)getNumberOfTasksAllowed;

// STORE MODIFICATIONS

//- (BOOL)isMaximumTasksReached;
- (BOOL)canCreateNewTask;
//- (BOOL)isMaximumStepsReached:(NSUInteger)nbSteps;
- (BOOL)canCreateNewStepInTask:(NSUInteger)nbSteps;
- (BOOL)createRootTaskWithSimpleStep;
- (BOOL)duplicateMainTask:(ILtask*)srcTask atIndex:(NSUInteger)index;
- (BOOL)saveDataContext;
//- (BOOL)isFullVersion;

// FAKE MANAGED TASK LIST

//- (NSUInteger)getNumberOfAdminFakeManagedTasks;
//- (NSUInteger)getNumberOfUserFakeManagedTasks;
- (void)resetAdminFakeManagedTasksSet;
- (NSMutableOrderedSet *)adminTasks;
- (void)resetUserFakeManagedTasksSet;
- (NSMutableOrderedSet *)userTasks;
- (void)constructUserFakeTasksList;
- (void)constructAdminFakeTasksList;
- (BOOL)isGroupValidInThisLanguageContext:(ILgroup *)group;
- (BOOL)isTaskValidInThisLanguageContext:(ILtask *)task;
- (BOOL)isLanguageValid:(NSString *)EntityLanguage;
- (void)reOrderAdminFakeTasksListFromIndex:(NSUInteger)index1 orIndex:(NSUInteger)index2;
- (void)reOrderAdminFakeTasksListFromIndex:(NSUInteger)index;


-(void) copyTasksFromDatabaseURL:(NSURL *)sourceURL toDatabaseURL:(NSURL *)destinationURL;
//-(NSURL*) insertTasksOnTemporaryDataBase:(ILtask *)srcTask;
-(void) insertTasksFromDatabaseURL:(NSURL *)sourceURL;
-(void) insertTasksOnDataBase:(ILtask *)srcTask inStore:(NSURL *)url;

//FlashShare
-(void) insertFlashShareTasksOnMainDataBase;
-(NSURL*)addTask:(ILtask *)task inStoreURL:(NSURL *)url;

-(NSURL*)addTaskToFlashShareServerTempDatabase:(Task*)task;

-(NSURL*)addTaskToFlashShareClientTempDatabase:(Task*)task;

-(NSURL*)addTaskToFlashShareSessionTempDatabase:(Task*)task;

//Was storing buffered tasks on a single receiving task(s) transfer on client side
-(void)deleteFlashShareServerTempDatabase;
//Was storing buffered tasks on a single receiving task(s) transfer on client side
-(void)deleteFlashShareClientTempDatabase;

//Was storing all the received tasks on an actual sharing session
-(void)deleteFlashShareSessionTempDatabase;

-(NSMutableOrderedSet*)receivedTasks;
-(NSMutableOrderedSet*)availableTasksForShare;




// DUMPING TOOLS for CORE DATA DEBUGGING
//
#ifdef SUPER_MARTI_DEBUG

void LOOK_OPTIONS(NSPersistentStoreCoordinator *psc);
void LOOK_INSIDE(NSManagedObjectContext *moc);
void DUMP_GROUP(ILgroup *group);
void DUMP_TASKSLIST(ILtasksList *tasksList);
void DUMP_TASK(ILtask *task);
void DUMP_STEP(ILstep *step);
void DUMP_TASKAUDIO(ILtaskAudio *taskAudio);
void DUMP_TASKIMAGE(ILtaskImage *taskImage);
void DUMP_STEPAUDIO(ILstepAudio *stepAudio);
void DUMP_STEPIMAGE(ILstepImage *stepImage);
void DUMP_STEPVIDEO(ILstepVideo *stepVideo);

#endif // SUPER_MARTI_DEBUG

@end


