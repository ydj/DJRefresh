//
//  PullRefreshManager.m
//  PullRefreshControl
//
//  Created by YDJ on 14/11/3.
//  Copyright (c) 2014年 jingyoutimes. All rights reserved.
//

#import "RefreshControl.h"
#import "RefreshTopView.h"
#import "RefreshBottomView.h"
#import "RefreshViewDelegate.h"


@interface RefreshControl ()

@property (nonatomic,weak)id<RefreshControlDelegate>delegate;

@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UIView * bottomView;

@property (nonatomic,copy)NSString * topClass;
@property (nonatomic,copy)NSString * bottomClass;

@end

@implementation RefreshControl


- (void)registerClassForTopView:(Class)topClass
{
    if ([topClass conformsToProtocol:@protocol(RefreshViewDelegate)]) {
        self.topClass=NSStringFromClass([topClass class]);
    }
    else{
        self.topClass=NSStringFromClass([RefreshTopView class]);
    }
}
- (void)registerClassForBottomView:(Class)bottomClass
{
    if ([bottomClass conformsToProtocol:@protocol(RefreshViewDelegate)]) {
        self.bottomClass=NSStringFromClass([bottomClass class]);
    }
    else{
        self.bottomClass=NSStringFromClass([RefreshBottomView class]);
    }
    
    
}


- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<RefreshControlDelegate>)delegate
{
    self=[super init];
    if (self)
    {
        _scrollView=scrollView;
        _delegate=delegate;
        
        _topClass=NSStringFromClass([RefreshTopView class]);
        _bottomClass=NSStringFromClass([RefreshBottomView class]);
        
        self.enableInsetTop=65.0;
        self.enableInsetBottom=65.0;
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:NULL];


        
    }
    
    return self;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   if([keyPath isEqual:@"contentSize"])
    {
        if (self.topEnabled)
        {
            [self initTopView];
        }

        if (self.bottomEnabled)
        {
            [self initBottonView];
        }
    }
    else if([keyPath isEqualToString:@"contentOffset"])
    {
        [self _drogForChange:change];
    }
    
    
}

- (void)_drogForChange:(NSDictionary *)change
{

    if (self.topEnabled)
    {
        if(self.scrollView.contentOffset.y<-self.enableInsetTop)
        {
            if (_refreshingDirection==RefreshingDirectionNone)
            {
                if( self.scrollView.decelerating && self.scrollView.dragging==NO  )//&&
                {
                    [self _engageRefreshDirection:RefreshDirectionTop];
                }
                else{
                    ///
                    [self _canEngageRefreshDirection:RefreshDirectionTop];
                }
            }
            else{
                
            }
            
        }
        else if(self.scrollView.contentOffset.y<0)
        {
            if (_refreshingDirection==RefreshingDirectionNone)
            {
                [self _didDisengageRefreshDirection:RefreshDirectionTop];
            }
            
        }
    }
    
    if (self.bottomEnabled)
    {
        if (self.scrollView.contentOffset.y>0)
        {
            
            if(self.scrollView.contentOffset.y>(self.scrollView.contentSize.height+self.enableInsetBottom-self.scrollView.bounds.size.height))
            {
                if (_refreshingDirection==RefreshingDirectionNone)
                {
                    
                    if(self.scrollView.decelerating && self.scrollView.dragging==NO  )
                    {
                        [self _engageRefreshDirection:RefreshDirectionBottom];
                    }
                    else{
                        [self _canEngageRefreshDirection:RefreshDirectionBottom];
                    }
                     

                }
                
            }
            else{
                if (_refreshingDirection==RefreshingDirectionNone)
                {
                    [self _didDisengageRefreshDirection:RefreshDirectionBottom];
                }
            }
            
            
        }
        
    }
    
    
    
}


- (void)_canEngageRefreshDirection:(RefreshDirection) direction
{

    
    if (direction==RefreshDirectionTop)
    {
        [self.topView performSelector:@selector(canEngageRefresh)];
        //[self.topView canEngageRefresh];
    }
    else if (direction==RefreshDirectionBottom)
    {
        [self.bottomView performSelector:@selector(canEngageRefresh)];
        //[self.bottomView canEngageRefresh];
    }
}

- (void)_didDisengageRefreshDirection:(RefreshDirection) direction
{

    if (direction==RefreshDirectionTop)
    {
        [self.topView performSelector:@selector(didDisengageRefresh)];
        //[self.topView didDisengageRefresh];
    }
    else if (direction==RefreshDirectionBottom)
    {
        [self.bottomView performSelector:@selector(didDisengageRefresh)];
        //[self.bottomView didDisengageRefresh];
    }
}


- (void)_engageRefreshDirection:(RefreshDirection) direction
{
    
    UIEdgeInsets edge = UIEdgeInsetsZero;
    
    if (direction==RefreshDirectionTop)
    {
        _refreshingDirection=RefreshingDirectionTop;
        edge=UIEdgeInsetsMake(self.enableInsetTop, 0, 0, 0);

    }
    else if (direction==RefreshDirectionBottom)
    {
        
        edge=UIEdgeInsetsMake(0, 0, self.enableInsetBottom, 0);
        _refreshingDirection=RefreshingDirectionBottom;

    }
    _scrollView.contentInset=edge;

    [self _didEngageRefreshDirection:direction];

}

- (void)_didEngageRefreshDirection:(RefreshDirection) direction
{

    if (direction==RefreshDirectionTop)
    {
        [self.topView performSelector:@selector(startRefreshing)];
        //[self.topView startRefreshing];
    }
    else if (direction==RefreshDirectionBottom)
    {
        [self.bottomView performSelector:@selector(startRefreshing)];
       // [self.bottomView startRefreshing];
    }
    
    if ([self.delegate respondsToSelector:@selector(refreshControl:didEngageRefreshDirection:)])
    {
        [self.delegate refreshControl:self didEngageRefreshDirection:direction];
    }
    
    
}


- (void)_startRefreshingDirection:(RefreshDirection)direction animation:(BOOL)animation
{
    CGPoint point =CGPointZero;
    
    if (direction==RefreshDirectionTop)
    {
        point=CGPointMake(0, -self.enableInsetTop);
    }
    else if (direction==RefreshDirectionBottom)
    {
        float height=MAX(self.scrollView.contentSize.height, self.scrollView.frame.size.height);
        point=CGPointMake(0, height-self.scrollView.bounds.size.height+self.enableInsetBottom);
    }
    __weak typeof(self)weakSelf=self;

    [_scrollView setContentOffset:point animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self)strongSelf=weakSelf;
        [strongSelf _engageRefreshDirection:direction];
    });
    

}

- (void)_finishRefreshingDirection1:(RefreshDirection)direction animation:(BOOL)animation
{
    [UIView animateWithDuration:0.25 animations:^{
        
        _scrollView.contentInset=UIEdgeInsetsZero;

    } completion:^(BOOL finished) {
        
    }];
    
    _refreshingDirection=RefreshingDirectionNone;
    
    if (direction==RefreshDirectionTop)
    {
        [self.topView performSelector:@selector(finishRefreshing)];
        //[self.topView finishRefreshing];
    }
    else if(direction==RefreshDirectionBottom)
    {
        [self.bottomView performSelector:@selector(finishRefreshing)];
        //[self.bottomView finishRefreshing];
    }
    
}




- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}


- (void)initTopView
{
    
    if (!CGRectIsEmpty(self.scrollView.frame))
    {
        if (self.topView==nil)
        {
            Class className=NSClassFromString(self.topClass);
            
            _topView=[[className alloc] initWithFrame:CGRectMake(0, -100, self.scrollView.frame.size.width, self.enableInsetTop+35)];
            [self.scrollView addSubview:self.topView];
        }
        else{
            _topView.frame=CGRectMake(0, -100, self.scrollView.frame.size.width, self.enableInsetTop+35);
            
            [_topView performSelector:@selector(resetLayoutSubViews)];
            //[_topView resetLayoutSubViews];
        }
        
    }
    
}

- (void)initBottonView
{
    
    
    if (!CGRectIsNull(self.scrollView.frame))
    {
        float y=MAX(self.scrollView.bounds.size.height, self.scrollView.contentSize.height);
        if (self.bottomView==nil)
        {
            Class className=NSClassFromString(self.bottomClass);

            _bottomView=[[className alloc] initWithFrame:CGRectMake(0,y , self.scrollView.bounds.size.width, self.enableInsetBottom+35)];
            [self.scrollView addSubview:_bottomView];
        }
        else{
            _bottomView.frame=CGRectMake(0,y , self.scrollView.bounds.size.width, self.enableInsetBottom+35);
           
            [self.bottomView performSelector:@selector(resetLayoutSubViews)];
            //[self.bottomView resetLayoutSubViews];
        }
        
    }

    
}




- (void)setTopEnabled:(BOOL)topEnabled
{
    _topEnabled=topEnabled;
    
    if (_topEnabled)
    {
        if (self.topView==nil)
        {
            [self initTopView];
        }
        
    }
    else{
        [self.topView removeFromSuperview];
        self.topView=nil;
    }
    
}

- (void)setBottomEnabled:(BOOL)bottomEnabled
{
    _bottomEnabled=bottomEnabled;
    
    if (_bottomEnabled)
    {
        if (_bottomView==nil)
        {
            [self initBottonView];
        }
    }
    else{
        [_bottomView removeFromSuperview];
        _bottomView=nil;
    }
    
}



- (void)startRefreshingDirection:(RefreshDirection)direction
{
    
    [self _startRefreshingDirection:direction animation:YES];
    
}

- (void)finishRefreshingDirection:(RefreshDirection)direction
{
   
    [self _finishRefreshingDirection1:direction animation:YES];
    
 
}





@end
