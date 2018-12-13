//
//  ImgScrollView.h
//  ImgScrollView
//
//  Created by wangze on 14-8-1.
//  Copyright (c) 2014年 wangze. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImgScrollViewDelegate <NSObject>

-(void)tapImageViewTappedWithObject:(id) sender;

-(void)tapImageViewTappedWithObject2:(id) sender;

@end

@interface ImgScrollView : UIScrollView

@property (weak) id<ImgScrollViewDelegate> i_delegate;
@property(nonatomic, strong) UIImageView *imgView;

- (id)initWithFrame:(CGRect)frame andImageViewFrame:(CGRect)frame1;

- (void) setImage:(UIImage *) image;
- (void) setAnimationRect;

@end
