//
//  TTUserManager.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/28.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "TTUserManager.h"
#import "TTUserModel.h"



@implementation TTUserManager
static TTUserManager *manager = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TTUserManager alloc]init];
        manager.currentUser = [[TTUserModel alloc]init];
        [manager loadCurrentUserInfo];
    });
    return manager;
}

- (void)saveCurrentUserInfo {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setBool:self.isLogin forKey:@"IsLogin"];
    [def setObject:self.currentUser.headImgUrl forKey:@"headImgUrl"];
    [def setObject:self.currentUser.name forKey:@"name"];
    [def setObject:self.currentUser.openId forKey:@"openId"];
    [def setObject:self.currentUser.grade forKey:@"grade"];
}

- (void)saveLoginUserInfo {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setBool:self.isLogin forKey:@"IsLogin"];
    [def setObject:self.currentUser.headImgUrl forKey:@"headImgUrl"];
    [def setObject:self.currentUser.name forKey:@"name"];
    [def setObject:self.currentUser.openId forKey:@"openId"];
    [def setObject:self.currentUser.grade forKey:@"grade"];
}

- (void)loadCurrentUserInfo {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    self.isLogin = [def boolForKey:@"IsLogin"];
    self.currentUser.headImgUrl = [def stringForKey:@"headImgUrl"];
    self.currentUser.name = [def stringForKey:@"name"];
    self.currentUser.openId = [def stringForKey:@"openId"];
}

- (void)clearCurrentUserInfo {
    self.currentUser = [[TTUserModel alloc] init];
    [self saveCurrentUserInfo];
}

@end
