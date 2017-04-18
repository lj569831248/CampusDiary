/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "DroiObject.h"
#import "DroiError.h"

#define MAX_AVAILABLE_FILE_SIZE 14680064

/**
 *  Callback definition for `getInBackground:` or `getInBackground:progressCallback:`
 *
 *  @param data Get file result
 *  @param error Error details.
 */
typedef void(^DroiGetFileCallback)(NSData* data, DroiError* error);

/**
 *  Progressive callback for `getInBackground:progressCallback:`
 *
 *  @param current current uploaded size
 *  @param max     file size
 */
typedef void(^DroiFileProgressCallback)(long current, long max);

/**
 *  getUrlInBackground callback.
 *
 *  @param url File url.
 */
typedef void(^DroiFileGetUrlCallback)(NSURL* url);

/**
 *  getUrlWithFlagInBackground callback.
 *
 *  @param url     File url.
 *  @param isLocal true for local url.
 */
typedef void(^DroiFileGetUrlWithFlagCallback)(NSURL* url, BOOL isLocal);

/**
 *  Be able upload/download file to DroiCloud with DroiFile.
 */
DroiObjectName(@"_File")
@interface DroiFile : DroiObject
/**
 *  Construct `DroiFile` with file path.
 *
 *  @param filePath File path.
 *
 *  @return `DroiFile`
 */
+ (instancetype) fileWithFilePath:(NSString*) filePath;

/**
 *  Construct `DroiFile` with file path and mime type.
 *
 *  @param filePath File path.
 *  @param mimeType File mime type.
 *
 *  @return `DroiFile`
 */
+ (instancetype) fileWithFilePath:(NSString*) filePath mimeType:(NSString*) mimeType;
/**
 *  Construct `DroiFile` with data and name.
 *
 *  @param data data
 *  @param name name
 *
 *  @return `DroiFile`
 */
+ (instancetype) fileWithData:(NSData*) data name:(NSString*) name;
/**
 *  Construct `DroiFile` with data
 *
 *  @param data data
 *
 *  @return `DroiFile`
 */
+ (instancetype) fileWithData:(NSData*) data;
/**
 *  Construct `DroiFile` with data and mime type.
 *
 *  @param data     data
 *  @param mimeType mime type.
 *
 *  @return `DroiFile`
 */
+ (instancetype) fileWithData:(NSData*) data mimeType:(NSString*) mimeType;
/**
 *  Construct `DroiFile` with data and name and mime type.
 *
 *  @param data     data
 *  @param name     name
 *  @param mimeType mime type.
 *
 *  @return `DroiFile`
 */
+ (instancetype) fileWithData:(NSData*) data name:(NSString*) name mimeType:(NSString*) mimeType;

/**
 *  Synchronously get file data from cache if available or fetches from the network.
 *
 *  @param error     Pass DroiError to retrieve error details, or pass nil to ignore.
 *
 *  @return NSData for file content.
 */
- (NSData*) get:(DroiError**) error;

/**
 *  Get file data from cache if available or fetches from the network in the background.
 *
 *  @param callback Callback when done.
 */
- (NSString*) getInBackground:(DroiGetFileCallback) callback;
/**
 *  Get file data from cache if available or fetches from the network in the background.
 *
 *  @param callback         Callback when done.
 *  @param progressCallback Progress callback.
 */
- (NSString*) getInBackground:(DroiGetFileCallback) callback progressCallback:(DroiFileProgressCallback) progressCallback;
/**
 *  Save file data to cloud storage in the background thread.
 *
 *  @param callback         Callback when done.
 *  @param progressCallback Progress callback.
 */
- (NSString*) saveInBackground:(DroiObjectCallback) callback progressCallback:(DroiFileProgressCallback) progressCallback;
/**
 *  Update file. Will remove old file after successfuly updated.
 *
 *  @param filePath File path.
 *
 *  @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) updateFilePath:(NSString*) filePath;
/**
 *  Update file. Will remove old file after successfuly updated.
 *
 *  @param filePath File path.
 *  @param mimeType File mime type.
 *
 *  @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) updateFilePath:(NSString*) filePath mimeType:(NSString*) mimeType;
/**
 *  Update file. Will remove old file after successfuly updated.
 *
 *  @param data data
 *  @param name name
 *
 *  @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) updateData:(NSData*) data name:(NSString*) name;
/**
 *  Update file. Will remove old file after successfuly updated.
 *
 *  @param data data
 *
 *  @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) updateData:(NSData*) data;
/**
 *  Update file. Will remove old file after successfuly updated.
 *
 *  @param data     data
 *  @param mimeType mime type.
 *
 *  @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) updateData:(NSData*) data mimeType:(NSString*) mimeType;
/**
 *  Update file. Will remove old file after successfuly updated.
 *
 *  @param data     data
 *  @param name     name
 *  @param mimeType mime type.
 *
 *  @return DroiError DroiError object. Developer should use isOk to check whether this result is OK.
 */
- (DroiError*) updateData:(NSData*) data name:(NSString*) name mimeType:(NSString*) mimeType;
/**
 *  Update file in background thread. Will remove old file after successfuly updated.
 *
 *  @param filePath File path.
 *  @param callback The callback object `DroiObjectCallback` is used to receive save result.
 *
 *  @return taskId for calling the task.
 */
- (NSString*) updateFilePathInBackground:(NSString*) filePath callback:(DroiObjectCallback) callback;
/**
 *  Update file in background thread. Will remove old file after successfuly updated.
 *
 *  @param filePath File path.
 *  @param mimeType File mime type.
 *  @param callback The callback object `DroiObjectCallback` is used to receive save result.
 *
 *  @return taskId for calling the task.
 */
- (NSString*) updateFilePathInBackground:(NSString*) filePath mimeType:(NSString*) mimeType callback:(DroiObjectCallback) callback;
/**
 *  Update file in background thread. Will remove old file after successfuly updated.
 *
 *  @param data data
 *  @param name name
 *  @param callback The callback object `DroiObjectCallback` is used to receive save result.
 *
 *  @return taskId for calling the task.
 */
- (NSString*) updateDataInBackground:(NSData*) data name:(NSString*) name callback:(DroiObjectCallback) callback;
/**
 *  Update file in background thread. Will remove old file after successfuly updated.
 *
 *  @param data data
 *  @param callback The callback object `DroiObjectCallback` is used to receive save result.
 *
 *  @return taskId for calling the task.
 */
- (NSString*) updateDataInBackground:(NSData*) data callback:(DroiObjectCallback) callback;
/**
 *  Update file in background thread. Will remove old file after successfuly updated.
 *
 *  @param data     data
 *  @param mimeType mime type.
 *  @param callback The callback object `DroiObjectCallback` is used to receive save result.
 *
 *  @return taskId for calling the task.
 */
- (NSString*) updateDataInBackground:(NSData*) data mimeType:(NSString*) mimeType callback:(DroiObjectCallback) callback;

/**
 *  Update file in background thread. Will remove old file after successfuly updated.
 *
 *  @param data     data
 *  @param name     name
 *  @param mimeType mime type.
 *  @param callback The callback object `DroiObjectCallback` is used to receive save result.
 *
 *  @return taskId for calling the task.
 */
- (NSString*) updateDataInBackground:(NSData*) data name:(NSString*) name mimeType:(NSString*) mimeType callback:(DroiObjectCallback) callback;

/**
 * Check whether there is Uri info. in DroiFile object
 * @return YES - There is Uri info. in DroiFile object. Otherwise is NO
 */
- (BOOL) hasUrl;

/**
 *  Get file url.
 *
 *  @return URL
 */
- (NSURL*) getUrl;

/**
 *  Get file url.
 *
 *  @param isLocal Returned url is local or not.
 *
 *  @return URL
 */
- (NSURL*) getUrl:(BOOL*) isLocal;

/**
 *  Get file url.
 *
 *  @param isLocal Returned url is local or not.
 *
 *  @param error Error details.
 *
 *  @return URL
 */
- (NSURL*) getUrl:(BOOL*) isLocal error:(DroiError**) error;

/**
 *  Get file url in background thread.
 *
 *  @param callback url callback function.
 *
 *  @return false to fail to run in background thread.
 */
- (BOOL) getUrlInBackground:(DroiFileGetUrlCallback) callback;

/**
 *  Get file url in background thread with isLocal flag;
 *
 *  @param callback callback function
 *
 *  @return false to fail to run in background thread.
 */
- (BOOL) getUrlWithFlagInBackground:(DroiFileGetUrlWithFlagCallback) callback;

/**
 *  Get name.
 */
@property (readonly) NSString* name;
/**
 *  Get data size.
 */
@property (readonly) int size;
/**
 *  Get data md5.
 */
@property (readonly) NSString* md5;

@property DroiFileProgressCallback progressCallback;

-(instancetype) init __attribute__((unavailable("init not available")));

@end
