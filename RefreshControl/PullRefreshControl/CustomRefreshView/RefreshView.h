//
//  RefreshView.h
//  PullRefreshControl
//
//  Created by YDJ on 14/11/3.
//  Copyright (c) 2014年 jingyoutimes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshViewDelegate.h"


/**
 *	自定义view
 */
@interface RefreshView : UIView<RefreshViewDelegate>

@property (nonatomic,strong)UIImageView * imageView;

- (void)resetLayoutSubViews;

- (void)canEngageRefresh;
- (void)didDisengageRefresh;
- (void)startRefreshing;
- (void)finishRefreshing;


@end





