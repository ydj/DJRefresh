//
//  RefreshBasicView.h
//  PullDJRefresh
//
//  Created by YDJ on 15/6/18.
//  Copyright (c) 2015年 YDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DJRefreshViewType){
    DJRefreshViewTypeDefine=0,
    DJRefreshViewTypeCanRefresh,
    DJRefreshViewTypeRefreshing
};


@interface DJRefreshView : UIView

@property (nonatomic,readonly)DJRefreshViewType refreshViewType;

- (void)reset;
- (void)canEngageRefresh;
- (void)didDisengageRefresh;
- (void)startRefreshing;
- (void)finishRefreshing;

- (void)pullProgress:(CGFloat)progress;

@end
