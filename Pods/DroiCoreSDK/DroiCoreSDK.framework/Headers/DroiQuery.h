/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "DroiObject.h"
#import "DroiCondition.h"
#import "DroiError.h"

/**
 *  The callback is used for DroiQuery
 *
 *  @param result The query result
 *  @param err DroiError object. Developer should use isOk to check whether this result is OK.
 */
typedef void(^DroiQueryCallback)(NSArray* result, DroiError* err);


/**
 The callback used in countInBackground

 @param count data count.
 @param err DroiError object. Developer should use isOk to check whether this result is OK.
 */
typedef void(^DroiQueryCountCallback)(NSInteger count, DroiError* err);

#ifndef DroiQueryAnnotation
#define DroiQueryAnnotation
#endif

#pragma mark - Query Constants
FOUNDATION_EXPORT NSString* const DroiQuery_LOCALSTORAGE;
FOUNDATION_EXPORT NSString* const DroiQuery_CLOUDSTORAGE;

FOUNDATION_EXPORT NSString* const DroiQuery_SELECT;
FOUNDATION_EXPORT NSString* const DroiQuery_INSERT;
FOUNDATION_EXPORT NSString* const DroiQuery_DELETE;
FOUNDATION_EXPORT NSString* const DroiQuery_UPDATE;
FOUNDATION_EXPORT NSString* const DroiQuery_UPDATE_DATA;
FOUNDATION_EXPORT NSString* const DroiQuery_COUNT;

FOUNDATION_EXPORT NSString* const DroiQuery_WHERE;
FOUNDATION_EXPORT NSString* const DroiQuery_COND;
FOUNDATION_EXPORT NSString* const DroiQuery_VALUES;
FOUNDATION_EXPORT NSString* const DroiQuery_OR;
FOUNDATION_EXPORT NSString* const DroiQuery_AND;

FOUNDATION_EXPORT NSString* const DroiQuery_ORDERBY;

FOUNDATION_EXPORT NSString* const DroiQuery_INC;
FOUNDATION_EXPORT NSString* const DroiQuery_DEC;
FOUNDATION_EXPORT NSString* const DroiQuery_SET;

FOUNDATION_EXPORT NSString* const DroiQuery_LIMIT;
FOUNDATION_EXPORT NSString* const DroiQuery_OFFSET;

FOUNDATION_EXPORT NSString* const DroiQuery_ASC;
FOUNDATION_EXPORT NSString* const DroiQuery_DESC;


/**
 *  The DroiQuery class defines a query that is used to query DroiObject. 
 */
@interface DroiQuery : NSObject

#pragma mark - Run Query Task
/**
 *  Execute DroiQuery to query data
 *
 *  @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) run;

/**
 *  Execute DroiQuery to query data in background
 *
 *  @param callback The DroiQueryCallback block. DroiQuery would put the query result before calling this block
 *
 *  @return The taskId of background task
 */

- (NSUInteger) runInBackground : (DroiObjectCallback) callback;


/**
 Query data count.

 @param error Pass DroiError to get error code. Pass nil to ignore error details.
 @return Data count
 */
- (NSInteger) count:(DroiError**) error;


/**
 Query data count in background task.

 @param callback The DroiQueryCountCallback block. DroiQuery would put the query result before calling this block
 @return The taskId of background task
 */
- (NSUInteger) countInBackground: (DroiQueryCountCallback) callback;

/**
 *  Execute DroiQuery to query data
 *
 *  @param error Pass DroiError to get error code. Pass nil to ignore error details.
 *
 *  @return The query result.
 */
- (NSArray*) runQuery:(DroiError**) error;

/**
 *  Execute DroiQuery to query data in background
 *
 *  @param callback The DroiQueryCallback block. DroiQuery would put the query result before calling this block
 *
 *  @return The taskId of background task
 */
- (NSUInteger) runQueryInBackground : (DroiQueryCallback) callback;

/**
 *  Cancel a background task by taskId
 *
 *  @param taskId The taskId of background task
 */
+ (void) cancelTask : (NSUInteger) taskId;

#pragma mark - Condition builder
/**
 *  Set this query is for local storage
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) localStorage;

/**
 *  The this query is for cloud storage
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) cloudStorage;

/**
 *  Query data from specific name
 *
 *  @param fromName The specific name
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) queryByName : (NSString*) fromName;

/**
 *  Query data from specific class
 *
 *  @param clazz The specific class
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) queryByClass : (Class) clazz;

/**
 *  Delete all data from specific class
 *
 *  @param clazz The specific class
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) deleteByClass : (Class) clazz;

/**
 *  Update all data from specific class
 *
 *  @param clazz The specific class
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) updateByClass : (Class) clazz;

/**
 *  Increase data by specific key
 *
 *  @param arg1 The increasing key name
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) inc : (NSString*) arg1;

/**
 *  Decrease data by specific key
 *
 *  @param arg1 The decreasing key name
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) dec : (NSString*) arg1;

/**
 *  Set specific key data to value
 *
 *  @param arg1 The key name
 *  @param value The updating data
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) set : (NSString*) arg1 withValue:(id) value;

/**
 *  Add a condition for this query
 *
 *  @param arg1   The key of condition to check
 *  @param opType The condition type.
 *  @param arg2   The value is for checking
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) whereStatement : (NSString*) arg1 opType : (NSString*) opType arg2 : (NSString*) arg2;

/**
 *  Add a condition for this query
 *
 *  @param cond The new DroiCondition object
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) whereStatement : (DroiCondition*) cond;

/**
 *  Sort the query result by given value
 *
 *  @param arg           The sort key
 *  @param ascendingSort Determine whether the ascending sort
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) orderBy : (NSString*) arg ascending : (BOOL) ascendingSort;

/**
 *  The maximum number of query result
 *
 *  @param limitSize The maximum number of query result. Default number is 1000
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) limit : (int) limitSize;

/**
 *  The query result starting at specific offset
 *
 *  @param position The specific offset
 *
 *  @return The DroiQuery object
 */
- (DroiQuery*) offset : (int) position;
#pragma mark -

#pragma mark - Creation
/**
 *  Constructor the DroiQuery object
 *
 *  @return The DroiQuery object
 */
+ (instancetype) create;
@end
