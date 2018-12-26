//
//  MyListViewCell.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/30.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

//首页我的书单横向的CollectionViewCell
@interface MyCollectionsCell : UICollectionViewCell

@property (nonatomic, strong) Book *model;

@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UILabel *title;

@end

NS_ASSUME_NONNULL_END
