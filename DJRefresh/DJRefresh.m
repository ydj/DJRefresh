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
        CGFloat progress=self.scrollView.contentOffset.y/(-self.enableInsetTop);
        progress=MIN(1, MAX(progress, 0));
        [self _didDraggingProgress:progress direction:DJRefreshDirectionTop];
        
        if(self.scrollView.contentOffset.y<=-self.enableInsetTop)
        {
            if (self.autoRefreshTop || ( self.scrollView.decelerating && self.scrollView.dragging==NO)) {
                [self _engageRefreshDirection:DJRefreshDirectionTop];
            }
            else {
                [self _canEngageRefreshDirection:DJRefreshDirectionTop];
            }
        }
        else
        {
            [self _didDisengageRefreshDirection:DJRefreshDirectionTop];
        }
    }
    
    if ( self.bottomEnabled && self.scrollView.contentOffset.y>0 )
    {
        
        if (self.scrollView.contentOffset.y>(self.scrollView.contentSize.height-self.scrollView.bounds.size.height)) {
            CGFloat progress=(self.scrollView.contentOffset.y-(self.scrollView.contentSize.height-self.scrollView.bounds.size.height))/self.enableInsetBottom;
            progress=MIN(1, MAX(progress, 0));
            [self _didDraggingProgress:progress direction:DJRefreshDirectionBottom];
        }
        
        if(self.scrollView.contentOffset.y>=(self.scrollView.contentSize.height+self.enableInsetBottom-self.scrollView.bounds.size.height) )
        {
            if(self.autoRefreshBottom || (self.scrollView.decelerating && self.scrollView.dragging==NO)){
                [self _engageRefreshDirection:DJRefreshDirectionBottom];
            }
            else{
                [self _canEngageRefreshDirection:DJRefreshDirectionBottom];
            }
        }
        else {
            [self _didDisengageRefreshDirection:DJRefreshDirectionBottom];
        }
        
    }
    
    
    
}


- (void)_didDraggingProgress:(CGFloat)progress direction:(DJRefreshDirection)direction{
    if (direction==DJRefreshDirectionTop) {
        [self.topView draggingProgress:progress];
    }else if (direction==DJRefreshDirectionBottom){
        [self.bottomView draggingProgress:progress];
    }
}

- (void)_canEngageRefreshDirection:(DJRefreshDirection) direction
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

- (void)_didDisengageRefreshDirection:(DJRefreshDirection) direction
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


- (void)_engageRefreshDirection:(DJRefreshDirection) direction
{
    
    UIEdgeInsets edge = UIEdgeInsetsZero;
    
    if (direction==DJRefreshDirectionTop)
    {
        _refreshingDirection=DJRefreshingDirectionTop;
        CGFloat topH=self.enableInsetTop<45?45:self.enableInsetTop;
        if (self.isDisableAddTop) {
            topH=0;
        }
        edge=UIEdgeInsetsMake(topH, 0, 0, 0);///enableInsetTop
        
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        CGFloat botomH=self.enableInsetBottom<45?45:self.enableInsetBottom;
        if (self.isDisableAddBottom) {
            botomH=0;
        }
        edge=UIEdgeInsetsMake(0, 0, botomH, 0);///self.enableInsetBottom
        _refreshingDirection=DJRefreshingDirectionBottom;
        
    }
    _scrollView.contentInset=edge;
    
    [self _didEngageRefreshDirection:direction];
    
}

- (void)_didEngageRefreshDirection:(DJRefreshDirection) direction
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
    
    if ([self.delegate respondsToSelector:@selector(refresh:didEngageRefreshDirection:)])
    {
        [self.delegate refresh:self didEngageRefreshDirection:direction];
    }
    
    
}


- (void)_startRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation
{
    CGPoint point =CGPointZero;
    
    if (direction==DJRefreshDirectionTop)
    {
        CGFloat topH=self.enableInsetTop<45?45:self.enableInsetTop;
        if (self.isDisableAddTop) {
            topH=0;
        }
        point=CGPointMake(0, -topH);//enableInsetTop
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        CGFloat height=MAX(self.scrollView.contentSize.height, self.scrollView.frame.size.height);
        CGFloat bottomH=self.enableInsetBottom<45?45:self.enableInsetBottom;
        if (self.isDisableAddBottom) {
            bottomH=0;
        }
        point=CGPointMake(0, height-self.scrollView.bounds.size.height+bottomH);///enableInsetBottom
    }
    
    __weak typeof(self)weakSelf=self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self)strongSelf=weakSelf;
        [_scrollView setContentOffset:point animated:animation];
        [strongSelf _engageRefreshDirection:direction];
    });
    
}

- (void)_finishRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation
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
        
        Class className=NSClassFromString(self.topClass);

        if (self.topView==nil || ![self.topView isKindOfClass:className])
        {
            [self.topView removeFromSuperview];
            self.topView=nil;
            _topView=[[className alloc] initWithFrame:CGRectMake(0, -topOffsetY, self.scrollView.frame.size.width, topOffsetY)];
            
            if (!self.isDisableAddTop) {
                [self.scrollView addSubview:self.topView];
            }
            
        }
        else{
            
            _topView.frame=CGRectMake(0, -topOffsetY, self.scrollView.frame.size.width, topOffsetY);
            
            [_topView layoutSubviews];
        }
        
        if (!self.isDisableAddTop && ![[self.scrollView subviews] containsObject:self.topView]) {
            [self.scrollView addSubview:self.topView];
        }
        
    }
    
}

- (void)initBottonView
{
    
    
    if (!CGRectIsNull(self.scrollView.frame))
    {
        float y=MAX(self.scrollView.bounds.size.height, self.scrollView.contentSize.height);
        Class className=NSClassFromString(self.bottomClass);
        if (self.bottomView==nil || ![self.bottomView isKindOfClass:className])
        {
            [self.bottomView removeFromSuperview];
            self.bottomView=nil;
            _bottomView=[[className alloc] initWithFrame:CGRectMake(0,y , self.scrollView.bounds.size.width, self.enableInsetBottom+45)];
            
            if (!self.isDisableAddBottom) {
                [self.scrollView addSubview:_bottomView];
            }
        }
        else{
            
            _bottomView.frame=CGRectMake(0,y , self.scrollView.bounds.size.width, self.enableInsetBottom+45);
            
            [self.bottomView layoutSubviews];
        }
        
        
        if (!self.isDisableAddBottom && ![[self.scrollView subviews] containsObject:self.bottomView]) {
            [self.scrollView addSubview:_bottomView];
        }
        
    }
    
    
}


- (void)setIsDisableAddTop:(BOOL)isDisableAddTop{
    _isDisableAddTop=isDisableAddTop;
    if (_isDisableAddTop && [[self.scrollView subviews] containsObject:self.topView]) {
        [self.topView removeFromSuperview];
    }
}

- (void)setIsDisableAddBottom:(BOOL)isDisableAddBottom{
    
    _isDisableAddBottom=isDisableAddBottom;
    if (_isDisableAddBottom && [[self.scrollView subviews] containsObject:self.bottomView]) {
        [self.bottomView removeFromSuperview];
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


- (void)startRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation
{
    [self _startRefreshingDirection:direction animation:animation];
    
}

- (void)finishRefreshingDirection:(DJRefreshDirection)direction animation:(BOOL)animation{
    [self _finishRefreshingDirection:direction animation:animation];
}





@end
