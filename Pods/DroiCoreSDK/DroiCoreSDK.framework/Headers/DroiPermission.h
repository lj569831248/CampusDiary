/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */


#import <Foundation/Foundation.h>

#define PERMISSION_READ 2
#define PERMISSION_WRITE 1

/**
 *  Control DroiObject and extened class data permission
 */
@interface DroiPermission : NSObject

@property NSString* creator;

#pragma mark - Default Permission
/**
 *  Get default permission.
 *
 *  @return permission.
 */
+ (instancetype) getDefaultPermission;

/**
 Copy from permission

 @param permission permission
 @return permission
 */
+ (instancetype) permissionCopyFrom:(DroiPermission*) permission;

/**
 *  Set default permission.
 *
 *  @param permission permission.
 */
+ (void) setDefaultPermission : (DroiPermission*) permission;

#pragma mark - User/Group Read/Write Permission
/**
 *  Set user read permission.
 *
 *  @param userId  user object id.
 *  @param enabled enabled or disabled.
 */
- (void) setUserReadPermission:(NSString*) userId flag:(BOOL) enabled;
/**
 *  Set user write permission.
 *
 *  @param userId  user object id.
 *  @param enabled enabled or disabled.
 */
- (void) setUserWritePermission:(NSString*) userId flag:(BOOL) enabled;
/**
 *  Set group read permission.
 *
 *  @param groupId  group object id.
 *  @param enabled enabled or disabled.
 */
- (void) setGroupReadPermission:(NSString*) groupId flag:(BOOL) enabled;
/**
 *  Set group write permission.
 *
 *  @param groupId  group object id.
 *  @param enabled enabled or disabled.
 */
- (void) setGroupWritePermission:(NSString*) groupId flag:(BOOL) enabled;

/**
 *  Set public users read permission.
 *
 *  @param enabled enabled or disabled.
 */
- (void) setPublicReadPermission:(BOOL) enabled;

/**
 *  Set public users write permission.
 *
 *  @param enabled enabled or disabled.
 */
- (void) setPublicWritePermission:(BOOL) enabled;


#pragma mark - Serialization/Deserialization
/**
 *  Serialize to json object.
 *
 *  @return json object.
 */
- (NSDictionary*) toJson;
/**
 *  Diserialized from json object.
 *
 *  @param json json object.
 *
 *  @return `DroiPermission`
 */
+ (instancetype) fromJson:(NSDictionary*) json;
@end
