//
//  TableViewController.m
//  PullDJRefresh
//
//  Created by YDJ on 14/11/6.
//  Copyright (c) 2014年 YDJ. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()<UITableViewDataSource,UITableViewDelegate,DJRefreshDelegate>

@property (nonatomic,strong)NSMutableArray * dataList;

@property (nonatomic,strong)DJRefresh * refreshControl;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _dataList=[[NSMutableArray alloc] init];
    for (int i=0; i<20; i++)
    {
        [self.dataList addObject:@""];
    }
    
    
    //_refreshControl=[[DJRefresh alloc] initWithScrollView:self.tableView delegate:self];
    
    self.refreshControl=[DJRefresh refreshWithScrollView:self.tableView];
    
    [self.refreshControl didRefreshCompletionBlock:^(DJRefresh *refresh, DJRefreshDirection direction, NSDictionary *info) {
        
        if (direction==DJRefreshDirectionTop)
        {
            
            [self.dataList removeAllObjects];
            
        }
        else if (direction==DJRefreshDirectionBottom)
        {
            
        }        
        __weak typeof(self)weakSelf=self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf)strongSelf=weakSelf;
            [strongSelf reloadData];
        });
        
    }];
    
    _refreshControl.topEnabled=YES;
    _refreshControl.bottomEnabled=YES;
    
    [self.tableView reloadData];
    
    [self.refreshControl startDJRefreshingDirection:DJRefreshDirectionTop animation:YES];

    
}


- (void)viewDidAppear:(BOOL)animated
{

}

- (void)refreshControl:(DJRefresh *)refreshControl didEngageDJRefreshDirection:(DJRefreshDirection)direction
{
    if (direction==DJRefreshDirectionTop)
    {
        
        [self.dataList removeAllObjects];
        
    }
    else if (direction==DJRefreshDirectionBottom)
    {
        
    }
    
    
    __weak typeof(self)weakSelf=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf=weakSelf;
        [strongSelf reloadData];
    });
    
}

-(void)reloadData
{
    
    for (int i=0; i<20; i++)
    {
        [self.dataList addObject:@""];
    }
    
    [self.tableView reloadData];
    
    
    if (self.refreshControl.refreshingDirection==DJRefreshingDirectionTop)
    {
        [self.refreshControl finishDJRefreshingDirection:DJRefreshDirectionTop];
    }
    else if (self.refreshControl.refreshingDirection==DJRefreshingDirectionBottom)
    {
        [self.refreshControl finishDJRefreshingDirection:DJRefreshDirectionBottom];

    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    cell.textLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
