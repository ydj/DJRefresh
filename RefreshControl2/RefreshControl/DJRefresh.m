//
//  DJRefresh.m
//
//  Copyright (c) 2014 YDJ ( https://github.com/ydj/DJRefresh )
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

#import "DJRefresh.h"
#import "RefreshTopView.h"
#import "RefreshBottomView.h"
#import "RefreshViewDelegate.h"
#import "DJRefreshView.h"
#import "DJRefreshTopView.h"
#import "DJRefreshBottomView.h"

@interface DJRefresh ()


@property (nonatomic,strong)DJRefreshView * topView;
@property (nonatomic,strong)DJRefreshView * bottomView;

@property (nonatomic,copy)NSString * topClass;
@property (nonatomic,copy)NSString * bottomClass;

@property (nonatomic,copy)DJRefreshCompletionBlock comBlock;

@end

@implementation DJRefresh


- (void)registerClassForTopView:(Class)topClass
{
    if ([topClass isSubclassOfClass:[DJRefreshView class]]) {
        self.topClass=NSStringFromClass([topClass class]);
    }
    else{
        self.topClass=NSStringFromClass([DJRefreshTopView class]);
    }
}
- (void)registerClassForBottomView:(Class)bottomClass
{
    if ([bottomClass isSubclassOfClass:[DJRefreshView class]]) {
        self.bottomClass=NSStringFromClass([bottomClass class]);
    }
    else{
        self.bottomClass=NSStringFromClass([DJRefreshBottomView class]);
    }
    
}


+ (instancetype)refreshWithScrollView:(UIScrollView *)scrollView{
    __autoreleasing  DJRefresh *refresh=[[DJRefresh alloc] initWithScrollView:scrollView];
    return refresh;
}


- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<DJRefreshDelegate>)delegate
{
    if (self=[super init])
    {
        _scrollView=scrollView;
        _delegate=delegate;
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView{
    if (self=[super init]) {
        _scrollView=scrollView;
        [self setup];
    }
    return self;
}


- (void)setup{
    
    _topClass=NSStringFromClass([DJRefreshTopView class]);
    _bottomClass=NSStringFromClass([DJRefreshBottomView class]);
    
    self.enableInsetTop=65.0;
    self.enableInsetBottom=65.0;
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:NULL];
    
}

- (void)didRefreshCompletionBlock:(DJRefreshCompletionBlock)completionBlock{
    self.comBlock=completionBlock;
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
        if (_refreshingDirection==DJRefreshingDirectionNone) {
            [self _drogForChange:change];
        }
    }
    
    
}

- (void)_drogForChange:(NSDictionary *)change
{
    
    if ( self.topEnabled && self.scrollView.contentOffset.y<0)
    {
        if(self.scrollView.contentOffset.y<-self.enableInsetTop)
        {
            if (self.autoRefreshTop || ( self.scrollView.decelerating && self.scrollView.dragging==NO)) {
                [self _engageDJRefreshDirection:DJRefreshDirectionTop];
            }
            else {
                [self _canEngageDJRefreshDirection:DJRefreshDirectionTop];
            }
        }
        else
        {
            [self _didDisengageDJRefreshDirection:DJRefreshDirectionTop];
        }
    }
    
    if ( self.bottomEnabled && self.scrollView.contentOffset.y>0 )
    {
        
        if(self.scrollView.contentOffset.y>(self.scrollView.contentSize.height+self.enableInsetBottom-self.scrollView.bounds.size.height) )
        {
            if(self.autoRefreshBottom || (self.scrollView.decelerating && self.scrollView.dragging==NO)){
                [self _engageDJRefreshDirection:DJRefreshDirectionBottom];
            }
            else{
                [self _canEngageDJRefreshDirection:DJRefreshDirectionBottom];
            }
        }
        else {
            [self _didDisengageDJRefreshDirection:DJRefreshDirectionBottom];
        }
        
    }
    
    
    
}


- (void)_canEngageDJRefreshDirection:(DJRefreshDirection) direction
{
    
    
    if (direction==DJRefreshDirectionTop)
    {
        if (self.topView.refreshViewType!=DJRefreshViewTypeCanRefresh) {
            [self.topView canEngageRefresh];
        }
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        if (self.bottomView.refreshViewType!=DJRefreshViewTypeCanRefresh) {
            [self.bottomView canEngageRefresh];
        }
    }
}

- (void)_didDisengageDJRefreshDirection:(DJRefreshDirection) direction
{
    
    if (direction==DJRefreshDirectionTop)
    {
        if (self.topView.refreshViewType!=DJRefreshViewTypeDefine) {
            [self.topView didDisengageRefresh];
        }
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        if (self.bottomView.refreshViewType!=DJRefreshViewTypeDefine) {
            [self.bottomView didDisengageRefresh];
        }
    }
}


- (void)_engageDJRefreshDirection:(DJRefreshDirection) direction
{
    
    UIEdgeInsets edge = UIEdgeInsetsZero;
    
    if (direction==DJRefreshDirectionTop)
    {
        _refreshingDirection=DJRefreshingDirectionTop;
        float topH=self.enableInsetTop<45?45:self.enableInsetTop;
        edge=UIEdgeInsetsMake(topH, 0, 0, 0);///enableInsetTop
        
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        float botomH=self.enableInsetBottom<45?45:self.enableInsetBottom;
        edge=UIEdgeInsetsMake(0, 0, botomH, 0);///self.enableInsetBottom
        _refreshingDirection=DJRefreshingDirectionBottom;
        
    }
    _scrollView.contentInset=edge;
    
    [self _didEngageDJRefreshDirection:direction];
    
}

- (void)_didEngageDJRefreshDirection:(DJRefreshDirection) direction
{
    
    if (direction==DJRefreshDirectionTop)
    {
        if (self.topView.refreshViewType!=DJRefreshViewTypeRefreshing) {
            [self.topView startRefreshing];
        }
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        if (self.bottomView.refreshViewType!=DJRefreshViewTypeRefreshing) {
            [self.bottomView startRefreshing];
        }
    }
    
    if (self.comBlock) {
        @try {
            self.comBlock(self,direction,nil);
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(refreshControl:didEngageDJRefreshDirection:)])
    {
        [self.delegate refreshControl:self didEngageDJRefreshDirection:direction];
    }
    
    
}


- (void)_startDJRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation
{
    CGPoint point =CGPointZero;
    
    if (direction==DJRefreshDirectionTop)
    {
        float topH=self.enableInsetTop<45?45:self.enableInsetTop;
        point=CGPointMake(0, -topH);//enableInsetTop
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        float height=MAX(self.scrollView.contentSize.height, self.scrollView.frame.size.height);
        float bottomH=self.enableInsetBottom<45?45:self.enableInsetBottom;
        point=CGPointMake(0, height-self.scrollView.bounds.size.height+bottomH);///enableInsetBottom
    }
    
    __weak typeof(self)weakSelf=self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self)strongSelf=weakSelf;
        [_scrollView setContentOffset:point animated:animation];
        [strongSelf _engageDJRefreshDirection:direction];
    });
    
}

- (void)_finishDJRefreshingDirection1:(DJRefreshDirection)direction animation:(BOOL)animation
{
    
    if (animation) {
        [UIView animateWithDuration:0.25 animations:^{
            _scrollView.contentInset=UIEdgeInsetsZero;
        }];
    }else {
        _scrollView.contentInset=UIEdgeInsetsZero;
    }

    _refreshingDirection=DJRefreshingDirectionNone;
    
    if (direction==DJRefreshDirectionTop)
    {
        if (self.topView.refreshViewType!=DJRefreshViewTypeDefine) {
            [self.topView finishRefreshing];
        }
    }
    else if(direction==DJRefreshDirectionBottom)
    {
        if (self.bottomView.refreshViewType!=DJRefreshViewTypeDefine) {
        [self.bottomView finishRefreshing];
        }
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
        float topOffsetY=self.enableInsetTop+45;
        
        if (self.topView==nil)
        {
            Class className=NSClassFromString(self.topClass);
            
            _topView=[[className alloc] initWithFrame:CGRectMake(0, -topOffsetY, self.scrollView.frame.size.width, topOffsetY)];
            [self.scrollView addSubview:self.topView];
        }
        else{
            _topView.frame=CGRectMake(0, -topOffsetY, self.scrollView.frame.size.width, topOffsetY);
            
            [_topView layoutSubviews];
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
            
            _bottomView=[[className alloc] initWithFrame:CGRectMake(0,y , self.scrollView.bounds.size.width, self.enableInsetBottom+45)];
            [self.scrollView addSubview:_bottomView];
        }
        else{
            _bottomView.frame=CGRectMake(0,y , self.scrollView.bounds.size.width, self.enableInsetBottom+45);
            
            //[self.bottomView resetLayoutSubViews];
            [self.bottomView layoutSubviews];
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


- (void)startDJRefreshingDirection:(DJRefreshDirection)direction{
    
    [self startDJRefreshingDirection:direction animation:YES];
    
}
- (void)startDJRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation
{
    [self _startDJRefreshingDirection:direction animation:animation];
    
}

- (void)finishDJRefreshingDirection:(DJRefreshDirection)direction
{
    
    [self _finishDJRefreshingDirection1:direction animation:YES];
    
}

- (void)finishDJRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation{
    [self _finishDJRefreshingDirection1:direction animation:animation];
}





@end
