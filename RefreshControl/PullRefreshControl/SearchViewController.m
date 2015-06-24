//
//  SearchViewController.m
//  PullDJRefresh
//
//  Created by YuDejian on 15/6/9.
//  Copyright (c) 2015年 YDJ. All rights reserved.
//

#import "SearchViewController.h"
#import "DJRefresh.h"


@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,DJRefreshDelegate>

@property (nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic,weak)IBOutlet UITableView *tableView;
@property (nonatomic,strong)DJRefresh *refreshController;

@property (nonatomic,weak)IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong)UISearchDisplayController *searchController;

@end

@implementation SearchViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _searchController=[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    _searchController.searchResultsDelegate=self;
    _searchController.searchResultsDataSource=self;
    
    
    _refreshController=[[DJRefresh alloc] initWithScrollView:self.tableView delegate:self];
    _refreshController.topEnabled=YES;
    _refreshController.bottomEnabled=YES;
    
    
}

- (void)refreshControl:(DJRefresh *)refreshControl didEngageDJRefreshDirection:(DJRefreshDirection)direction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadData];
    });
    
}

- (NSMutableArray *)dataList{
    
    if (!_dataList) {
        _dataList=[[NSMutableArray alloc] init];
    }
    return _dataList;
    
}


- (void)loadData{
    
    if (_refreshController.refreshingDirection==DJRefreshingDirectionTop) {
        [self.dataList removeAllObjects];
    }
    
    for (NSInteger i=0; i<20; i++) {
        [self.dataList addObject:@""];
    }
    
    if (_refreshController.refreshingDirection==DJRefreshingDirectionTop) {
        [_refreshController finishDJRefreshingDirection:DJRefreshDirectionTop];
        
    }else{
        [_refreshController finishDJRefreshingDirection:DJRefreshDirectionBottom];
        
    }
    
    [self.tableView reloadData];
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_searchController.searchResultsTableView) {
        static NSString *cellIndentifier=@"cell_search";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        }
        
        cell.textLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        return cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
        
        cell.textLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        return cell;
    }
    
    
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}



@end