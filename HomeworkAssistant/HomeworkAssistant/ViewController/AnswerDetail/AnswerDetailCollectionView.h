//
//  AnswerDetailCollectionView.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/11/21.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnswerDetailCollectionView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout withArray:(NSMutableArray *)array;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSString *answerID;
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
