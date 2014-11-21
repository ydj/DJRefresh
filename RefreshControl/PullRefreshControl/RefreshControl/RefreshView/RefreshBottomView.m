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
    
    _loadingLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _loadingLabel.backgroundColor=[UIColor clearColor];
    _loadingLabel.font=[UIFont systemFontOfSize:13];
    _loadingLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_loadingLabel];
    
    _promptLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _promptLabel.backgroundColor=[UIColor clearColor];
    _promptLabel.font=[UIFont systemFontOfSize:13];
    _promptLabel.textAlignment=NSTextAlignmentCenter;
    _promptLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_promptLabel];
    

    
    [self resetViews];
    
    [self resetLayoutSubViews];

}

- (void)resetViews
{
    _promptLabel.hidden=NO;
    _promptLabel.text=@"上拉加载更多";
    
    _loadingLabel.hidden=YES;
    _loadingLabel.text=@"正在加载...";
    
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
        
    /////
    NSLayoutConstraint * aTop=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:13];
    NSLayoutConstraint * aRight=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-5];
    NSLayoutConstraint * aWith=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:35];
    NSLayoutConstraint * aHeight=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:35];
    
    NSArray * aList=@[aTop,aRight,aWith,aHeight];
    
    [self addConstraints:aList];
    /////////////
    NSLayoutConstraint * tLeft=[NSLayoutConstraint constraintWithItem:self.loadingLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint * tTop=[NSLayoutConstraint constraintWithItem:self.loadingLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:0 constant:13];
    NSLayoutConstraint * tRight=[NSLayoutConstraint constraintWithItem:self.loadingLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint * tHeight=[NSLayoutConstraint constraintWithItem:self.loadingLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:32];
    
    NSArray * tList=@[tLeft,tTop,tRight,tHeight];
    
    [self addConstraints:tList];
    ///////
    NSDictionary * viewsDictionary=@{@"promptLabel":self.promptLabel};
    NSArray *pHList=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[promptLabel]-0-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *pVList=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[promptLabel(==45)]" options:0 metrics:nil views:viewsDictionary];
    
    [self addConstraints:pHList];
    [self addConstraints:pVList];
    
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
    _promptLabel.hidden=YES;
    _loadingLabel.hidden=NO;
    [self.activityIndicatorView startAnimating];
    
}
///结束
- (void)finishRefreshing
{
    [self resetViews];
}

@end
