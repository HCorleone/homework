//
//  MyListView.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/30.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyListView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout withArray:(NSMutableArray *)array;
- (void)reloadDataWithList:(NSMutableArray *)arr;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

NS_ASSUME_NONNULL_END
