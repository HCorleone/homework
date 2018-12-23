//
//  ArticleGradeViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/23.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "ArticleGradeViewController.h"
#import "ClassificationCell.h"

@interface ArticleGradeViewController ()

@end

@implementation ArticleGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassificationCell *cell = (ClassificationCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    NSString *notificationName = @"";
    if (FromChinese == self.from) {
        notificationName = @"ChineseArticleNote";
    }
    else if (FromEnglish == self.from) {
        notificationName = @"EnglishArticleNote";
    }
    NSString *col = @"0";
    NSLog(@"%@",cell.title.text);
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:@{@"title":cell.title.text,@"col":col}];
    
}

@end
