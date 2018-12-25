//
//  ArticleGradeViewController.h
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/23.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "GradeViewController.h"
#import "ClassificationCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GradeFrom) {
    FromChinese,
    FromEnglish
};

@interface ArticleGradeViewController : UIViewController

@property (nonatomic, assign) GradeFrom from;

- (NSArray *)getTitles;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
