//
//  DownloadedBook.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2019/1/5.
//  Copyright © 2019 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadedBook : NSObject

@property (nonatomic, strong) NSString *coverImgPath;//保存在本地背景图路径
@property (nonatomic, strong) NSString *title;//书名
@property (nonatomic, strong) NSString *subject;//科目
@property (nonatomic, strong) NSString *bookVersion;//书籍版本
@property (nonatomic, strong) NSString *uploaderName;//上传者姓名
@property (nonatomic, strong) NSString *answerID;//答案ID
@property (nonatomic, strong) NSString *grade;//年级

@end

NS_ASSUME_NONNULL_END
