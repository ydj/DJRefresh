//
//  ViewController.m
//  PullRefreshControl
//
//  Created by YDJ on 14/11/3.
//  Copyright (c) 2014年 YDJ. All rights reserved.
//

#import "ViewController.h"
#import "RefreshControl.h"
#import "CollectionViewController.h"
#import "TableViewController.h"
#import "RefreshView.h"
#import "WebViewViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)RefreshControl * refresh;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent=NO;

    self.title=@"RefreshControl";
    
    ///1334-750
    ///1242-2202
    
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    NSArray *t1=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView":self.tableView}];
    NSArray *t2=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView":self.tableView}];
    
    [self.view addConstraints:t1];
    [self.view addConstraints:t2];

    ///初始化
    _refresh=[[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    ///设置显示下拉刷新
    _refresh.topEnabled=YES;
    ///注册自定义的下拉刷新view
    [_refresh registerClassForTopView:[RefreshView class]];
    

}

#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    if (direction==RefreshDirectionTop)
    {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl finishRefreshingDirection:RefreshDirectionTop];
        });
        
        
    }
    
}




#pragma mark - tableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"tableView";
    }
    else if (indexPath.row==1){
        cell.textLabel.text=@"collectionView";
    }
    else if (indexPath.row==2){
        cell.textLabel.text=@"webView";
    }else if (indexPath.row==3){
        cell.textLabel.text=@"tableHeaderView";
    }else if (indexPath.row==4){
        cell.textLabel.text=@"other";
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        
        TableViewController * tvc=[self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
        
        [self.navigationController pushViewController:tvc animated:YES];
        
    }
    else if (indexPath.row==1)
    {
        CollectionViewController * cc=[[CollectionViewController alloc] init];
        
        [self.navigationController pushViewController:cc animated:YES];
        
    }
    else if (indexPath.row==2){
        
        WebViewViewController * webView=[[WebViewViewController alloc] init];
        [self.navigationController pushViewController:webView animated:YES];
        
    }else if (indexPath.row==3){
        [self performSegueWithIdentifier:@"pushToTableHeader" sender:indexPath];
    }else if(indexPath.row==4){
        [self performSegueWithIdentifier:@"pushToSearchViewController" sender:indexPath];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
