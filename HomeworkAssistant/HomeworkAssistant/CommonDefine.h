//
//  CommonDefine.h
//  党建
//
//  Created by Mac on 2018/10/24.
//  Copyright © 2018年 wx. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h


/** 选中年级，科目，版本 */
#define ClickColor [UIColor colorWithRed:85/255.0 green:195/255.0 blue:242/255.0 alpha:1/1.0]



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define userDefaults(object, key) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]
#define userValue(key) [[NSUserDefaults standardUserDefaults] valueForKey:key]


#endif /* CommonDefine_h */
