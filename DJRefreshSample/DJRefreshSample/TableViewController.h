//
//  TableViewController.h
//  DJRefreshSample
//
//  Created by YDJ on 15/6/24.
//  Copyright (c) 2015年 ydj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, eRefreshType){
    eRefreshTypeDefine=0,
    eRefreshTypeProgress=1
};

@interface TableViewController : UIViewController

@property (nonatomic,assign)eRefreshType type;

@end
