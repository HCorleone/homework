
//
//  YDUserManager.m
//  sw-reader
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 卢坤. All rights reserved.
//

#import "YDUserManager.h"
#import "YDUserModel.h"

#define kIsLogin  @"kIsLogin"

@implementation YDUserManager
+ (instancetype)sharedInstance {
    static YDUserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YDUserManager alloc] init];
        manager.currentUser = [[YDUserModel alloc] init];
        [manager loadCurrentUserInfo];
        manager.formatter = [[NSDateFormatter alloc] init];
        [manager.formatter setDateFormat:@"yyyyMMdd"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        manager.readDayToday = [defaults integerForKey:[NSString stringWithFormat:@"%@readday",[manager todayDate]]];
        manager.readCountTotal = [defaults integerForKey:kReadCountTotal];
        manager.wordCountTotal = [defaults integerForKey:kWordCountTotal];
        manager.wordDayToday = [defaults integerForKey:[NSString stringWithFormat:@"%@wordday",[manager todayDate]]];
        manager.readTimeCountTotal = [defaults integerForKey:kReadTimeTotal];
        manager.readTimeDayToday = [defaults integerForKey:[NSString stringWithFormat:@"%@readtimeday",[manager todayDate]]];

        NSString *day = [defaults stringForKey:kReadDayTotal];
        if(day == nil){
            day = [manager todayDate];
            [defaults setObject:day forKey:kReadDayTotal];
        }
        manager.readDayTotal = [ YDUserManager intervalSinceNow1:day];

    });
    
    return manager;
}

+ (int)intervalSinceNow1: (NSString *) theDate {
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyyMMdd"];//设置时间格式//很重要
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    if (cha/86400>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue] + 1;
    }
    return 1;
}

- (void)saveCurrentUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.isLogin forKey:kIsLogin];
    [defaults setValue:self.currentUser.accessToken forKey:kAccessToken];
    [defaults setValue:self.currentUser.userID forKey:kUserID];
    [defaults setValue:self.currentUser.refreshToken forKey:kRefreshToken];
    [defaults setInteger:self.currentUser.typeLogin forKey:kTypeLoginFrom];
    [defaults setValue:self.currentUser.loginType forKey:kLoginType];
    
    //QQ
    [defaults setValue:self.currentUser.expirationDate forKey:kExpirationDate];
    
    //163
    [defaults setValue:self.currentUser.from forKey:kFrom];
    [defaults setValue:self.currentUser.dictpc forKey:kDictpc];
    
    //微信
    [defaults setValue:self.currentUser.scope forKey:kScope];
    [defaults setValue:self.currentUser.expires_in forKey:kExpires_in];
    [defaults setValue:self.currentUser.unionid forKey:kUnionid];
    [defaults setValue:self.currentUser.openid forKey:kOpenid];
 
    NSString *userID = self.currentUser.userID;
    if (userID && userID.length) {
        //如果用户ID长度符合要求就去存他的专属信息
        
        [defaults setValue:self.currentUser.nickName forKey:[self keyWithPersonalUID:userID key:kNickName]];
        [defaults setValue:self.currentUser.avatarImage forKey:[self keyWithPersonalUID:userID key:kAvatarImage]];
        [defaults setValue:self.currentUser.userDescription forKey:[self keyWithPersonalUID:userID key:kUserDescription]];
        [defaults setValue:self.currentUser.gender forKey:[self keyWithPersonalUID:userID key:kGender]];
        [defaults setValue:self.currentUser.age forKey:[self keyWithPersonalUID:userID key:kAge]];
        [defaults setValue:self.currentUser.birthday forKey:[self keyWithPersonalUID:userID key:kBirthday]];
        [defaults setValue:self.currentUser.city forKey:[self keyWithPersonalUID:userID key:kCity]];
        [defaults setValue:self.currentUser.province forKey:[self keyWithPersonalUID:userID key:kProvince]];
        [defaults setValue:self.currentUser.country forKey:[self keyWithPersonalUID:userID key:kCountry]];
    }
}

- (void)saveLoginUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.isLogin forKey:kIsLogin];
    [defaults setValue:self.currentUser.accessToken forKey:kAccessToken];
    [defaults setValue:self.currentUser.userID forKey:kUserID];
    [defaults setValue:self.currentUser.refreshToken forKey:kRefreshToken];
    [defaults setInteger:self.currentUser.typeLogin forKey:kTypeLoginFrom];
    [defaults setValue:self.currentUser.loginType forKey:kLoginType];
    
    //QQ
    [defaults setValue:self.currentUser.expirationDate forKey:kExpirationDate];
    
    //163
    [defaults setValue:self.currentUser.from forKey:kFrom];
    [defaults setValue:self.currentUser.dictpc forKey:kDictpc];
    
    //微信
    [defaults setValue:self.currentUser.scope forKey:kScope];
    [defaults setValue:self.currentUser.expires_in forKey:kExpires_in];
    [defaults setValue:self.currentUser.unionid forKey:kUnionid];
    [defaults setValue:self.currentUser.openid forKey:kOpenid];
    
    NSString *userID = self.currentUser.userID;
    if (userID && userID.length) {
        //如果用户ID长度符合要求就去存他的专属信息
#warning 这里是覆写信息,有就覆写，没有就不管
        [self override:self.currentUser.nickName key:kNickName];
        [self override:self.currentUser.avatarImage key:kAvatarImage];
        [self override:self.currentUser.userDescription key:kUserDescription];
        [self override:self.currentUser.gender key:kGender];
        [self override:self.currentUser.age key:kAge];
        [self override:self.currentUser.birthday key:kBirthday];
    }
}

#warning 每次登陆之前和退出登陆的时候，都会先清除当前的登陆用户信息，然后在登陆的时候先保存各个登陆方式的token用户名等等，再保存当前用户登陆信息，并且如果有新的信息更新就覆写，然后再根据当前用户id从偏好里导入历史信息
- (void)clearCurrentUserInfo {
    self.currentUser = [[YDUserModel alloc] init];
    [self saveCurrentUserInfo];
}

- (void)loadCurrentUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isLogin = [defaults boolForKey:kIsLogin];
    self.currentUser.accessToken = [defaults stringForKey:kAccessToken];
    self.currentUser.userID = [defaults stringForKey:kUserID];
    self.currentUser.refreshToken = [defaults stringForKey:kRefreshToken];
    self.currentUser.typeLogin = [defaults integerForKey:kTypeLoginFrom];
    self.currentUser.loginType = [defaults stringForKey:kLoginType];
    
    //163
    self.currentUser.from = [defaults stringForKey:kFrom];
    self.currentUser.dictpc = [defaults stringForKey:kDictpc];
    
    //QQ
    self.currentUser.expirationDate = [defaults objectForKey:kExpirationDate];
    
    //微信
    self.currentUser.scope = [defaults stringForKey:kScope];
    self.currentUser.expires_in = [defaults stringForKey:kExpires_in];
    self.currentUser.unionid = [defaults stringForKey:kUnionid];
    self.currentUser.openid = [defaults stringForKey:kOpenid];
    
    NSString *userID = self.currentUser.userID;
    if (userID && userID.length) {
        //如果用户ID长度符合要求就去取他的专属信息
        self.currentUser.nickName = [defaults stringForKey:[self keyWithPersonalUID:userID key:kNickName]];
        self.currentUser.avatarImage = [defaults stringForKey:[self keyWithPersonalUID:userID key:kAvatarImage]];
        self.currentUser.userDescription = [defaults stringForKey:[self keyWithPersonalUID:userID key:kUserDescription]];
        self.currentUser.gender = [defaults stringForKey:[self keyWithPersonalUID:userID key:kGender]];
        self.currentUser.age = [defaults stringForKey:[self keyWithPersonalUID:userID key:kAge]];
        self.currentUser.birthday = [defaults stringForKey:[self keyWithPersonalUID:userID key:kBirthday]];
        self.currentUser.city = [defaults stringForKey:[self keyWithPersonalUID:userID key:kCity]];
        self.currentUser.province = [defaults stringForKey:[self keyWithPersonalUID:userID key:kProvince]];
        self.currentUser.country = [defaults stringForKey:[self keyWithPersonalUID:userID key:kCountry]];
    }
}

- (void)override:(NSString *)value key:(NSString *)key{
    if (value && value.length) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:[self keyWithPersonalUID:self.currentUser.userID key:key]];
    }
}

- (NSString *)keyWithPersonalUID:(NSString *)userID key:(NSString *)key {
    return [NSString stringWithFormat:@"%@&&%@", userID, key];
}

#pragma mark - 阅读计数相关

-(void)saveReadInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //阅读历史
    [defaults setInteger:self.readCountTotal forKey:kReadCountTotal];
    [defaults setInteger:self.readDayToday forKey:[NSString stringWithFormat:@"%@readday",[self todayDate]]];
}

-(void)saveWordInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //查词总数
    [defaults setInteger:self.wordCountTotal forKey:kWordCountTotal];
    [defaults setInteger:self.wordDayToday forKey:[NSString stringWithFormat:@"%@wordday",[self todayDate]]];
}

-(void)saveReadTimeInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //查词总数
    [defaults setInteger:self.readTimeCountTotal forKey:kReadTimeTotal];
    [defaults setInteger:self.readTimeDayToday forKey:[NSString stringWithFormat:@"%@readtimeday",[self todayDate]]];
}

- (void)increaseReadingCount
{
    //总阅读数+1
    self.readCountTotal++;
    //当天阅读数+1
    self.readDayToday++;
    [self saveReadInfo];
}

- (void)increaseWordCount
{
    //总阅读数+1
    self.wordCountTotal++;
    self.wordDayToday++;
    [self saveWordInfo];
}

- (void)increaseReadTimeCount:(NSInteger) time
{
    //总阅读数+1
    self.readTimeCountTotal = self.readTimeCountTotal + time;
    self.readTimeDayToday = self.readTimeDayToday + time;
    [self saveReadTimeInfo];
}

-(NSDictionary *)readingCount7Days
{
    NSMutableDictionary *readCounts = [[NSMutableDictionary alloc] init];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",self.readDayToday] forKey:@"0"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readday",[self pastDate:1]]]] forKey:@"1"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readday",[self pastDate:2]]]] forKey:@"2"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readday",[self pastDate:3]]]] forKey:@"3"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readday",[self pastDate:4]]]] forKey:@"4"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readday",[self pastDate:5]]]] forKey:@"5"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readday",[self pastDate:6]]]] forKey:@"6"];

//    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[self pastDate:1]]] forKey:@"1"];
//    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[self pastDate:2]]] forKey:@"2"];
//    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[self pastDate:3]]] forKey:@"3"];
//    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[self pastDate:4]]] forKey:@"4"];
//    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[self pastDate:5]]] forKey:@"5"];
//    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[self pastDate:6]]] forKey:@"6"];

    return readCounts;
}

-(NSDictionary *)wordCount7Days
{
    NSMutableDictionary *readCounts = [[NSMutableDictionary alloc] init];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",self.wordDayToday] forKey:@"0"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@wordday",[self pastDate:1]]]] forKey:@"1"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@wordday",[self pastDate:2]]]] forKey:@"2"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@wordday",[self pastDate:3]]]] forKey:@"3"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@wordday",[self pastDate:4]]]] forKey:@"4"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@wordday",[self pastDate:5]]]] forKey:@"5"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@wordday",[self pastDate:6]]]] forKey:@"6"];
    return readCounts;
}

//最近7天阅读时长
-(NSDictionary *)readTimeCount7Days
{
    NSMutableDictionary *readCounts = [[NSMutableDictionary alloc] init];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",self.readTimeDayToday/60000] forKey:@"0"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readtimeday",[self pastDate:1]]]/60000] forKey:@"1"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readtimeday",[self pastDate:2]]]/60000] forKey:@"2"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readtimeday",[self pastDate:3]]]/60000] forKey:@"3"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readtimeday",[self pastDate:4]]]/60000] forKey:@"4"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readtimeday",[self pastDate:5]]]/60000] forKey:@"5"];
    [readCounts setValue:[NSString stringWithFormat:@"%ld",[self readingCountInDate:[NSString stringWithFormat:@"%@readtimeday",[self pastDate:6]]]/60000] forKey:@"6"];
    return readCounts;
}

/**
 *  获取具体日期的文章阅读量
 *
 *  @param date 日期 格式为 20150101
 *
 *  @return 文章阅读量
 */
- (NSInteger)readingCountInDate:(NSString *)date
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:date];
}


/**
 *  计算今天的星期值
 *
 *  @return 星期值 1~7 : 1 表示星期一
 */
- (NSInteger)weekday
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = dateComponents.weekday;
    weekday--;
    return weekday > 0 ? weekday : 7;
}

/**
 *  获取当天日期
 *
 *  @return 当天日期：格式为20150101
 */
- (NSString *)todayDate
{
    return [_formatter stringFromDate:[NSDate date]];
}

//获取之前的日期
-(NSString *) pastDate:(NSInteger)day
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    [components setHour:-(24 * day)];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    return [_formatter stringFromDate:yesterday];
}


@end
