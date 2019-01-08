//
//  DBManager.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/28.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject

/*
 * 浏览记录所用
 */
//将浏览记录以数组形式返回
+ (NSArray *)selectDataForHistoryView;
//将当前浏览加入到浏览记录数据库中
+ (void)insertToDataBase:(Book *)bookModel;
//将当前浏览记录从数据库中删除
+ (void)deleteFromDataBase:(NSArray *)bookModelArr;

/*
 * 我的下载所用
 */


@end

NS_ASSUME_NONNULL_END
