//
//  WordsNumViewController.m
//  HomeworkAssistant
//
//  Created by 无敌帅枫 on 2018/12/24.
//  Copyright © 2018 无敌帅枫. All rights reserved.
//

#import "WordsNumViewController.h"

@interface WordsNumViewController ()

@end

@implementation WordsNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray *)getTitles {
    return @[@"全部字数",@"0_199",@"200_399",@"400_599",@"600_799",@"800_999",@"1000以上"];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassificationCell *cell = (ClassificationCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    NSString *notificationName = @"";
    NSString *col = @"2";
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
