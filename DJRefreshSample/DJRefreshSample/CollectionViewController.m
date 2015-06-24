//
//  CollectionViewController.m
//
//  Created by YDJ on 14/11/4.
//  Copyright (c) 2014年 YDJ. All rights reserved.
//

#import "CollectionViewController.h"
#import "DJRefresh.h"


@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DJRefreshDelegate>

@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)DJRefresh * refresh;
@property (nonatomic,strong)NSMutableArray * dataList;

@end

@implementation CollectionViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;

    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    _dataList=[[NSMutableArray alloc] init];
    
    for (NSInteger i=0; i<10; i++) {
        [self.dataList addObject:@""];
    }
    
    UICollectionViewFlowLayout * flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(80, 80);
    flowLayout.minimumLineSpacing=5;
    flowLayout.sectionInset=UIEdgeInsetsMake(0, 5, 0, 5);
    
    
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.collectionView];
    _collectionView.alwaysBounceVertical=YES;
   
    NSDictionary * viewDicationary=@{@"collectionView":_collectionView};
    NSArray * ch=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:viewDicationary];
    NSArray * cv=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[collectionView]-0-|" options:0 metrics:nil views:viewDicationary];
    
    [self.view addConstraints:ch];
    [self.view addConstraints:cv];
    
    
    _refresh=[[DJRefresh alloc] initWithScrollView:_collectionView delegate:self];
    _refresh.topEnabled=YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:NO];
    });
    

}

- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction
{
    
    __weak typeof(self)weakSelf=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf=weakSelf;
        [strongSelf addDataForDirection:direction];
    });
   
    
}


- (void)addDataForDirection:(DJRefreshDirection)direction
{
    
    
    if (_dataList==nil) {
        _dataList=[[NSMutableArray alloc] init];
    }
    
    if (self.refresh.refreshingDirection==DJRefreshingDirectionTop)
    {
        [self.dataList removeAllObjects];
        
    }
    
    
    for (int i=0; i<40; i++)
    {
        [self.dataList addObject:@""];
    }
    
    
    [self.refresh finishRefreshingDirection:direction animation:NO];
    
    [self.collectionView reloadData];
    
    
    
    ///设置是否有下拉刷新
    if ([self.dataList count]>10)
    {
        self.refresh.bottomEnabled=YES;
    }
    else{
        self.refresh.bottomEnabled=NO;
    }
    
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataList count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath ];
    cell.backgroundColor=[UIColor redColor];
    
    return cell;
    }





@end
