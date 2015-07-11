//
//  TableViewController.m
//  DJRefreshSample
//
//  Created by YDJ on 15/6/24.
//  Copyright (c) 2015年 ydj. All rights reserved.
//

#import "TableViewController.h"
#import "DJRefresh.h"
#import "DJRefreshProgressView.h"


@interface TableViewController ()<DJRefreshDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)DJRefresh *refresh;
@property (nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic,weak)IBOutlet UITableView *tableView;
@end

@implementation TableViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _dataList=[[NSMutableArray alloc] init];
    
    for (NSInteger i=0; i<20; i++) {
        [self.dataList addObject:@""];
    }
    
    _refresh=[[DJRefresh alloc] initWithScrollView:self.tableView delegate:self];
    _refresh.topEnabled=YES;
    _refresh.bottomEnabled=YES;
    
    if (_type==eRefreshTypeProgress) {
        [_refresh registerClassForTopView:[DJRefreshProgressView class]];
    }
    
    
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    
    
}



- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDataWithDirection:direction];
    });
    
}

- (void)addDataWithDirection:(DJRefreshDirection)direction{
    
    if (direction==DJRefreshDirectionTop) {
        [_dataList removeAllObjects];
    }
    
    for (NSInteger i=0; i<20; i++) {
        [self.dataList addObject:@""];
    }
    
    [_refresh finishRefreshingDirection:direction animation:YES];
    
    [self.tableView reloadData];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}





@end
