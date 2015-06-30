//
//  SampleViewController.m
//  DJRefreshSample
//
//  Created by YDJ on 15/6/24.
//  Copyright (c) 2015年 ydj. All rights reserved.
//

#import "SampleViewController.h"
#import "DJRefresh.h"
#import "SampleRefreshView.h"

@interface SampleViewController ()<UITableViewDataSource,UITableViewDelegate,DJRefreshDelegate>

@property (nonatomic,strong)NSArray *dataList;

@property (nonatomic,weak)IBOutlet UITableView *tableView;

@property (nonatomic,strong)DJRefresh *refresh;

@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title=@"DJRefresh";
    
    _dataList=@[@"tableView",@"collectionView",@"WebView"];
    
    SampleRefreshView *refreshView=[[SampleRefreshView alloc] initWithFrame:CGRectZero];
    [refreshView didDraggingProgressCompletionBlock:^(DJRefreshView *refreshView, CGFloat progress, NSDictionary *info) {
       // NSLog(@"拉动进度%.2f",progress);
    }];
    
    
    _refresh=[DJRefresh refreshWithScrollView:self.tableView];
    _refresh.delegate=self;
    _refresh.topEnabled=YES;
    _refresh.topRefreshView=refreshView;
//    _refresh.autoRefreshTop=YES;

//    [_refresh registerClassForTopView:[SampleRefreshView class]];
    
    
    
    
}

- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [refresh finishRefreshingDirection:direction animation:YES];
        
    });
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"baseCell" forIndexPath:indexPath];
    cell.textLabel.text=_dataList[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        [self performSegueWithIdentifier:@"pushToTable" sender:indexPath];
    }else if (indexPath.row==1){
        [self performSegueWithIdentifier:@"pushToCollection" sender:indexPath];
    }else if (indexPath.row==2){
        [self performSegueWithIdentifier:@"pushToWEB" sender:indexPath];
    }
    
    
}



@end
