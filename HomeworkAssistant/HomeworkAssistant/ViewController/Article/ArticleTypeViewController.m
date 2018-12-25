//
//  ArticleTypeViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/24.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "ArticleTypeViewController.h"

@interface ArticleTypeViewController ()

@end

@implementation ArticleTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray *)getTitles {
    return @[@"全部题材",@"写人",@"写景",@"话题",@"状物",@"观后感",@"读后感",@"叙事",@"想象",@"日记",@"演讲稿",@"小说",@"续写改写扩写",@"期中考试",@"散文",@"议论",@"书信",@"抒情",@"诗歌",@"看图写话",@"童话寓言",@"读书笔记",@"材料",@"说明文",@"期末考试",@"申请书",@"漫画",@"游记",@"探究考察",@"儿歌",@"活动",@"古诗改写"];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassificationCell *cell = (ClassificationCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    NSString *notificationName = @"";
    NSString *col = @"1";
    if (FromChinese == self.from) {
        notificationName = @"ChineseArticleNote";
    }
    else if (FromEnglish == self.from) {
        notificationName = @"EnglishArticleNote";
    }
    
    NSLog(@"%@",cell.title.text);
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:@{@"title":cell.title.text,@"col":col}];
    
}

@end
