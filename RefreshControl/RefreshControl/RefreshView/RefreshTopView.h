//
//  RefreshTopView.h
//  PullRefreshControl
//
//  Created by YDJ on 14/11/3.
//  Copyright (c) 2014年 jingyoutimes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshViewDelegate.h"

/**
 *	top View
 */
@interface RefreshTopView : UIView<RefreshViewDelegate>

@property (nonatomic,strong)UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)UILabel * promptLabel;

///重新布局
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
