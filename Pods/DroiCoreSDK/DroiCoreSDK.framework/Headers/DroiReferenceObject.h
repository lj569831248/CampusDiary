/*
 * Copyright (c) 2016-present Shanghai Droi Technology Co., Ltd.
 * All rights reserved.
 */

#import <Foundation/Foundation.h>

@class DroiObject;

/**
 *   A class that is used to reference other DroiObject object or DroiObject extension object. In storage the data is saved in different data table. This concept of class is foreign key in the relational database.
 */
@interface DroiReferenceObject : NSObject

/**
 *  Current referenced object
 */
@property id droiObject;

@end
