//
//  RecommendTableView.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/20.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecommendTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withArray:(NSMutableArray *)array;
- (void)reloadDataWithList:(NSMutableArray *)arr;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

NS_ASSUME_NONNULL_END
