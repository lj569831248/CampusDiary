/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */

#import "DroiObject.h"
#import "DroiError.h"

typedef NS_ENUM(NSUInteger, DroiCloudMethod) {
    DROIMETHOD_GET, DROIMETHOD_HEAD, DROIMETHOD_POST, DROIMETHOD_PUT, DROIMETHOD_PATCH, DROIMETHOD_DELETE, DROIMETHOD_TRACE, DROIMETHOD_OPTIONS
};

/**
 *  Callback method for background task
 *
 *  @param result The callback result. This data type should be DroiObject extension
 *  @param error Error details.
 */
typedef void(^DroiCloudCallback)(id result, DroiError* error);

/**
 *  The DroiCloud class is used to call Droi Cloud Service. Developer would use this class to call specific cloud service.
 */
@interface DroiCloud : NSObject
/**
 *  Calls a cloud service by specific name with parameters
 *
 *  @param name      Service name
 *  @param parameter Parameter object. Must be inherited from `DroiObject`
 *  @param clazz     Output object class type. Must be inherited from `DroiObject`
 *  @param error     Pass DroiError to retrieve error details, or pass nil to ignore.
 *
 *  @return Result DroiObject.
 */
+ (id) callCloudService : (NSString*) name parameter : (DroiObject*) parameter andClassType : (Class) clazz error:(DroiError**) error;

/**
 *  Calls a cloud service by specific name with parameters in background thread
 *
 *  @param name      Service name
 *  @param parameter Parameter object. Must be inherited from `DroiObject`
 *  @param callback  The procedure block for callback
 *  @param clazz     Output object class type. Must be inherited from `DroiObject`
 *
 *  @return The taskId of background task
 */
+ (NSString*) callCloudServiceInBackground : (NSString*) name parameter : (DroiObject*) parameter andCallback : (DroiCloudCallback) callback withClassType : (Class) clazz;


/**
 Call cloud REST api.

 @param apiKey ApiKey for REST api
 @param apiPath REST api full path
 @param method DroiCloudMethod
 @param parameter Parameter object. Must be inherited from `DroiObject`
 @param clazz Output object class type. Must be inherited from `DroiObject`
 @param error Pass DroiError to retrieve error details, or pass nil to ignore.
 @return Result DroiObject.
 */
+ (id) callRestApi : (NSString*) apiKey apiPath:(NSString*) apiPath method:(DroiCloudMethod) method parameter: (DroiObject*) parameter andClassType : (Class) clazz error:(DroiError**) error;

/**
 Call cloud REST api.
 
 @param apiKey ApiKey for REST api
 @param apiPath REST api full path
 @param method DroiCloudMethod
 @param parameter Parameter string
 @param error Pass DroiError to retrieve error details, or pass nil to ignore.
 @return Result json string
 */
+ (NSString*) callRestApi : (NSString*) apiKey apiPath:(NSString*) apiPath method:(DroiCloudMethod) method parameter: (NSString*) parameter error:(DroiError**) error;


/**
 Call cloud REST api in background.

 @param apiKey ApiKey for REST api
 @param apiPath REST api full path
 @param method DroiCloudMethod
 @param parameter Parameter object. Must be inherited from `DroiObject`
 @param callback The procedure block for callback
 @param clazz Output object class type. Must be inherited from `DroiObject`
 @return The taskId of background task
 */
+ (NSString*) callRestApiInBackground : (NSString*) apiKey apiPath:(NSString*) apiPath method:(DroiCloudMethod) method parameter: (DroiObject*) parameter andCallback : (DroiCloudCallback) callback withClassType : (Class) clazz;

/**
 Call cloud REST api in background.
 
 @param apiKey ApiKey for REST api
 @param apiPath REST api full path
 @param method DroiCloudMethod
 @param parameter Parameter string
 @param callback The procedure block for callback
 @return The taskId of background task
 */
+ (NSString*) callRestApiInBackground : (NSString*) apiKey apiPath:(NSString*) apiPath method:(DroiCloudMethod) method parameter: (NSString*) parameter andCallback : (DroiCloudCallback) callback;

@end
