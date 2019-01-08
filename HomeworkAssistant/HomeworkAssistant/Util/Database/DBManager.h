//
//  DBManager.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/28.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "DownloadedBook.h"
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
//删除已下载的答案
+ (void)deleteFromDataBase_downloadedBook:(NSArray *)answerIDArr;

//查询某答案是否已经下载过
+ (BOOL)checkIfAnswerIsDownloaded:(NSString *)answerID;
//选取下载好的thumbsImg的地址并返回数组
+ (NSArray *)selectThumbsImgWithAnswerID:(NSString *)answerID;
//选取下载好的detailImg的地址并返回数组
+ (NSArray *)selectDetailImgWithAnswerID:(NSString *)answerID;
//将我的下载以数组形式返回
+ (NSArray *)selectDataForDownloadedView;

//插入到我的下载数据库——model类型
+ (void)insertToDataBase_downloadedBook:(DownloadedBook *)bookModel;
//插入到我的下载数据库——thumbsImg和detailImg的路径
+ (void)insertToDataBase_imgPath:(NSString *)answerID NumberOfImg:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
