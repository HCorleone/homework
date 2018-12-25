//
//  ChineseViewController.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZPullDownMenu.h"
#import "ArticleGradeViewController.h"
#import "ArticleTypeViewController.h"
#import "WordsNumViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChineseViewController : UIViewController

- (NSString *)getLanguage;
- (NSArray *)getTitles;
- (From)getMenuType;
- (void)setupAllChildViewController;
- (void)refreshSearchView:(NSNotification *)note;

@end

NS_ASSUME_NONNULL_END
