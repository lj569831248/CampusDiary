//
//  User.m
//  CampusDiary
//
//  Created by Jon on 2017/2/21.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "User.h"

@implementation User

+ (BOOL)currentUserIsLogin{
    User *currentUser = [User getCurrentUser];
    return (currentUser.isLoggedIn && (!currentUser.isAnonymous));
}

- (NSString *)displayName{
    if (self.nickName == nil || [self.nickName  isEqualToString:@""] ) {
        if (self.UserId && (!self.isAnonymous)) {
            return self.UserId;
        }else{
            return kLocalizedString(@"匿名用户");
        }
    }
    return self.nickName ;
 
}
@end
