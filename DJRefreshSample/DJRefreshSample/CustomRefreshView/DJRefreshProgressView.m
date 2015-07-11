//
//  RefreshProgressView.m
//  DJRefreshSample
//
//  Created by YDJ on 15/7/12.
//  Copyright (c) 2015年 ydj. All rights reserved.
//

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
    
    //// 底部灰色
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
        //_progress=0.01;
        
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
    
    [_progressView.layer removeAnimationForKey:@"rotationAnimation"];
    _progressView.transform=CGAffineTransformIdentity;
    
}


- (void)draggingProgress:(CGFloat)progress{

    _progressView.progress=progress;
    [_progressView setNeedsDisplay];
    
}







@end
