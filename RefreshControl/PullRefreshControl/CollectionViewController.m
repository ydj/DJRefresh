//
//  CollectionViewController.m
//  PullRefreshControl
//
//  Created by YDJ on 14/11/4.
//  Copyright (c) 2014年 jingyoutimes. All rights reserved.
//

#import "CollectionViewController.h"

#import "RefreshControl.h"


@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,RefreshControlDelegate>

@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)RefreshControl * refreshControl;
@property (nonatomic,strong)NSMutableArray * dataList;

@end

@implementation CollectionViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;

    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    _dataList=[[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout * flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(80, 80);
    flowLayout.minimumLineSpacing=5;
    flowLayout.sectionInset=UIEdgeInsetsMake(0, 5, 0, 5);
    
    
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"h"];
    
    [self.view addSubview:self.collectionView];
    _collectionView.alwaysBounceVertical=YES;
   
    NSDictionary * viewDicationary=@{@"collectionView":_collectionView};
    NSArray * ch=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:viewDicationary];
    NSArray * cv=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:0 metrics:nil views:viewDicationary];
    
    [self.view addConstraints:ch];
    [self.view addConstraints:cv];
    
    
    _refreshControl=[[RefreshControl alloc] initWithScrollView:_collectionView delegate:self];
    _refreshControl.topEnabled=YES;
    
    
    [self dataADD];
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction
{
    
    if (direction==RefreshDirectionTop)
    {
        [self.dataList removeAllObjects];
        
    }
    else{
        
    }
    
    __weak typeof(self)weakSelf=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf=weakSelf;
        [strongSelf dataADD];
    });
   
    
}

- (void)viewDidAppear:(BOOL)animated
{

    [self.refreshControl startRefreshingDirection:RefreshDirectionTop];
}


- (void)dataADD
{
    
    
    
    
    for (int i=0; i<40; i++)
    {
        [self.dataList addObject:@""];
    }
    
    
    [self.collectionView reloadData];
    
    if (self.refreshControl.refreshingDirection==RefreshingDirectionTop)
    {
        [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (self.refreshControl.refreshingDirection==RefreshingDirectionBottom)
    {
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    }
    
    ///设置是否有下拉刷新
    if ([self.dataList count]>10)
    {
        self.refreshControl.bottomEnabled=YES;
    }
    else{
        self.refreshControl.bottomEnabled=NO;
    }
    
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataList count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"h" forIndexPath:indexPath ];
    cell.backgroundColor=[UIColor redColor];
    
    
    
    return cell;
    
    
}





@end
