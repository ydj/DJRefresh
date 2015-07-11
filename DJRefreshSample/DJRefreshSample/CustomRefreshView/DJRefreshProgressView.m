//
//  RefreshView.h
//
//  Copyright (c) 2014-2015 YDJ ( https://github.com/ydj/DJRefresh )
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

#import "DJRefreshProgressView.h"


@interface DJProgressView : UIView
@property (nonatomic,assign)CGFloat progress;
@end

@implementation DJProgressView

- (void)setProgress:(CGFloat)progress{
    
    _progress=progress;
    
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat lineWidth=5;
    
    CGFloat ovalPattern[] = {1, 1.5};
    
    CGFloat degrees= ((M_PI * (_progress*360))/ 180);
    
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2.0, rect.size.height/2.0)
                                                            radius:10
                                                        startAngle:-M_PI_2
                                                          endAngle:degrees-M_PI_2
                                                         clockwise:true];
    [[UIColor blackColor] setStroke];
    ovalPath.lineWidth = lineWidth;
    [ovalPath setLineDash: ovalPattern count: 2 phase: 0];
    [ovalPath stroke];
}


@end



@interface DJRefreshProgressView ()

@property (nonatomic,strong)DJProgressView *progressView;

@end

@implementation DJRefreshProgressView


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    _progressView=[[DJProgressView alloc] initWithFrame:CGRectZero];
    _progressView.translatesAutoresizingMaskIntoConstraints=NO;
    _progressView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_progressView];
    
    
    NSLayoutConstraint *centX=[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *bottom=[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *width=[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:45];
    NSLayoutConstraint *height=[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:45];
    
    NSArray *list=@[centX,bottom,width,height];
    
    [self addConstraints:list];
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)reset{
    [super reset];
    
    _progressView.progress=0;
    _progressView.transform=CGAffineTransformIdentity;

}


- (void)startRefreshing{
    
    [super startRefreshing];
    //开始刷新
    
    
    if (self.refreshViewType==DJRefreshViewTypeRefreshing) {
        _progressView.progress=1;
        
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 2.5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatDuration=INFINITY;
        
        [_progressView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    
   
    
}



- (void)finishRefreshing{
    [super finishRefreshing];
    //完成
    [_progressView.layer removeAnimationForKey:@"rotationAnimation"];
    _progressView.transform=CGAffineTransformIdentity;
    
}


- (void)draggingProgress:(CGFloat)progress{
///下拉进度
    _progressView.progress=progress;
    [_progressView setNeedsDisplay];
    
}







@end
