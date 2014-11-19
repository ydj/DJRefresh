//
//  RefreshView.m
//  PullRefreshControl
//
//  Created by YDJ on 14/11/3.
//  Copyright (c) 2014年 jingyoutimes. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
       
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.backgroundColor=[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:237.0/255.0];

    _imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image=[UIImage imageNamed:@"pull_refresh.png"];
    _imageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_imageView];
    
    [self resetLayoutSubViews];
    
}


- (void)resetLayoutSubViews
{
    
    NSArray * temp=self.constraints;
    if ([temp count]>0)
    {
        [self removeConstraints:temp];
    }
    
    NSLayoutConstraint * centX=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint * width=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:32];
    NSLayoutConstraint *bottom=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-8];
    NSLayoutConstraint *height=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:32];

    NSArray * list=@[centX,width,bottom,height];
    
    [self addConstraints:list];
    
    
}


- (void)resetViews
{
    [UIView animateWithDuration:0.25 animations:^{
        _imageView.transform=CGAffineTransformIdentity;
        _imageView.image=[UIImage imageNamed:@"pull_refresh.png"];
    }];
    
}


- (void)canEngageRefresh
{
    [UIView animateWithDuration:0.25 animations:^{
        _imageView.transform=CGAffineTransformMakeRotation(M_PI);
    }];
    
}
- (void)didDisengageRefresh
{
    [self resetViews];
}
- (void)startRefreshing
{
    _imageView.image=[UIImage imageNamed:@"pull_loading@2x.png"];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    
    [_imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
- (void)finishRefreshing
{
    [_imageView.layer removeAnimationForKey:@"rotationAnimation"];
    _imageView.transform=CGAffineTransformIdentity;
    _imageView.image=[UIImage imageNamed:@"pull_refresh.png"];
    
}


@end
