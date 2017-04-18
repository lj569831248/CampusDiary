/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>

extern NSString* const MainThreadDispatcher;
extern NSString* const BackgroundThreadDispatcher;
extern NSString* const DroiBackgroundThreadDispatcher;

/**
 This is used for task dispatcher of specific thread
 */
@interface DroiTaskDispatcher : NSObject
-(instancetype) init __attribute__((unavailable("init not available")));

#pragma mark - Normal Task
/**
 *  Enqueue the task block to be added to the message queue of DroiTaskDispatcher
 *
 *  @param block The task block that will be executed
 *
 *  @return Returns YES if the task was successfully placed in to the message queue.  Returns NO on failure
 */
- (BOOL) enqueueTask : (void (^)(void)) block;

/**
 *  Enqueue the task block to be added to the message queue of DroiTaskDispatcher with specific name
 *
 *  @param block    The task block that will be executed
 *  @param taskName The specific task name
 *
 *  @return Returns YES if the task was successfully placed in to the message queue.  Returns NO on failure
 */
- (BOOL) enqueueTask : (void (^)(void)) block withName : (NSString*) taskName;

/**
 *  Enqueue the task block to be added to the message queue of DroiTaskDispatcher with delay
 *
 *  @param block The task block that will be executed
 *  @param delayInMillisecond Delay in millisecond
 *
 *  @return Returns YES if the task was successfully placed in to the message queue.  Returns NO on failure
 */
- (BOOL) enqueueTask : (void (^)(void)) block withDelay : (int) delayInMillisecond;

/**
 *  Enqueue the task block to be added to the message queue of DroiTaskDispatcher with specific name with delay
 *
 *  @param block              The task block that will be executed
 *  @param taskName           The specific task name
 *  @param delayInMillisecond Delay in millisecond
 *
 *  @return Returns YES if the task was successfully placed in to the message queue.  Returns NO on failure
 */
- (BOOL) enqueueTask : (void (^)(void)) block withName : (NSString*) taskName andDelay : (int) delayInMillisecond;

#pragma mark - Timer Task
/**
 *  Enqueue the Runnable task to be added to the message queue, to be run after the specified amount of time elapses. The runnable will be run on the thread infinitely until killTask is called by specific task name.
 *
 *  @param block                 The task block that will be executed
 *  @param intervalInMillisecond The interval in milliseconds
 *  @param taskName              The task name
 *
 *  @return Returns YES if the task was successfully placed in to the message queue.  Returns NO on failure
 */
- (BOOL) enqueueTimerTask : (void (^)(void)) block withInterval : (int) intervalInMillisecond andName : (NSString*) taskName;

/**
 *  Kill the task from queue by specific task name
 *
 *  @param taskName The task name
 *
 *  @return Returns YES if the task name is removed from task list; Otherwise is NO.
 */
- (BOOL) killTask : (NSString*) taskName;

/**
 *  Kill all tasks from queue
 *
 *  @return Yes is succeeded; Otherwise is NO.
 */
- (BOOL) killAllTasks;

#pragma mark - State

/**
 *  Check whether there is any task is running
 *
 *  @return YES if there is task is running; Otherwise is NO.
 */
- (BOOL) isRunning;

/**
 *  Check whether there is specific task in queue
 *
 *  @param taskName The task name
 *
 *  @return Yes if there is specific task in queue; Otherwise is NO.
 */
- (BOOL) hasTask : (NSString*) taskName;

/**
 *  The dispatch_queue_t value for this DroiTaskDispatcher
 *
 *  @return dispatch_queue_t value
 */
- (dispatch_queue_t) threadQueue;

/**
 *  Get name of DroiTaskDispatcher
 *
 *  @return The name of DroiTaskDispatcher
 */
- (NSString*) getName;

#pragma mark - Global methods
/**
 *  Get task dispatcher object in current thread. If DroiTaskDispatcher cannot get current dispatcher, currentTaskDispatcher would return main thread.
 *
 *  @return The DroiTaskDispatcher object
 */
+ (DroiTaskDispatcher*) currentTaskDispatcher;

/**
 *  Get task dispatcher object by specific dispatcher name
 *
 *  @param dispatcherName The specific dispatcher name
 *
 *  @return The DroiTaskDispatcher object
 */
+ (DroiTaskDispatcher*) getTaskDispatcher:(NSString*) dispatcherName;

@end
