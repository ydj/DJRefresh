//
//  RefreshBottomView.m
//
//  Copyright (c) 2014 YDJ ( https://github.com/ydj/RefreshControl )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.



#import "RefreshBottomView.h"

@implementation RefreshBottomView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        
        [self initViews];
    }
    return self;
}

- (void)initViews
{

    self.backgroundColor=[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:237.0/255.0];

    _activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped=YES;
    _activityIndicatorView.color=[UIColor orangeColor];
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_activityIndicatorView];
    
    
    _promptLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _promptLabel.backgroundColor=[UIColor clearColor];
    _promptLabel.font=[UIFont systemFontOfSize:13];
//    _promptLabel.textAlignment=NSTextAlignmentCenter;
    _promptLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_promptLabel];
    

    
    [self resetViews];
    
    [self resetLayoutSubViews];

}

- (void)resetViews
{
    _promptLabel.text=@"上拉加载更多";
    if ([self.activityIndicatorView isAnimating])
    {
        [self.activityIndicatorView stopAnimating];
    }

}


- (void)resetLayoutSubViews
{
    NSArray * tempContraint=self.constraints;
    if ([tempContraint count]>0)
    {
        [self removeConstraints:tempContraint];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        
        NSLayoutConstraint *pTop=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:13];
        NSLayoutConstraint *pCenterX=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self addConstraints:@[pTop,pCenterX]];
        
    /////
    NSLayoutConstraint * aTop=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    NSLayoutConstraint * aRight=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.promptLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:-20];
    
    NSArray * aList=@[aTop,aRight];
    
    [self addConstraints:aList];
    
    }];

    
    
}
///松开可刷新
- (void)canEngageRefresh
{
    _promptLabel.text=@"松开即可加载";
    
}
///松开返回
- (void)didDisengageRefresh
{
    [self resetViews];
}
///开始刷新
- (void)startRefreshing
{
    _promptLabel.text=@"正在加载中...";
    [self.activityIndicatorView startAnimating];
    
}
///结束
- (void)finishRefreshing
{
    [self resetViews];
}

@end
