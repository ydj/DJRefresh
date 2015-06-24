//
//  DJRefreshBottomView.m
//  PullDJRefresh
//
//  Created by YDJ on 15/6/18.
//  Copyright (c) 2015年 YDJ. All rights reserved.
//

#import "DJRefreshBottomView.h"

@implementation DJRefreshBottomView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self setup];
    }
    
    return self;
}



- (void)setup{
    
    self.backgroundColor=[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:237.0/255.0];
    
    _activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped=YES;
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_activityIndicatorView];
    
    _promptLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _promptLabel.backgroundColor=[UIColor clearColor];
    _promptLabel.font=[UIFont systemFontOfSize:13];
    _promptLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_promptLabel];
    
    
    
    NSLayoutConstraint *promptLabelTop=[NSLayoutConstraint constraintWithItem:_promptLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:13];
    NSLayoutConstraint *promptLabelCenterX=[NSLayoutConstraint constraintWithItem:_promptLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraints:@[promptLabelTop,promptLabelCenterX]];
    
    /////
    NSLayoutConstraint * activityTop=[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    NSLayoutConstraint * activityRight=[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_promptLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:-20];
    [self addConstraints:@[activityTop,activityRight]];
    
    [self reset];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
///重新布局
- (void)reset{
    [super reset];
    
    
    _promptLabel.text=@"上拉加载更多";
    if ([_activityIndicatorView isAnimating])
    {
        [_activityIndicatorView stopAnimating];
    }
    
    
}

///松开可刷新
- (void)canEngageRefresh{
    [super canEngageRefresh];
    
    _promptLabel.text=@"松开即可加载";
}

///开始刷新
- (void)startRefreshing{
    [super startRefreshing];
    _promptLabel.text=@"正在加载中...";
    [self.activityIndicatorView startAnimating];
}





@end
