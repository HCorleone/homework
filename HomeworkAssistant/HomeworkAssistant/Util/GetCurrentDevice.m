//
//  GetCurrentDevice.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/10.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "GetCurrentDevice.h"
#import <sys/utsname.h>

@implementation GetCurrentDevice

+ (CGFloat)getTopOffset {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];

    if ([deviceModel isEqualToString:@"iPhone10,3"])   return 22;
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return 22;
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return 22;
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return 22;
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return 22;
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return 22;
    if ([deviceModel isEqualToString:@"i386"] || [deviceModel isEqualToString:@"x86_64"]) return 22;
    return 0;
}

+ (CGFloat)getBotOffset {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return 30;
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return 30;
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return 30;
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return 30;
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return 30;
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return 30;
    if ([deviceModel isEqualToString:@"i386"] || [deviceModel isEqualToString:@"x86_64"]) return 30;
    return 0;
}

@end
