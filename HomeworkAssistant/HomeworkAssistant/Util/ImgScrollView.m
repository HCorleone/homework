//
//  ImgScrollView.m
//  ImgScrollView
//
//  Created by wangze on 14-8-1.
//  Copyright (c) 2014年 wangze. All rights reserved.
//

#import "ImgScrollView.h"

@interface ImgScrollView()<UIScrollViewDelegate>
{
    //记录自己的位置
    CGRect scaleOriginRect;
    
    //图片的大小
    CGSize imgSize;
    
    
    //缩放前大小
    CGRect initRect;
}

@end

@implementation ImgScrollView

- (void)dealloc
{
    _i_delegate = nil;
}

- (id)initWithFrame:(CGRect)frame andImageViewFrame:(CGRect)frame1
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 4.0;
        
        _imgView = [[UIImageView alloc] initWithFrame:frame1];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgView];
        
        UITapGestureRecognizer *tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped1:)];
        [tapGR1 setNumberOfTapsRequired:1];//设置单击的次数
        [self addGestureRecognizer:tapGR1];
        
        //创建点击两次的手势
        UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapped2:)];
        [tapGR2 setNumberOfTapsRequired:2];//设置单击的次数
        [tapGR2 setNumberOfTouchesRequired:1];//设置手指的数量
        [self addGestureRecognizer:tapGR2];
        
        //如果不加下面的话，当单指双击时，会先调用单指单击中的处理，再调用单指双击中的处理
        [tapGR1 requireGestureRecognizerToFail:tapGR2];
        
        _imgView.userInteractionEnabled = YES;

    }
    return self;
}


- (void)setAnimationRect
{
    _imgView.frame = scaleOriginRect;
}


- (void)setImage:(UIImage *)image
{
    if (image)
    {
        _imgView.image = image;
        imgSize = image.size;
        
        //判断首先缩放的值
        float scaleX = self.frame.size.width / imgSize.width;
        float scaleY = self.frame.size.height / imgSize.height;
        
        //倍数小的，先到边缘
        if (scaleX > scaleY)
        {
            //Y方向先到边缘
            float _imgViewWidth = imgSize.width * scaleY;
//            self.maximumZoomScale = self.frame.size.width / _imgViewWidth;
            
            scaleOriginRect = (CGRect){self.frame.size.width / 2 - _imgViewWidth / 2 , 0, _imgViewWidth, self.frame.size.height};
        }
        else
        {
            //X先到边缘
            float _imgViewHeight = imgSize.height*scaleX;
//            self.maximumZoomScale = self.frame.size.height/_imgViewHeight;
            
            scaleOriginRect = (CGRect){0,self.frame.size.height/2-_imgViewHeight/2,self.frame.size.width, _imgViewHeight};
        }
    }
}

#pragma mark -
#pragma mark - scroll delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = _imgView.frame;
    
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width / 2, contentSize.height / 2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width / 2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height / 2;
    }
    
    _imgView.center = centerPoint;
}

#pragma mark -
#pragma mark - touch
-(void)tapped1:(UIGestureRecognizer *)gesture
{
    if ([self.i_delegate respondsToSelector:@selector(tapImageViewTappedWithObject:)])
    {
        [self.i_delegate tapImageViewTappedWithObject:self];
    }
}

-(void)tapped2:(UIGestureRecognizer *)gesture
{
    if ([self.i_delegate respondsToSelector:@selector(tapImageViewTappedWithObject2:)])
    {
        [self.i_delegate tapImageViewTappedWithObject2:self];
    }
}

@end
