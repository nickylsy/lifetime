//
//  Shangcheng_LL_Controller.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/29.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "Shangcheng_LL_Controller.h"
#import "ShangchengCollectionViewCell.h"
#import "LLGoodsDetailController.h"
#import "Mydefine.h"
#import "UIWindow+YUBottomPoper.h"
#import "UIImageView+AFNetworking.h"
#import "AFAppDotNetAPIClient.h"
#import "MessageFormat.h"
#import "LL_Goods.h"
#import "AddShopController.h"
#import "MJRefresh.h"



#define REUSEIDENTIFIER @"shangchengcollectionviewcell"

@interface Shangcheng_LL_Controller ()
{
    NSMutableArray *_goods;
}
@end

@implementation Shangcheng_LL_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.collectionview registerNib:[UINib nibWithNibName:@"ShangchengCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:REUSEIDENTIFIER];
    self.collectionview.backgroundColor=[UIColor whiteColor];
    
    CGFloat itemjiange=10.0f;
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    CGFloat cellwidth=(self.view.frame.size.width-itemjiange*3)/2;
    CGFloat cellheight=(cellwidth-10)/1.4+85;
    layout.itemSize=CGSizeMake(cellwidth,cellheight);
    layout.sectionInset=UIEdgeInsetsMake(itemjiange, itemjiange,itemjiange,itemjiange);
    layout.minimumInteritemSpacing=itemjiange;
    layout.minimumLineSpacing=itemjiange;
    self.collectionview.collectionViewLayout=layout;
    
    self.addBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.addBtn addTarget:self action:@selector(addshop) forControlEvents:UIControlEventTouchUpInside];
    
    [self setbeginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refershData) name:REFRESH_SHOPLIST object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addshop
{
    AddShopController *a=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"addshopcontroller"];
    a.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self.parentViewController presentViewController:a animated:YES completion:nil];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _goods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShangchengCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:REUSEIDENTIFIER forIndexPath:indexPath];
    
    LL_Goods *g=_goods[indexPath.item];
    [cell.shangpinImg setImageWithURL:[NSURL URLWithString:g.pic.URLEncodedString] placeholderImage:[UIImage imageNamed:@"picture_default_LL.jpg"]];
    cell.nameLab.text=g.name;
    cell.timeLab.text=[NSString stringWithFormat:@"发布时间:%@",g.createTime];
    cell.priceLab.text=g.price;
    return cell;
}


#pragma mark - <UICollectionViewDelegate>


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LL_Goods *g=_goods[indexPath.item];
    LLGoodsDetailController *detailcontroller=[[LLGoodsDetailController alloc] init];
    detailcontroller.userID=g.userID;
    detailcontroller.shopID=g.ID;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:detailcontroller];
    nav.navigationBar.barTintColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self.parentViewController presentViewController:nav animated:YES completion:nil];
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
    self.collectionview.header = header;
    
    self.collectionview.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadMoreData
{
    [[AFAppDotNetAPIClient sharedClient] POST:NeighborShopList.URLEncodedString parameters:@{@"Start":[NSString stringWithFormat:@"%lu",(unsigned long)_goods.count]} success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.collectionview.footer endRefreshing];
        
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSArray *array=responseObject[@"data"];
            for (NSDictionary *dict in array) {
                LL_Goods *g=[LL_Goods goodsWithDict:dict];
                [_goods addObject:g];
            }
            [self.collectionview reloadData];
        }else if(statuscode.intValue==1001){
//            [self.collectionview.footer noticeNoMoreData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionview.footer endRefreshing];
    }];
    
}



-(void)refershData
{
    [[AFAppDotNetAPIClient sharedClient] POST:NeighborShopList.URLEncodedString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.collectionview.header endRefreshing];
        _goods=[NSMutableArray array];
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSArray *array=responseObject[@"data"];
            for (NSDictionary *dict in array) {
                LL_Goods *g=[LL_Goods goodsWithDict:dict];
                [_goods addObject:g];
            }
            [self.collectionview reloadData];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionview.header endRefreshing];
         NSLog(@"%@",error.debugDescription);
    }];
}

@end
