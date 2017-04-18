/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "DroiObject.h"

typedef NS_ENUM(int, AuthType) {
    AUTH_TYPE_QQ,
    AUTH_TYPE_SINA,
    AUTH_TYPE_WEIXIN,
    AUTH_TYPE_FACEBOOK
};

@interface DroiOAuthProvider : NSObject
/**
 * Create AuthProvider for 3rd party login.
 *
 * @param type AuthType
 * @return return DroiOAuthProvider.
 */
+ (instancetype) providerWithType:(AuthType) type;

/**
 * Call this function in AppDelegate.openUrl & APpDelegate.handleOpenUrl
 */
+ (BOOL) handleOpenUrl:(NSURL*) url sourceApplication:(NSString*) sourceApplication annotation:(id) annotation;

/**
 * When you change OAuth AppId/SecureKey in Droi Developer Web platform, need to call this api to fetch OAuth data.
 */
+ (BOOL) fetchOAuthKeysInBackground:(DroiObjectCallback) callback;

/**
 * When you change OAuth AppId/SecureKey in Droi Developer Web platform, need to call this api to fetch OAuth data.
 */
+ (DroiError*) fetchOAuthKeys;

/**
 * Internal use.
 */
+ (BOOL) registerProviderType:(AuthType) type class:(Class) clazz;
/**
 * Internal use.
 */

- (BOOL) handleOpenUrl:(NSURL*) url sourceApplication:(NSString*) sourceApplication annotation:(id) annotation;
/**
 * User id. Please assign user id when unbinding OAuth.
 */
@property NSString* userId;
/**
 * User password. Please assign user password when unbinding OAuth.
 */
@property NSString* password;
/**
 * OAuth account unique id
 */
@property (readonly) NSString* id;
/**
 * Weixin OAuth code.
 */
@property (readonly) NSString* code;
/**
 * OAuth account accessToken;
 */
@property (readonly) NSString* accessToken;
/**
 * OAuthProvider name
 */
@property (readonly, getter=getProviderName) NSString* name;
/**
 * OAuthProvider version
 */
@property (readonly, getter=getProviderVersion) NSString* providerVersion;
@end
