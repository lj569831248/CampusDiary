/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
@class DroiError;

/**
 *  DroiCloudCache provides developer to put/set global temporal data. Developer could use this feature to exchange temporal data between user/device.
 */
@interface DroiCloudCache : NSObject

/**
 *  Get value of cache data by key.
 *
 *  @param key   The key of cache data
 *  @param error Pass DroiError to retrieve error details, or pass nil to ignore.
 *
 *  @return Return the value of cache
 */
+ (NSString*) getValueByKey : (NSString*) key error:(DroiError**) error;

/**
 *  Get value of cache data by key in background.
 *
 *  @param key      The key of cache data
 *  @param callback The callback block. DroiCloudCache would put the value and error before calling this block
 *
 *  @return DroiError object. Developer should use isOk to check whether this result is OK.
 */
+ (DroiError*) getValueByKey : (NSString*) key inBackground:(void (^) (NSString*, DroiError*)) callback;

/**
 *  Set the value of cache data
 *
 *  @param key   The key of cache data
 *  @param value The value of cache data
 *
 *  @return Return DroiError object if there is an error. Otherwise the error code would be DROICODE_OK
 */
+ (DroiError*) setKey : (NSString*) key andValue:(NSString*) value;

/**
 *  Set the value of cache data in background.
 *
 *  @param key      The key of cache data
 *  @param value    The value of cache data
 *  @param callback The callback block. DroiCloudCache would put the error before calling this block
 *
 *  @return DroiError object. Developer should use isOk to check whether this result is OK.
 */
+ (DroiError*) setKey : (NSString*) key andValue:(NSString*) value inBackground:(void (^) (DroiError*) ) callback;

/**
 *  Remove the cache data by key
 *
 *  @param key The key of cache data
 *
 *  @return Return DroiError object if there is an error. Otherwise the error code would be DROICODE_OK
 */
+ (DroiError*) removeKey : (NSString*) key;

/**
 *  Remove the cache data by key in background.
 *
 *  @param key      The key of cache data
 *  @param callback The callback block. DroiCloudCache would put the error before calling this block
 *
 *  @return DroiError object. Developer should use isOk to check whether this result is OK.
 */
+ (DroiError*) removeKey : (NSString*) key inBackground : (void (^) (DroiError*)) callback;
@end
