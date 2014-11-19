//
//  PullRefreshManager.h
//  PullRefreshControl
//
//  Created by YDJ on 14/11/3.
//  Copyright (c) 2014年 jingyoutimes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 * 当前refreshing状态
 */
typedef enum {
    RefreshingDirectionNone    = 0,
    RefreshingDirectionTop     = 1 << 0,
    RefreshingDirectionBottom  = 1 << 1
} RefreshingDirections;

/**
 *  指定回调方向
 */
typedef enum {
    RefreshDirectionTop = 0,
    RefreshDirectionBottom
} RefreshDirection;


@protocol RefreshControlDelegate;


/**
 *	下拉刷新-上拉加载更多
 */
@interface RefreshControl : NSObject

///当前的状态
@property (nonatomic,assign,readonly)RefreshingDirections refreshingDirection;

@property (nonatomic,readonly)UIScrollView * scrollView;


- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<RefreshControlDelegate>)delegate;


///是否开启下拉刷新，YES-开启 NO-不开启 默认是NO
@property (nonatomic,assign)BOOL topEnabled;
///是否开启上拉加载更多，YES-开启 NO-不开启 默认是NO
@property (nonatomic,assign)BOOL bottomEnabled;

///下拉刷新 状态改变的距离 默认65.0
@property (nonatomic,assign)float enableInsetTop;
///上拉 状态改变的距离 默认65.0
@property (nonatomic,assign)float enableInsetBottom;

/**
 *	注册Top加载的view,view必须接受RefreshViewDelegate协议,默认是RefreshTopView
 *	@param topClass 类类型
 */
- (void)registerClassForTopView:(Class)topClass;
/**
 *	注册Bottom加载的view,view必须接受RefreshViewDelegate协议,默认是RefreshBottomView
 *	@param topClass 类类型
 */
- (void)registerClassForBottomView:(Class)topClass;


///开始
- (void)startRefreshingDirection:(RefreshDirection)direction;

///完成
- (void)finishRefreshingDirection:(RefreshDirection)direction;


@end


/**
 *	代理方法
 */
@protocol RefreshControlDelegate <NSObject>


@optional
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction;




@end



