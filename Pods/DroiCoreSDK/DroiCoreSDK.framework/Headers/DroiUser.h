/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */

#import "DroiObject.h"
#import "DroiError.h"
#import "DroiOAuthProvider.h"
#import "UIKit/UIKit.h"

typedef NS_ENUM(NSUInteger, DroiContactType) {
//    DROICONTACT_EMAIL,
    DROICONTACT_PHONE
};

@class DroiUser;
typedef void(^DroiSignUpCallback)(BOOL result, DroiError* error); // Callback for signup
typedef void(^DroiLoginCallback)(DroiUser* user, DroiError* error); // Callback for login

DroiObjectName(@"_User")
@interface DroiUser : DroiObject

DroiExpose
@property NSString* UserId;  // UserId

DroiExpose
@property (getter=getEmail, setter=setEmail:) NSString* Email; // Email

DroiExpose
@property (getter=getPhoneNum, setter=setPhoneNum:) NSString* PhoneNum; // Phone number

DroiExpose
@property BOOL EmailVerified; // The email had verified

DroiExpose
@property BOOL PhoneNumVerified; // The phone number had verified

DroiExpose
@property BOOL Enabled; // This account is enabled or not.

@property NSString* Password; // Password

#pragma mark - Properties

@property (readonly, getter=getSessionToken) NSString* sessionToken;

#pragma mark - Static Methods
/**
 * Get current login user.
 * @return User with generic DroiUser class type
 */
+ (instancetype) getCurrentUser;
/**
 * Get current login user with class.
 * @param userClazz Custom user class.
 * @return User with generic DroiUser class type
 */
+ (id) getCurrentUserByUserClass:(Class) userClazz;
/**
 * Login user with UserID and Password
 * @param userId UserId
 * @param password Password
 * @param error Pass DroiError to get error code. Pass null to ignore error details.
 * @return User. nil for login fail.
 */
+ (instancetype) login: (NSString*) userId password:(NSString*) password error:(DroiError**) error;
/**
 * Login user with UserId and Password in background thread.
 * @param userId UserId
 * @param password Password
 * @param callback The callback object DroiLoginCallback is used to receive save result.
 * @see DroiLoginCallback
 */
+ (BOOL) loginInBackground:(NSString*) userId password:(NSString*) password callback:(DroiLoginCallback) callback;

/**
 Login user with UserID and Password.
 
 @param userId UserId
 @param password Password
 @param userClazz Custom user class.
 @param error Pass DroiError to get error code. Pass null to ignore error details.
 @return User. nil for login fail.
 */
+ (id) loginByUserClass : (NSString*) userId password:(NSString*) password userClass:(Class) userClazz error:(DroiError**) error;

/**
 Login user with UserID and Password in background thread.

 @param userId UserId
 @param password Password
 @param userClazz Custom user class.
 @param callback The callback object DroiLoginCallback is used to receive save result.
 @return YES for enqueued.
 */
+ (BOOL) loginByUserClassInBackground : (NSString*) userId password:(NSString*) password userClass:(Class) userClazz callback:(DroiLoginCallback) callback;

/**
 Login with OAuth.

 @param provider OAuth provider. Please call [DroiOAuthProvider providerWithType:] to create provider.
 @param callback The callback object DroiLoginCallback is used to receive save result.
 @param userClazz Custom user class.
 @return YES for enqueued.
 */
+ (BOOL) loginWithOAuth :(DroiOAuthProvider*) provider callback:(DroiLoginCallback) callback userClass:(Class) userClazz;

/**
 Login with OAuth

 @param provider OAuth provider. Please call [DroiOAuthProvider providerWithType:] to create provider.
 @param callback The callback object DroiLoginCallback is used to receive save result.
 @return YES for enqueued.
 */
+ (BOOL) loginWithOAuth :(DroiOAuthProvider*) provider callback:(DroiLoginCallback) callback;

/**
 Login with anonymous user.

 @param error Pass DroiError to get error code. Pass null to ignore error details.
 @return User. nil for login fail.
 */
+ (instancetype) loginWithAnonymous:(DroiError**) error;

/**
 Reset user password.

 @param userId UserId
 @param DroiContactType DroiContactType
 @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
+ (DroiError*) resetPasswordWithUserId:(NSString*) userId type:(DroiContactType) type;

/**
 Confirm reset user password with pin code.

 @param userId UserId
 @param pinCode Pin code.
 @param newPassword New user password.
 @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
+ (DroiError*) confirmResetPasswordWithUserId:(NSString*) userId pinCode:(NSString*) pinCode newPassword:(NSString*) newPassword;

#pragma mark - Login/Logout

/**
 Signup with UserID and Password.

 @return DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) signUp;

/**
 Signup with UserID and Password.

 @param callback The callback object DroiSignUpCallback is used to receive save result.
 @return Task id. The task can be cancel via cancelBackgroundTask:
 */
- (NSString*) signUpInBackground:(DroiSignUpCallback) callback;

/**
 Signup with OAuth provider

 @param provider OAuth provider. Please call [DroiOAuthProvider providerWithType:] to create provider.
 @param callback The callback object DroiObjectCallback is used to receive save result.
 @return YES for enqueued.
 */
- (BOOL) signUpOAuth:(DroiOAuthProvider*) provider callback:(DroiObjectCallback) callback;

/**
 Cancel background task

 @param taskId Task id.
 */
- (void) cancelBackgroundTask : (NSString*) taskId;

/**
 Logout current user.

 @return DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) logout;

/**
 Logout in background thread.

 @param callback The callback object DroiObjectCallback is used to receive save result.
 @return Yes for enqueued.
 */
- (BOOL) logoutInBackground:(DroiObjectCallback) callback;

/**
 Change user password.

 @param oldPassword Old password.
 @param newPassword New password.
 @return DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) changePassword:(NSString*) oldPassword newPassword:(NSString*) newPassword;

/**
 Change user password in background thread.

 @param oldPassword Old password.
 @param newPassword New password.
 @param callback The callback object DroiObjectCallback is used to receive save result.
 @return YES for enqueued.
 */
- (BOOL) changePasswordInBackground:(NSString*) oldPassword newPassword:(NSString*) newPassword callback:(DroiObjectCallback) callback;

#pragma mark - OAuth bind/unbind

/**
 Bind OAuth to current logged in user.

 @param provider OAuth provider. Please call [DroiOAuthProvider providerWithType:] to create provider.
 @param callback The callback object DroiObjectCallback is used to receive save result.
 @return YES for enqueued.
 */
- (BOOL) bindOAuth:(DroiOAuthProvider*) provider callback:(DroiObjectCallback) callback;
/**
 Unbind OAuth to current logged in user.
 
 @param provider OAuth provider. Please call [DroiOAuthProvider providerWithType:] to create provider.
 @param callback The callback object DroiObjectCallback is used to receive save result.
 @return YES for enqueued.
 */
- (BOOL) unbindOAuth:(DroiOAuthProvider*) provider callback:(DroiObjectCallback) callback;

#pragma mark - Save methods
- (DroiError*) save;
- (NSString*) saveInBackground:(DroiObjectCallback)callback;
- (void) saveEventually;

#pragma mark - Status

/**
 Get AutoAnonymousUserEnable state.

 @return YES to enabled.
 */
+ (BOOL) autoAnonymousUser;

/**
 To save data to cloud, the action must send with valid login user. Will auto login with anonymous user if not login before when saving data.

 @param autoAnonymousUser YES to enable.
 */
+ (void) setAutoAnonymousUser:(BOOL) autoAnonymousUser;
- (BOOL) isEmailVerified; // Is the email verified
- (BOOL) isAuthorized; // Is the current user logged in
- (BOOL) isLoggedIn; // Is the current user logged in
- (BOOL) isAnonymous; // Is the current user Anonymous.

#pragma mark - Validation

/**
 * Validate user email.
 *
 * @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) validateEmail;


/**
 Validate user email in background thread.

 @param callback The callback object DroiObjectCallback is used to receive save result.
 @return YES to enqueued.
 */
- (BOOL) validateEmailInBackground:(DroiObjectCallback) callback;

/**
 * Validate user phone number.
 *
 * @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) validatePhoneNumber;

/**
 Validate user phone number in background thread.

 @param callback The callback object DroiObjectCallback is used to receive save result.
 @return YES to enqueued.
 */
- (BOOL) validatePhoneNumberInBackground:(DroiObjectCallback) callback;

/**
 * Confirm pin code sent to user phone.
 *
 * @param pinCode Pin code
 *
 * @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) confirmPhoneNumberPinCode:(NSString*) pinCode;

/**
 Confirm pin code sent to user phone.

 @param pinCode Pin code.
 @param callback The callback object DroiObjectCallback is used to receive save result.
 @return YES to enqueued.
 */
- (BOOL) confirmPhoneNumberPinCodeInBackground:(NSString*) pinCode callback:(DroiObjectCallback) callback;

/**
 * Refersh EmailVerified / PhoneNumVerified field status. After refreshed, check verification via isEmailVerified or isPhoneNumVerified.
 *
 * @return YES to successfully refreshed.
 */
- (BOOL) refreshValidationStatus;

/**
 * Refersh EmailVerified / PhoneNumVerified field status in the background thread. After refreshed, check verification via isEmailVerified or isPhoneNumVerified.
 *
 * @param callback Callback
 *
 * @return YES to successfully push to background task to execute.
 */
- (BOOL) refreshValidationStatusInBackground:(DroiObjectCallback) callback;
@end
