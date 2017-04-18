/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */
#import <Foundation/Foundation.h>

/**
 *  DroiTask for DroiTaskDispatcher. DroiTask provides more powerful feature for multithread programming
 */
@interface DroiTask : NSObject

/**
*  The DroiTask object will be called after previous task is completed
*
*  @param block The task block for DroiTaskDispatcher
*
*  @return The DroiTask object
*/
- (DroiTask*) then : (void (^)(DroiTask* taskObject)) block;

/**
 *  Delay specific time for next task
 *
 *  @param millisecond Delay time in millisecond
 *
 *  @return The DroiTask object
 */
- (DroiTask*) delay : (int) millisecond;

/**
 *  Assign a callback block which will be called in specific dispatcher after all tasks are completed
 *
 *  @param callback       The callback block
 *  @param dispatcherName The specific dispatcher
 *
 *  @return The DroiTask object
 */
- (DroiTask*) callback : (void (^)(DroiTask* taskObject)) callback inDispatcher : (NSString*) dispatcherName;

/**
 *  Assign a callback block which will be called in current thread after all tasks are completed
 *
 *  @param callback The callback block
 *
 *  @return The DroiTask object
 */
- (DroiTask*) callback : (void (^)(DroiTask* taskObject)) callback;

/**
 *  Run all task blocks in specific dispatcher
 *
 *  @param dispatcherName The specific dispatcher
 *
 *  @return The DroiTask object
 */
- (BOOL) runInBackground : (NSString*) dispatcherName;

/**
 *  Run all task blocks in specific dispatcher and wait all task blocks are completed.
 *
 *  @param dispatcherName The specific dispatcher
 *
 *  @return The DroiTask object
 */
- (BOOL) runAndWait : (NSString*) dispatcherName;

/**
 *  Wait all task blocks are completed.
 *
 *  @return The DroiTask object
 */
- (BOOL) waitTask;

/**
 *  Cancel current running task
 *
 *  @return YES is succeeded; Otherwise is NO
 */
- (BOOL) cancel;

/**
 *  Reset all states for reuse this DroiTask object
 */
- (void) resetState;

/**
 *  Create DroiTask object for DroiTaskDispatcher
 *
 *  @param block The task block for DroiTaskDispatcher
 *
 *  @return The DroiTask object
 */
+ (DroiTask*) create : (void (^)(DroiTask* taskObject)) block;

/**
 *  Check whether this task is cancelled
 */
@property (readonly) BOOL isCancelled;

/**
 *  Check whether this task is completed
 */
@property (readonly) BOOL isCompleted;

/**
 *  Check whether this task is running
 */
@property (readonly) BOOL isRunning;

-(instancetype) init __attribute__((unavailable("init not available")));
@end
