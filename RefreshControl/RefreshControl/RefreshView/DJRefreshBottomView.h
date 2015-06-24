//
//  DJRefreshBottomView.h
//  PullDJRefresh
//
//  Created by YDJ on 15/6/18.
//  Copyright (c) 2015年 YDJ. All rights reserved.
//

#import "DJRefreshView.h"

@interface DJRefreshBottomView : DJRefreshView

@property (nonatomic,strong)UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic,strong)UILabel *promptLabel;//上拉加载更多

@end
