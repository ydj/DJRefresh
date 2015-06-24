//
//  RefreshBasicView.m
//  PullDJRefresh
//
//  Created by YDJ on 15/6/18.
//  Copyright (c) 2015年 YDJ. All rights reserved.
//

#import "DJRefreshView.h"

@implementation DJRefreshView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
}




///重新布局
- (void)reset{
    _refreshViewType=DJRefreshViewTypeDefine;
}

///松开可刷新
- (void)canEngageRefresh{
    _refreshViewType=DJRefreshViewTypeCanRefresh;

}
///松开返回
- (void)didDisengageRefresh{
    [self reset];
}
///开始刷新
- (void)startRefreshing{
    _refreshViewType=DJRefreshViewTypeRefreshing;

}
///结束
- (void)finishRefreshing{
    [self reset];
}


- (void)pullProgress:(CGFloat)progress{
    
}




@end
