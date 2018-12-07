//
//  YDUserManager.h
//  sw-reader
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSTimeInterval const secondPerDay = 60.0 * 60.0 * 24.0;

@class YDUserModel;
@interface YDUserManager : NSObject

/**
 *  当前是否有用户登录
 */
@property (nonatomic, assign) BOOL isLogin;
/**
 *  当前登录的用户
 */
@property (nonatomic, strong) YDUserModel *currentUser;

/**
 *  日期格式化
 */
@property (nonatomic, strong) NSDateFormatter *formatter;

#pragma mark - 阅读历史记录
/**
 *  累计阅读文章总数
 */
@property (nonatomic, assign) NSInteger readCountTotal;
/**
 *  累计阅读文章天数
 */
@property (nonatomic, assign) NSInteger readDayTotal;

//今天阅读数量
@property (nonatomic, assign) NSInteger readDayToday;

/**
 *  累计查词个数
 */
@property (nonatomic, assign) NSInteger wordCountTotal;
//今天查词数量
@property (nonatomic, assign) NSInteger wordDayToday;

/**
 *  累计阅读时长2
 */
@property (nonatomic, assign) NSInteger readTimeCountTotal;
//今天阅读时长
@property (nonatomic, assign) NSInteger readTimeDayToday;

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

#pragma mark - 阅读计数相关
/**
 *  获取本周每日文章阅读量
 *
 *  @return 从周一到当天的每日阅读量 <NSNumber>
 */
- (NSArray *)readingCountThisWeek;

//最近7天阅读量
-(NSDictionary *)readingCount7Days;

//最近7天查词量
-(NSDictionary *)wordCount7Days;

//最近7天阅读时长
-(NSDictionary *)readTimeCount7Days;


/**
 *  今日阅读数+1
 */
- (void)increaseReadingCount;
//增加阅读时长
- (void)increaseReadTimeCount:(NSInteger) time;
//查词数加1
- (void)increaseWordCount;

+ (int)intervalSinceNow1: (NSString *) theDate;
@end
