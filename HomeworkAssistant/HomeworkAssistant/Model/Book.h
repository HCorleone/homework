//
//  Book.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/12.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

@property (nonatomic, strong) NSString *coverURL;//背景图
@property (nonatomic, strong) NSString *title;//书名
@property (nonatomic, strong) NSString *subject;//科目
@property (nonatomic, strong) NSString *bookVersion;//书籍版本
@property (nonatomic, strong) NSString *uploaderName;//上传者姓名
@property (nonatomic, strong) NSString *answerID;//答案ID
@property (nonatomic, strong) NSString *grade;//年级

+ (Book *)initWithDic:(NSDictionary *)bookDic;

@end

NS_ASSUME_NONNULL_END

/*
 为您推荐和我的书单列表接口格式均为下面：
 
 {
 code: 0,
 errMsg: “后台返回的错误信息”
 data: [
 {
 coverURL:”这是封面图URL地址”,
 title:”书籍名称”,
 subject: “科目：数学”,
 bookVersion: “书籍版本：人教版等”,
 uploaderName:”上传者姓名”,
 answerID:”答案ID，获取详情需要通过该ID获取；同样收藏也应该获取的是该ID”,
 },
 {},{}…
 ]
 }
 
 */
