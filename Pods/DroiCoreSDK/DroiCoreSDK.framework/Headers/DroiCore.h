/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    DroiBaaS_LOG_VERBOSE = 2,
    DroiBaaS_LOG_DEBUG,
    DroiBaaS_LOG_INFO,
    DroiBaaS_LOG_WARN,
    DroiBaaS_LOG_ERROR,
    DroiBaaS_LOG_DISABLE_ALL_LOGS
} DroiBaaSLogLevel;

#pragma mark - Droi SDK definitions

/**
 *  DoireCore provides methods to get version, Droi AppId, Platform Id and Channel information. Developer should use initializeCore to setup Droi Core SDK environment.
 */
@interface DroiCore : NSObject

/**
 *  Initiate Droi Open Platform
 *
 *  @return YES - Initiate Droi Core SDK succeeded; Otherwise is NO
 */
+ (BOOL) initializeCore;

/**
 *  Get version of Droi Core SDK
 *
 *  @return Version of Droi Core SDK
 */
+ (NSString*) getCoreServiceVersion;

/**
 *  Get Droi App Id from apps bundle
 *
 *  @return Current App Id
 */
+ (NSString*) getDroiAppId;

/**
 *  Get device id
 *
 *  @return Device id
 */
+ (NSString*) getDroiDeviceId;

/**
 *  Get Droi Platform Id from plist file
 *
 *  @return PlatformId
 */
+ (NSString*) getDroiPlatformId;

/**
 *  Get Channel name which defines in apps bundle
 *
 *  @return Channel name
 */
+ (NSString*) getChannelName;

/**
 Set DroiBaaS log level to adjust output logs.

 @param level Log level.
 */
+ (void) setDroiBaaSLogLevel:(DroiBaaSLogLevel) level;
+ (NSDate*) getTimestamp;
@end
