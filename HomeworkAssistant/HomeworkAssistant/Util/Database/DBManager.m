//
//  DBManager.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/28.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

#pragma mark - 历史记录所用

//查询数据库并把数据返回到histoView上
+ (NSArray *)selectDataForHistoryView {
    NSMutableArray *bookModelArr = [NSMutableArray array];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [doc stringByAppendingPathComponent:@"history.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        FMResultSet *checkRes = [db executeQuery:@"select * from 'history' order by currentTime desc"];
        while ([checkRes next]) {
            Book *bookModel = [[Book alloc] init];
            bookModel.coverURL = [checkRes stringForColumn:@"coverURL"];
            bookModel.title = [checkRes stringForColumn:@"title"];
            bookModel.subject = [checkRes stringForColumn:@"subject"];
            bookModel.bookVersion = [checkRes stringForColumn:@"bookVersion"];
            bookModel.uploaderName = [checkRes stringForColumn:@"uploaderName"];
            bookModel.answerID = [checkRes stringForColumn:@"answerID"];
            bookModel.grade = [checkRes stringForColumn:@"grade"];
            [bookModelArr addObject:bookModel];
        }
        [db close];
    }
    return bookModelArr;
}

+ (void)insertToDataBase:(Book *)bookModel {
    
    //获取当前时间（用于排序）
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTimeString = [dateFormatter stringFromDate:dateNow];
    
    NSArray *argArr = @[
                        bookModel.coverURL,
                        bookModel.title,
                        bookModel.subject,
                        bookModel.bookVersion,
                        bookModel.uploaderName,
                        bookModel.answerID,
                        bookModel.grade,
                        currentTimeString
                        ];
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [doc stringByAppendingPathComponent:@"history.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        
        //在插入数据之前先检查是否有已存在的浏览记录，有则删除之后在插入新的数据
        FMResultSet *checkRes = [db executeQuery:@"select * from 'history' where answerID = ?" withArgumentsInArray:@[bookModel.answerID]];
        if ([checkRes next]) {
            if ([checkRes stringForColumn:@"answerID"]) {
                NSLog(@"浏览记录存在");
                //删除浏览记录
                BOOL deleteRes = [db executeUpdate:@"delete from 'history' where answerID = ?" withArgumentsInArray:@[bookModel.answerID]];
                if (!deleteRes) {
                    NSLog(@"删除数据失败");
                }
            }
            else {
                NSLog(@"浏览记录不存在");
            }
        }
        else {
            NSLog(@"浏览记录不存在");
        }
        //插入数据
        BOOL insertRes = [db executeUpdate:@"insert into history(coverURL, title, subject, bookVersion, uploaderName, answerID, grade, currentTime) values( ?, ?, ?, ?, ?, ?, ?, ?)" withArgumentsInArray:argArr];
        if (!insertRes) {
            NSLog(@"插入数据失败");
        }
        [db close];
    }
}

+ (void)deleteFromDataBase:(NSArray *)bookModelArr {

    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [doc stringByAppendingPathComponent:@"history.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (int i = 0; i < bookModelArr.count; i++) {
                Book *model = (Book *)bookModelArr[i];
                BOOL deleteRes = [db executeUpdate:@"delete from 'history' where answerID = ?" withArgumentsInArray:@[model.answerID]];
                if (!deleteRes) {
                    NSLog(@"批量删除浏览记录失败");
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
        }
        @finally {
            if (!isRollBack) {
                [db commit];
            }
        }
        [db close];
    }
}

#pragma mark - 我的下载所用


@end
