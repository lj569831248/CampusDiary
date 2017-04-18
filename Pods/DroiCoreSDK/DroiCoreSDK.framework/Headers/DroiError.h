/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, DroiErrorCode) {
    // General group
    DROICODE_OK = 0,
    DROICODE_UNKNOWN_ERROR = 1070000,
    DROICODE_ERROR = 1070001,
    DROICODE_USER_NOT_EXISTS = 1070002,
    DROICODE_USER_PASSWORD_INCORRECT = 1070003,
    DROICODE_USER_ALREADY_EXISTS = 1070004,
    DROICODE_NETWORK_NOT_AVAILABLE = 1070005,
    DROICODE_USER_NOT_AUTHORIZED = 1070006,
    DROICODE_SERVER_NOT_REACHABLE = 1070007,
    DROICODE_HTTP_SERVER_ERROR = 1070008,
    DROICODE_SERVICE_NOT_ALLOWED = 1070009,
    DROICODE_SERVICE_NOT_FOUND = 1070010,
    DROICODE_INTERNAL_SERVER_ERROR = 1070011,
    DROICODE_INVALID_PARAMETER = 1070012,
    DROICODE_NO_PERMISSION = 1070013,
    DROICODE_USER_DISABLE = 1070014,
    DROICODE_EXCEED_MAX_SIZE = 1070015,
    DROICODE_FILE_NOT_READY = 1070016,
    DROICODE_CORE_NOT_INITIALIZED = 1070017,
    DROICODE_USER_CANCELED = 1070018,
    DROICODE_BANDWIDTH_LIMIT_EXCEED = 1070019,
    
    
    // Not allowed call this function from mainthread = 1070004
    DROICODE_APPLICATION_ID_UNCORRECTED = 1070101,
    
    // Network group
    DROICODE_TIME_UNCORRECTED = 1070201,
    DROICODE_TIMEOUT = 1070202,
    
    // Users group
    DROICODE_USER_ALREADY_LOGIN = 1070301,
    DROICODE_USER_CONTACT_HAD_VERIFIED = 1070302,
    DROICODE_USER_CONTACT_EMPTY = 1070303,
    DROICODE_USER_FUNCTION_NOT_ALLOWED = 1070304,
    
    // DroiObject / DroiQuery
    DROICODE_READ_CACHE_FILE_FAILED = 10700501,
    DROICODE_UPLOAD_FILE_FAILED = 1070502, // Upload file failed
    
};

/**
 *  This class represents all error code.
 */
@interface DroiError : NSObject<NSCopying>

/**
 *  Error Code. See DroiErrorCode
 */
@property (readonly) DroiErrorCode code;

/**
 *  Ticket ID for this error code
 */
@property (readonly) NSString* ticket;

/**
 *  Check whether the error is OK
 */
@property (readonly) BOOL isOk;

/**
 *  Error description
 */
@property (readonly, getter=getMessage) NSString* message;

+ (instancetype) errorWithCode:(DroiErrorCode) code ticket:(NSString*) ticket;
+ (instancetype) errorWithCode:(DroiErrorCode) code ticket:(NSString*) ticket appendedMessage:(NSString*) message;
@end
