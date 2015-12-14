//
//  Shangcheng_ST_Controller.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/29.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "Shangcheng_ST_Controller.h"
#import "Mydefine.h"
#import "ShangchengTableViewCell.h"
#import "FenleiView.h"
#import "GoodsDetailController.h"
#import "MessageFormat.h"
#import "ST_Goods.h"
#import "UIImageView+AFNetworking.h"
#import "AFAppDotNetAPIClient.h"
#import "Fenlei.h"
#import "MJRefresh.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"

#define REUSEIDENTIFIER @"shangchengfenleicollectionviewcell"

@interface Shangcheng_ST_Controller ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,FenleiViewDelegate>
{
    NSArray *_fenlei;
    NSMutableArray *_goods;
    
    UIRefreshControl *_refresh;
    UIView *_searchzhedang;
    NSString *_selectedFenleiID;
}
@property(nonatomic,retain)FenleiView *fenleiview;
@end

@implementation Shangcheng_ST_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.searchBar.backgroundImage=[UIImage imageNamed:@"background_color.png"];
    [self setSearchTextFieldBackgroundColor:UIColorFromRGB(0xececec)];
    self.searchView.backgroundColor=UIColorFromRGB(0xffffff);
    self.tableView.backgroundColor=self.searchView.backgroundColor;
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _selectedFenleiID=@"0";
    [self setbeginRefreshing];
    
    
    [self.fenleiBtn addTarget:self action:@selector(fenlei) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *fenleitap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fenlei)];
    self.fenleiLab.userInteractionEnabled=YES;
    [self.fenleiLab addGestureRecognizer:fenleitap];

    
    [[AFAppDotNetAPIClient sharedClient] POST:SortList.URLEncodedString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSArray *array=responseObject[@"data"];
            NSMutableArray *fenleis=[NSMutableArray array];
            for (NSDictionary *dict in array) {
                [fenleis addObject:[Fenlei fenleiWithDict:dict]];
//                [fenleis addObject:dict[@"SortName"]];
            }
            self.fenleiview=[[FenleiView alloc] initWithOrigin:CGPointMake(0, 0) width:self.view.frame.size.width items:fenleis delegate:self];
            [self.fenleiSuperView addSubview:self.fenleiview];
        }
        
    } failure:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor
{
    UIView *searchTextField = nil;
    
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    self.searchBar.barTintColor = [UIColor whiteColor];
    searchTextField = [[[self.searchBar.subviews firstObject] subviews] lastObject];
    
    
    searchTextField.backgroundColor = backgroundColor;
}

-(void)hidefenlei
{
    [self.searchBar endEditing:YES];
    self.fenleiSuperView.hidden=YES;
    self.fenleiSuperView.center=CGPointMake(self.view.frame.size.width/2, self.fenleiSuperView.frame.size.height);
}
-(void)fenlei
{
    [self endsearch];
    self.fenleiSuperView.hidden=!self.fenleiSuperView.hidden;
    if (self.fenleiSuperView.hidden) {
        self.fenleiSuperView.center=CGPointMake(self.view.frame.size.width/2, self.fenleiSuperView.frame.size.height);
    }else{
        self.fenleiSuperView.center=self.tableView.center;
    }
}

-(void)fenxiang:(UIButton *)sender
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        ST_Goods *g=_goods[sender.tag];
        
        AppDelegate *myapp=[UIApplication sharedApplication].delegate;
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:nil
                                           defaultContent:@"商城"
                                                    image:[ShareSDK imageWithUrl:g.banner]
                                                    title:g.name
                                                      url:[NSString stringWithFormat:@"%@/Share/Share/shopindex/sharecode/%@/shopid/%@",AFAppDotNetAPIBaseURLString,myapp.user.shareCode,g.ID]
                                              description:@"全民经纪人-商城"
                                                mediaType:SSPublishContentMediaTypeNews];
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
//        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
        
        
        NSArray *shareList = [ShareSDK customShareListWithType:
                              SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                              SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),nil];
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:shareList
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                        [MessageFormat hintWithMessage:@"分享成功" inview:self.view completion:nil];
                                        [[AFAppDotNetAPIClient sharedClient] POST:ShopShareSucess parameters:@{@"UserId":myapp.user.ID,@"ShopId":g.ID,@"Code":myapp.user.shareCode,@"Type":type==ShareTypeWeixiSession?@"2":@"1"} success:^(NSURLSessionDataTask *task, id responseObject) {
                                            
                                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            NSLog(@"fail");
                                        }];
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    }
                                }];
        
    }else{
        [MessageFormat hintWithMessage:@"请安装微信" inview:self.view completion:^{
            
        }];
    }

}

#pragma mark - UITableView数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView.frame.size.width-20)/2+63;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _goods.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShangchengTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"shangchengtableviewcell"];
    if (cell==nil) {
        cell=[[UINib nibWithNibName:@"ShangchengTableViewCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    }
    ST_Goods *g=_goods[indexPath.row];

    [cell.shangpinImg setImageWithURL:[NSURL URLWithString:g.banner.URLEncodedString] placeholderImage:[UIImage imageNamed:@"picture_default_ST.jpg"]];
    cell.fenleiLab.text=g.name;
    cell.priceLab.text=g.price;
    cell.backgroundColor=tableView.backgroundColor;
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    cell.fenxiangBtn.tag=indexPath.row;
    [cell.fenxiangBtn addTarget:self action:@selector(fenxiang:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view=[[UIView alloc] initWithFrame:cell.bounds];
    view.backgroundColor=[UIColor clearColor];
    [cell setSelectedBackgroundView:view];
    
    return cell;
}

#pragma mark - UITableView代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ST_Goods *g=_goods[indexPath.row];
    GoodsDetailController *rootcontroller=[[GoodsDetailController alloc] init];
    rootcontroller.shop=g;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:rootcontroller];
    nav.navigationBar.barTintColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    nav.navigationBar.tintColor=[UIColor whiteColor];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self.parentViewController presentViewController:nav animated:YES completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}

#pragma mark - UISearchBar代理方法

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self hidefenlei];
    
    if (_searchzhedang==nil) {
        _searchzhedang=[[UIView alloc] initWithFrame:self.tableView.frame];
        _searchzhedang.backgroundColor=[UIColor blackColor];
        _searchzhedang.alpha=0.7;
        _searchzhedang.userInteractionEnabled=YES;
        [self.view addSubview:_searchzhedang];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endsearch)];
        [_searchzhedang addGestureRecognizer:tap];
    }
    return YES;
}

-(void)endsearch
{
    if (_searchzhedang) {
        [_searchzhedang removeFromSuperview];
        _searchzhedang=nil;
    }
    [self.searchBar endEditing:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length<1) {
        [self refershData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self endsearch];
    
    [MessageFormat POST:ShopList parameters:@{@"Name":searchBar.text,@"SortId":_selectedFenleiID} success:^(NSURLSessionDataTask *task, id responseObject) {
        _goods=[NSMutableArray array];
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSArray *array=responseObject[@"data"];
            for (NSDictionary *dict in array) {
                ST_Goods *g=[ST_Goods goodWihtDict:dict];
                [_goods addObject:g];
            }
            
        }else{
            [MessageFormat hintWithMessage:@"没有找到对应的商品" inview:self.view completion:nil];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self.parentViewController view:self.parentViewController.view];
    

    [searchBar endEditing:YES];
}

#pragma mark - FenleiView代理方法

-(void)searchFenlei:(UITapGestureRecognizer *)gesture
{
    for (UIView *view in _fenleiview.subviews) {
        if (view.class==[UILabel class]) {
            if (CGColorEqualToColor(view.layer.borderColor, UIColorFromRGB(MAIN_COLOR_VALUE).CGColor)) {
                view.layer.borderColor=UIColorFromRGB(0xe4e4e4).CGColor;
                break;
            }
        }
    }
    
    _selectedFenleiID=[NSString stringWithFormat:@"%li",(long)gesture.view.tag];
    gesture.view.layer.borderColor=UIColorFromRGB(MAIN_COLOR_VALUE).CGColor;
    
    [self hidefenlei];
    [MessageFormat POST:ShopList parameters:@{@"SortId":_selectedFenleiID} success:^(NSURLSessionDataTask *task, id responseObject) {
        _goods=[NSMutableArray array];
        
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSArray *array=responseObject[@"data"];
            for (NSDictionary *dict in array) {
                ST_Goods *g=[ST_Goods goodWihtDict:dict];
                [_goods addObject:g];
            }
            
        }else{
            [MessageFormat hintWithMessage:@"该分类下无商品" inview:self.view completion:nil];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self.parentViewController view:self.parentViewController.view];
}

#pragma mark - 开始刷新函数
- (void)setbeginRefreshing
{
 
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refershData)];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开马上刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中 ..." forState:MJRefreshStateRefreshing];
    
    
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置刷新控件
    self.tableView.header = header;
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadMoreData
{
    [[AFAppDotNetAPIClient sharedClient] POST:ShopList.URLEncodedString parameters:@{@"SortId":_selectedFenleiID,@"Start":[NSString stringWithFormat:@"%lu",(unsigned long)_goods.count]} success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.footer endRefreshing];
        
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSArray *array=responseObject[@"data"];
            for (NSDictionary *dict in array) {
                ST_Goods *g=[ST_Goods goodWihtDict:dict];
                [_goods addObject:g];
            }
            [self.tableView reloadData];
            
        }else if(statuscode.intValue==1001){
//            [self.tableView.footer noticeNoMoreData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.footer endRefreshing];
    }];

}

-(void)refershData
{
    [[AFAppDotNetAPIClient sharedClient] POST:ShopList.URLEncodedString parameters:@{@"SortId":_selectedFenleiID,@"Name":self.searchBar.text} success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.header endRefreshing];
        _goods=[NSMutableArray array];
        
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSArray *array=responseObject[@"data"];
            
            for (NSDictionary *dict in array) {
                ST_Goods *g=[ST_Goods goodWihtDict:dict];
                [_goods addObject:g];
            }
            
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

@end
