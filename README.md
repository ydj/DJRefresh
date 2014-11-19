RefreshControl
==============

[RefreshControl]('https://github.com/ydj/RefreshControl') 是一个下拉刷新，上拉加载更多的组件
系统支持`iOS6+`
支持横竖屏切换，支持自定义下拉`View`和加载`View`，继承自`UIScrollView`的控件都可以使用




### 使用简单
```
	///初始化
    _refresh=[[RefreshControl alloc] initWithScrollView:tableView delegate:self];
    ///设置显示下拉刷新
    _refresh.topEnabled=YES;
    ///显示加载更多
    _refresh.bottomEnabled=YES;

```
实现代理方法，去刷新或者加载数据
```
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
```

###自定义加载样式
支持自定义样式，只需要继承`UIView`，接受`RefreshViewDelegate`协议，实现里面的方法，注册一下该类即可.
如自定义的控件是`RefreshView ` ：
```
 ///注册自定义的下拉刷新view
 [_refresh registerClassForTopView:[RefreshView class]];
```

####其他
  	1.设置下拉改变状态的位置`enableInsetTop` 默认65.0
  	2.设置上拉改变状态的位置`enableInsetBottom` 默认65.0
	4.下拉到指定位置自动刷新`autoRefreshTop`  默认NO
	5.上拉到指定位置自动加载`autoRefreshBottom`  默认NO
	




 


