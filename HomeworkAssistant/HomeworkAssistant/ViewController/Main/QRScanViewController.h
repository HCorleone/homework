//
//  QRScanViewController.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/27.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^shareCodeBlock)(NSString *shareCode);//扫描到openid的回调

typedef NS_ENUM(NSInteger, ScanType) {
    ScanTypeShareOrSearch,
    ScanTypeUploadAnswer,
    ScanTypeFeedBack,
    ScanTypeDefault = ScanTypeShareOrSearch
};




@interface QRScanViewController : UIViewController

@property (nonatomic, copy) shareCodeBlock shareCodeBlock;
@property (nonatomic, assign) ScanType scanType;

@end

NS_ASSUME_NONNULL_END
