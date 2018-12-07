//
//  NSArray+SafeObjectArray.m
//  滴滴工程
//
//  Created by 邱敏 on 2018/8/31.
//  Copyright © 2018年 ytq. All rights reserved.
//

#import "NSArray+SafeObjectArray.h"

@implementation NSArray (SafeObjectArray)

-(id)safeObjectIndex:(NSInteger)index
{
    if (index >= [self count])
    {
        return nil;
    }
    id obj = [self objectAtIndex:index];
    //判断对象是不是null(后台可能会写一个null类型的值)
    if (obj == [NSNull null] )
    {
        return nil;
    }
    return obj;
    
}

@end
