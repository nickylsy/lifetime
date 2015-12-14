//
//  DingdanSuccessDetailController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/9/1.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "DingdanSuccessDetailController.h"
#import "Mydefine.h"
#import "MessageFormat.h"
#import "NSDictionary+GetObjectBykey.h"
#import "DingdanDetailCell.h"
#import "UIImageView+AFNetworking.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WKAlertView.h"
#import "TuihuoController.h"


#define DINGDANDETAILCELLREUSEIDENTIFIER @"dingdandetailcell"
@interface DingdanSuccessDetailController ()<UITableViewDataSource,UITableViewDelegate,DingdanDetailCellDelegate>
{
    NSArray *_shopList;
    NSDictionary *_dingdanDetailInfo;
    UIWindow *_warningWindow;
}
@end

@implementation DingdanSuccessDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor=UIColorFromRGB(0xf3f3f3);
    //    [self.tableView setSeparatorInset:];
    
    
    self.tableView.backgroundColor=self.view.backgroundColor;
    
    self.callBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.callBtn.hidden=YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DingdanDetailCell class]) bundle:nil] forCellReuseIdentifier:DINGDANDETAILCELLREUSEIDENTIFIER];
    
    [[AFAppDotNetAPIClient sharedClient] POST:OrderDetail parameters:@{@"OrderId":self.orderID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _dingdanDetailInfo=responseObject[@"data"];
            //地址信息
            NSDictionary *addressdict=[_dingdanDetailInfo getObjectByKey:@"AddressData"];
            self.nameLab.text=[addressdict getObjectByKey:@"Name"];
            self.phoneNumberLab.text=[addressdict getObjectByKey:@"Tel"];
            self.addressLab.text=[NSString stringWithFormat:@"收货地址：%@",[addressdict getObjectByKey:@"Address"]];
            self.addressLab.font=[UIFont systemFontOfSize:14.0];
            self.wuliuLab.text=[addressdict getObjectByKey:@"LogisticsOrder"];
            //订单信息
            self.dingdanNumberLab.text=[_dingdanDetailInfo getObjectByKey:@"OrderId"];
            NSString *dingdanstate=[_dingdanDetailInfo getObjectByKey:@"OrderStatus"];
            self.dingdanStateLab.text=dingdanstate;
            self.dingdanStateLab.textColor=[dingdanstate isEqualToString:@"未付款"]?[UIColor redColor]:UIColorFromRGB(FONT_COLOR_VALUE);
            self.dateLab.text=[_dingdanDetailInfo getObjectByKey:@"CreateTime"];
            self.priceLab.text=[NSString stringWithFormat:@"￥%@",[_dingdanDetailInfo getObjectByKey:@"TotalPrice"]];
            //商品列表
            _shopList=[_dingdanDetailInfo getObjectByKey:@"OrderDataList"];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -

#pragma mark - UITableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shopList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DingdanDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:DINGDANDETAILCELLREUSEIDENTIFIER forIndexPath:indexPath];
    NSDictionary *dict=_shopList[indexPath.row];
    
    cell.mydelegate=self;
    cell.titleTxt.text=[dict getObjectByKey:@"Name"];
    cell.priceLab.text=[dict getObjectByKey:@"DiscountPrice"];
    [cell.pictureImg setImageWithURL:[NSURL URLWithString:[dict getObjectByKey:@"Banner"]]];
    cell.numberLab.text=[NSString stringWithFormat:@"x%@",[dict getObjectByKey:@"ShopNum"]];
    NSString *statusString=[dict getObjectByKey:@"Status"];
    NSLog(@"%@",statusString);
    cell.tuihuoBtn.hidden=(([statusString isEqualToString:@"1"]) && (self.state==DingdanStatePay || self.state==DingdanStateSuccess)) ?NO:YES;
    return cell;
}
#pragma mark - UITableView代理方法


#pragma mark - 设置分割线离最左和最右的距离
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}


#pragma mark - DingdanDetailCell代理方法
-(void)tuihuo:(DingdanDetailCell *)cell
{
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
    
    TuihuoController *tuihuocontroller=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"tuihuocontroller"];
    tuihuocontroller.shopInfo=_shopList[indexPath.row];
    [self.navigationController pushViewController:tuihuocontroller animated:YES];
}

@end
