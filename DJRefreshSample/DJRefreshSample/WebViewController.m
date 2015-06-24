//
//  WebViewController.m
//  DJRefreshSample
//
//  Created by YDJ on 15/6/25.
//  Copyright (c) 2015年 ydj. All rights reserved.
//

#import "WebViewController.h"
#import "DJRefresh.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong)DJRefresh *refresh;
@end

@implementation WebViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    [self.webView loadRequest:req];
    
    _refresh=[[DJRefresh alloc] initWithScrollView:self.webView.scrollView];
    _refresh.topEnabled=YES;
    [_refresh didRefreshCompletionBlock:^(DJRefresh *refresh, DJRefreshDirection direction, NSDictionary *info) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_webView reload];
            [_refresh finishRefreshingDirection:direction animation:YES];
        });
        
        
    }];
    
    
    
    
    
    
}


@end
