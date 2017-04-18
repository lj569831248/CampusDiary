/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */
#import "DroiObject.h"
#import "DroiError.h"

typedef void(^DroiGetGroupCallback)(NSArray* result, DroiError* error);

DroiObjectName(@"_Group")
@interface DroiGroup : DroiObject

DroiExpose
/**
 *  Group Name
 */
@property NSString* Name;

DroiExpose
/**
 Groups that belongs in this group
 */
@property NSArray* Groups;

DroiExpose
/**
 Users that belongs in this group
 */
@property NSArray* Users;

/**
 *  The users and sub groups will not default fetched after queried. Must call @ref fetch to retrieve users and sub groups
 */
@property BOOL isReady;

/**
 *  Create instance with name
 *
 *  @param name Name
 *
 *  @return DroiGroup instance
 */
+ (instancetype) groupWithName:(NSString*) name;

#pragma mark - Constructor

/**
 init with group name

 @param name Group name
 @return instance
 */
- (id) initWithName : (NSString*) name;

#pragma mark - Static Methods

/**
 Find all groups that user belonged.

 @param objectId User object id
 @param error DroiError object. Developer should use isOk to check whether this result is OK.
 @return Groups array
 */
+ (NSArray*) getGroupIdsByUserObjectId:(NSString*) objectId error:(DroiError**) error;

/**
 FInd all groups that group belonged.

 @param objectId Group object id
 @param error DroiError object. Developer should use isOk to check whether this result is OK.
 @return Groups array
 */
+ (NSArray*) getGroupIdsByGroupObjectId:(NSString*) objectId error:(DroiError**) error;

/**
 Find all groups that user belonged in background.

 @param objectId User object id.
 @param callback Callback for result.
 @return YES for successfully enqueued.
 */
+ (BOOL) getGroupIdsByUserObjectIdInBackground:(NSString*) objectId callback:(DroiGetGroupCallback) callback;

/**
 Find all groups that group belonged in background.

 @param objectId Group object id.
 @param callback Callback for result.
 @return YES for successfully enqueued.
 */
+ (BOOL) getGroupIdsByGroupObjectIdInBackground:(NSString*) objectId callback:(DroiGetGroupCallback) callback;

#pragma mark - Public Methods
/**
 *  All users in this group
 *
 *  @return All user id in this group
 */
- (NSArray*) getUserIdList;

/**
 *  All sub groups in this group
 *
 *  @return Sub groups in this group
 */
- (NSArray*) getGroupIdList;

/**
 *  Add user to this group
 *
 *  @param userId User id, Call @ref DroiObject.objectId to fetch User id
 *
 *  @return YES to success.
 */
- (BOOL) addUser : (NSString*) userId;

/**
 *  Remove user from this group
 *
 *  @param userId User id, Call @ref DroiObject.objectId to get User id
 */
- (void) removeUser : (NSString*) userId;

/**
 *  Add sub group to this group
 *
 *  @param groupId Group id, Call {@link DroiGroup#getObjectId()} to get group id
 *
 *  @return YES to success
 */
- (BOOL) addGroup : (NSString*) groupId;

/**
 *  Remove sub group from this group
 *
 *  @param groupId groupId Group id, Call @ref DroiObject.objectId to get group id
 */
- (void) removeGroup : (NSString*) groupId;


/**
 *  Retrieve all users and sub group belong this group.
 */
- (DroiError*) fetchRelation;

/**
 *  Retrieve all users and sub group belong this group in background process. The call will be executed in background thread.
 *
 *  @param callback Result callback
 */
- (BOOL) fetchRelationInBackground : (void(^)(BOOL)) callback;


@end
