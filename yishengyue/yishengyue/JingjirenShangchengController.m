//
//  JingjirenShangchengController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/23.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "JingjirenShangchengController.h"
#import "SHLineGraphView.h"
#import "SHPlot.h"
#import "Mydefine.h"
#import "NSDictionary+GetObjectBykey.h"
#import "MessageFormat.h"
#import "AppDelegate.h"
#import "JingjirenShangchengCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+PriceString.h"
#import "MJRefresh.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import "UIWindow+YUBottomPoper.h"

#define REUSEIDENTIFIER @"jingjirenshangchengcell"

@interface JingjirenShangchengController ()<UICollectionViewDataSource>
{
    NSArray *_points;
    AppDelegate *_myapp;
    
    NSMutableArray *_shopList;
}
@property (weak, nonatomic) IBOutlet SHLineGraphView *chartView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation JingjirenShangchengController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set the main graph area theme attributes
    
     _myapp=[UIApplication sharedApplication].delegate;
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.helpBtn.imageView.contentMode=self.backBtn.imageView.contentMode;
    
    self.view.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.titleBar.backgroundColor=self.view.backgroundColor;
    self.chartView.backgroundColor=self.view.backgroundColor;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"JingjirenShangchengCell" bundle:nil] forCellWithReuseIdentifier:REUSEIDENTIFIER];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    
    CGFloat itemjiange=10.0f;
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    CGFloat cellwidth=(self.view.frame.size.width-itemjiange*3)/2;
    CGFloat cellheight=(cellwidth-10)/2+64;
    layout.itemSize=CGSizeMake(cellwidth,cellheight);
    layout.sectionInset=UIEdgeInsetsMake(itemjiange, itemjiange,itemjiange,itemjiange);
    layout.minimumInteritemSpacing=itemjiange;
    layout.minimumLineSpacing=itemjiange;
    self.collectionView.collectionViewLayout=layout;
    
    self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    [[AFAppDotNetAPIClient sharedClient] POST:sharelist parameters:@{@"UserId":_myapp.user.ID,@"Start":[NSString stringWithFormat:@"%li",_shopList.count]} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _shopList=[NSMutableArray arrayWithArray:responseObject[@"data"]];
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MessageFormat POST:BrokenLine parameters:@{@"UserId":_myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _points=responseObject[@"data"];
            [self drawChart];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } incontroller:self view:self.view];
}
#pragma mark -------------------------------

-(void)drawChart
{
    /**
     *  theme attributes dictionary. you can specify graph theme releated attributes in this dictionary. if this property is
     *  nil, then a default theme setting is applied to the graph.
     */
    NSDictionary *_themeAttributes = @{
                                       kXAxisLabelColorKey : [UIColor whiteColor],
                                       kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                       kYAxisLabelColorKey : [UIColor whiteColor],
                                       kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                       kYAxisLabelSideMarginsKey : @20,
                                       kPlotBackgroundLineColorKye : [UIColor whiteColor]
                                       };
    self.chartView.themeAttributes = _themeAttributes;
    
    //set the line graph attributes
    
    /**
     *  the maximum y-value possible in the graph. make sure that the y-value is not in the plotting points is not greater
     *  then this number. otherwise the graph plotting will show wrong results.
     */
    self.chartView.yAxisRange = @(35);
    
    /**
     *  y-axis values are calculated according to the yAxisRange passed. so you do not have to pass the explicit labels for
     *  y-axis, but if you want to put any suffix to the calculated y-values, you can mention it here (e.g. K, M, Kg ...)
     */
    self.chartView.yAxisSuffix = @"";
    
    /**
     *  an Array of dictionaries specifying the key/value pair where key is the object which will identify a particular
     *  x point on the x-axis line. and the value is the label which you want to show on x-axis against that point on x-axis.
     *  the keys are important here as when plotting the actual points on the graph, you will have to use the same key to
     *  specify the point value for that x-axis point.
     */
    
    NSMutableArray *xAxisValues=[NSMutableArray array];
    for (int i=0; i<_points.count; i++) {
        NSDictionary *d=_points[_points.count-1-i];
        [xAxisValues addObject:@{[NSNumber numberWithInt:i+1]:[d getObjectByKey:@"PayTime"]}];
    }
    self.chartView.xAxisValues=xAxisValues;
//    self.chartView.xAxisValues = @[
//                                   @{ @1 : @"7.15" },
//                                   @{ @2 : @"7.16" },
//                                   @{ @3 : @"7.17" },
//                                   @{ @4 : @"7.18" },
//                                   @{ @5 : @"7.19" },
//                                   @{ @6 : @"7.20" },
//                                   @{ @7 : @"7.21" }
//                                   ];
    
    //create a new plot object that you want to draw on the `_lineGraph`
    SHPlot *_plot1 = [[SHPlot alloc] init];
    
    //set the plot attributes
    
    /**
     *  Array of dictionaries, where the key is the same as the one which you specified in the `xAxisValues` in `SHLineGraphView`,
     *  the value is the number which will determine the point location along the y-axis line. make sure the values are not
     *  greater than the `yAxisRange` specified in `SHLineGraphView`.
     */
    NSMutableArray *plottingValues=[NSMutableArray array];
    for (int i=0; i<_points.count; i++) {
        NSDictionary *d=_points[_points.count-1-i];
        NSString *numberString=[d getObjectByKey:@"Num"];
        [plottingValues addObject:@{[NSNumber numberWithInt:i+1]:[NSNumber numberWithInt:numberString.intValue]}];
    }
    _plot1.plottingValues=plottingValues;
//    _plot1.plottingValues = @[
//                              @{ @1 : @7 },
//                              @{ @2 : @17 },
//                              @{ @3 : @14 },
//                              @{ @4 : @50 },
//                              @{ @5 : @10 },
//                              @{ @6 : @12 },
//                              @{ @7 : @8 }
//                              ];
    
    /**
     *  this is an optional array of `NSString` that specifies the labels to show on the particular points. when user clicks on
     *  a particular points, a popover view is shown and will show the particular label on for that point, that is specified
     *  in this array.
     */
    NSArray *arr = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7"];
    _plot1.plottingPointsLabels = arr;
    
    //set plot theme attributes
    
    /**
     *  the dictionary which you can use to assing the theme attributes of the plot. if this property is nil, a default theme
     *  is applied selected and the graph is plotted with those default settings.
     */
    
    NSDictionary *_plotThemeAttributes = @{
                                           kPlotFillColorKey : [UIColor colorWithRed:0.47 green:0.75 blue:0.78 alpha:0.5],
                                           kPlotStrokeWidthKey : @2,
                                           kPlotStrokeColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],
                                           kPlotPointFillColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],
                                           kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
                                           };
    
    _plot1.plotThemeAttributes = _plotThemeAttributes;
    [self.chartView addPlot:_plot1];
    
    //You can as much `SHPlots` as you can in a `SHLineGraphView`
    
    [self.chartView setupTheView];

}

#pragma mark -------------------------------

- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showHelpMsg:(id)sender {
}

#pragma mark - UICollocetionView数据源方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _shopList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JingjirenShangchengCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:REUSEIDENTIFIER forIndexPath:indexPath];

    NSDictionary *dict=_shopList[indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[dict getObjectByKey:@"Banner"]] placeholderImage:[UIImage imageNamed:@"picture_default_ST.jpg"]];
    cell.nameLab.text=[dict getObjectByKey:@"Name"];
    NSString *priceString=[dict getObjectByKey:@"DiscountPrice"];
    cell.priceLab.text=[NSString priceStringWithPrice:priceString];
    
    cell.shareBtn.tag=indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(fenxiang:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.tag=indexPath.row;
    UILongPressGestureRecognizer *LPcell=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteShop:)];
    [cell addGestureRecognizer:LPcell];
    
    return cell;
}

#pragma mark -------------------------------

-(void)deleteShop:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateBegan) {
        NSArray *titles=[NSArray arrayWithObjects:@"删除", nil];
        NSArray *styles=[NSArray arrayWithObjects:YUDangerStyle, nil];
        
        [self.view.window showPopWithButtonTitles:titles styles:styles whenButtonTouchUpInSideCallBack:^(int a) {
            switch (a) {
                case 0:
                {
                    NSDictionary *dict=_shopList[gesture.view.tag];
                    
                    [MessageFormat POST:DelShare parameters:@{@"UserId":_myapp.user.ID,@"ShopId":[dict getObjectByKey:@"ShopId"]} success:^(NSURLSessionDataTask *task, id responseObject) {
                        NSNumber *statuscode=responseObject[@"code"];
                        if (statuscode.intValue==0) {
                            [_shopList removeObjectAtIndex:gesture.view.tag];
                            [self.collectionView reloadData];
                        }
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                    } incontroller:self view:self.view];
                    break;
                }
                default:
                    break;
            }
        }];

    }
}

-(void)loadMoreData
{
    [[AFAppDotNetAPIClient sharedClient] POST:sharelist parameters:@{@"UserId":_myapp.user.ID,@"Start":[NSString stringWithFormat:@"%li",_shopList.count]} success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.collectionView.footer endRefreshing];
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSMutableArray *temarr=responseObject[@"data"];
            [_shopList addObjectsFromArray:temarr];
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.footer endRefreshing];
    }];
}

#pragma mark -------------------------------

-(void)fenxiang:(UIButton *)sender
{
    NSDictionary *dict=_shopList[sender.tag];
    NSString *status=[dict getObjectByKey:@"Status"];
    if ([status isEqualToString:@"0"]) {
        [MessageFormat hintWithMessage:@"该商品已经下架" inview:self.view completion:nil];
        return;
    }
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
//        ST_Goods *g=_goods[sender.tag];
        
        
//        AppDelegate *myapp=[UIApplication sharedApplication].delegate;
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:nil
                                           defaultContent:@"商城"
                                                    image:[ShareSDK imageWithUrl:[dict getObjectByKey:@"Banner"]]
                                                    title:[dict getObjectByKey:@"Name"]
                                                      url:[NSString stringWithFormat:@"%@/Share/Share/shopindex/sharecode/%@/shopid/%@",AFAppDotNetAPIBaseURLString,_myapp.user.shareCode,[dict getObjectByKey:@"ShopId"]]
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
                                        [[AFAppDotNetAPIClient sharedClient] POST:ShopShareSucess parameters:@{@"UserId":_myapp.user.ID,@"ShopId":[dict getObjectByKey:@"ShopId"],@"Code":_myapp.user.shareCode,@"Type":type==ShareTypeWeixiSession?@"2":@"1"} success:^(NSURLSessionDataTask *task, id responseObject) {
                                            
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

@end
