//
//  TTUserManager.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/28.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@class TTUserModel;
@interface TTUserManager : NSObject

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) TTUserModel *currentUser;

#pragma mark - 初始化登陆相关
+ (instancetype)sharedInstance;
/**
 *  保存当前用户所有的信息
 */
- (void)saveCurrentUserInfo;
/**
 *  保存登录成功时的用户信息，只包含必要的token等信息
 */
- (void)saveLoginUserInfo;
/**
 *  开启app时，读取当前用户所有信息
 */
- (void)loadCurrentUserInfo;
/**
 *  清空当前登录用户信息
 */
- (void)clearCurrentUserInfo;

@end

NS_ASSUME_NONNULL_END
