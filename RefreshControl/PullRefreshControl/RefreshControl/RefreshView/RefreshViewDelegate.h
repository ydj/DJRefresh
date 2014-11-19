//
//  RefreshViewDelegate.h
//  PullRefreshControl
//
//  Created by YDJ on 14/11/19.
//  Copyright (c) 2014年 jingyoutimes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RefreshViewDelegate <NSObject>

@required
- (void)resetLayoutSubViews;
///松开可刷新
- (void)canEngageRefresh;
///松开返回
- (void)didDisengageRefresh;
///开始刷新
- (void)startRefreshing;
///结束
- (void)finishRefreshing;


@end
