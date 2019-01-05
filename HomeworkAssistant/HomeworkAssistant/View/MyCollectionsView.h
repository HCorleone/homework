//
//  MyListView.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/30.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionsView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout withArray:(NSMutableArray *)array;
- (void)reloadDataWithList:(NSMutableArray *)arr;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) MainViewController *currentVC;

@end

NS_ASSUME_NONNULL_END
