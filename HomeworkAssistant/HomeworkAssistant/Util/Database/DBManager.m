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

//删除已下载的答案
+ (void)deleteFromDataBase_downloadedBook:(NSArray *)answerIDArr {
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [doc stringByAppendingPathComponent:@"MyDownload.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (int i = 0; i < answerIDArr.count; i++) {
                NSString *answerID = answerIDArr[i];
                BOOL deleteRes = [db executeUpdate:@"delete from 'downloadModel' where answerID = ?", answerID];
                BOOL deleteRes1 = [db executeUpdate:@"delete from 'imagePath' where answerID = ?", answerID];
                if (!deleteRes || !deleteRes1) {
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

//查询某答案是否已经下载有了
+ (BOOL)checkIfAnswerIsDownloaded:(NSString *)answerID {
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [doc stringByAppendingPathComponent:@"MyDownload.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        //插入数据
        FMResultSet *checkRes = [db executeQuery:@"select answerID from 'downloadModel' where answerID = ?",answerID];
        if ([checkRes next]) {
            if ([[checkRes stringForColumn:@"answerID"] isEqualToString:answerID]) {
                NSLog(@"该答案已下载过");
                return YES;
            }
            else {
                NSLog(@"该答案未下载过");
                return NO;
            };
        }
        [db close];
    }
    return NO;
    
}

//查询数据库并把数据返回到我的下载控制器上
+ (NSArray *)selectDataForDownloadedView {
    NSMutableArray *bookModelArr = [NSMutableArray array];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [doc stringByAppendingPathComponent:@"MyDownload.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        FMResultSet *checkRes = [db executeQuery:@"select * from 'downloadModel' order by currentTime desc"];
        while ([checkRes next]) {
            DownloadedBook *bookModel = [[DownloadedBook alloc] init];
            bookModel.coverImgPath = [checkRes stringForColumn:@"coverImgPath"];
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

//选取下载好的thumbsImg的地址并返回数组
+ (NSArray *)selectThumbsImgWithAnswerID:(NSString *)answerID {
    NSMutableArray *thumbsPathArr = [NSMutableArray array];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [doc stringByAppendingPathComponent:@"MyDownload.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        FMResultSet *checkRes = [db executeQuery:@"select thumbsPath,idx from 'imagePath' where answerID = ?",answerID];
        while ([checkRes next]) {
            NSDictionary *dic = @{
                                  @"thumbsPath":[checkRes stringForColumn:@"thumbsPath"],
                                  @"idx":[checkRes stringForColumn:@"idx"]
                                  };
            [thumbsPathArr addObject:dic];
        }
        [db close];
    }
    return thumbsPathArr;
}

//选取下载好的detailImg的地址并返回数组
+ (NSArray *)selectDetailImgWithAnswerID:(NSString *)answerID {
    NSMutableArray *thumbsPathArr = [NSMutableArray array];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [doc stringByAppendingPathComponent:@"MyDownload.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        FMResultSet *checkRes = [db executeQuery:@"select detailPath,idx from 'imagePath' where answerID = ?",answerID];
        while ([checkRes next]) {
            NSDictionary *dic = @{
                                  @"detailPath":[checkRes stringForColumn:@"detailPath"],
                                  @"idx":[checkRes stringForColumn:@"idx"]
                                  };
            [thumbsPathArr addObject:dic];
        }
        [db close];
    }
    return thumbsPathArr;
}

//将下载好的模型记录存的数据库
+ (void)insertToDataBase_downloadedBook:(DownloadedBook *)bookModel {
    
    //获取当前时间（用于排序）
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTimeString = [dateFormatter stringFromDate:dateNow];
    
    NSArray *argArr = @[
                        bookModel.coverImgPath,
                        bookModel.title,
                        bookModel.subject,
                        bookModel.bookVersion,
                        bookModel.uploaderName,
                        bookModel.answerID,
                        bookModel.grade,
                        currentTimeString
                        ];
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [doc stringByAppendingPathComponent:@"MyDownload.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        //插入数据
        BOOL insertRes = [db executeUpdate:@"insert into downloadModel(coverImgPath, title, subject, bookVersion, uploaderName, answerID, grade, currentTime) values( ?, ?, ?, ?, ?, ?, ?, ?)" withArgumentsInArray:argArr];
        if (!insertRes) {
            NSLog(@"插入数据失败");
        }
        [db close];
    }
}

//将detailImg和thumbsImg的路径存到数据库
+ (void)insertToDataBase_imgPath:(NSString *)answerID NumberOfImg:(NSInteger)count {
    
    
    NSString *thumbsImgPath = @"";
    NSString *detailImgPath = @"";
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [doc stringByAppendingPathComponent:@"MyDownload.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (NSInteger i = 1; i < count + 1; i++) {
                
                thumbsImgPath = [NSString stringWithFormat:@"/Documents/MyDownloadImages/%@/thumbsImg/thumbsImg%ld.png",answerID,(long)i];
                detailImgPath = [NSString stringWithFormat:@"/Documents/MyDownloadImages/%@/detailImg/detailImg%ld.png",answerID,(long)i];
                BOOL insertRes = [db executeUpdate:@"insert into imagePath(answerID, thumbsPath, detailPath, idx) values( ?, ?, ?, ?)",answerID,thumbsImgPath,detailImgPath,[[NSNumber numberWithInteger:i] stringValue]];
                if (!insertRes) {
                    NSLog(@"插入数据失败");
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

@end
