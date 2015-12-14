//
//  DingdanDetailController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/12.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "DingdanDetailController.h"
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
@interface DingdanDetailController ()<UITableViewDataSource,UITableViewDelegate,DingdanDetailCellDelegate>
{
    NSArray *_shopList;
    NSDictionary *_dingdanDetailInfo;
    UIWindow *_warningWindow;
}
@end

@implementation DingdanDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor=UIColorFromRGB(0xf3f3f3);
//    [self.tableView setSeparatorInset:];
    
    
    self.tableView.backgroundColor=self.view.backgroundColor;
    
    self.callBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createbottomButtons];
}



#pragma mark - 

-(void)createbottomButtons
{
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat bottomViewHeight=TOOLBAR_HEIGHT;
    if (self.state==DingdanStateWaiting) {
        self.priceDescLab.text=@"合计（含运费）";
        self.callBtn.hidden=YES;
        [self.callBtn addTarget:self action:@selector(callseller) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *closeDingdanBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenwidth/2, bottomViewHeight)];
        
        [closeDingdanBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [closeDingdanBtn setTitleColor:UIColorFromRGB(FONT_COLOR_VALUE) forState:UIControlStateNormal];
        closeDingdanBtn.backgroundColor=UIColorFromRGB(0xeaeaea);
        [closeDingdanBtn addTarget:self action:@selector(closedingdan) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:closeDingdanBtn];
        
        
        UIButton *payBtn=[[UIButton alloc] initWithFrame:CGRectMake(screenwidth/2, 0, screenwidth/2, bottomViewHeight)];
        [payBtn setTitle:@"进入付款" forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payBtn.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
        [payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:payBtn];
        
    }else if (self.state==DingdanStatePay){
        self.priceDescLab.text=@"实付款（含运费）";
        self.callBtn.hidden=YES;
        
//        UIButton *callsellerBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenwidth/2, bottomViewHeight)];
//        
//        [callsellerBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
//        [callsellerBtn setTitleColor:UIColorFromRGB(FONT_COLOR_VALUE) forState:UIControlStateNormal];
//        [callsellerBtn setImage:[UIImage imageNamed:@"message_lxmj.png"] forState:UIControlStateNormal];
//        callsellerBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
//        [callsellerBtn setImageEdgeInsets:UIEdgeInsetsMake(10,0,10,30)];
//        callsellerBtn.backgroundColor=UIColorFromRGB(0xeaeaea);
//        [callsellerBtn addTarget:self action:@selector(callseller) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottomView addSubview:callsellerBtn];
        
        
        UIButton *shouhuoBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenwidth, bottomViewHeight)];
        [shouhuoBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [shouhuoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shouhuoBtn.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
        [shouhuoBtn addTarget:self action:@selector(querenshouhuo) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:shouhuoBtn];
    }else{
        self.priceDescLab.text=@"合计（含运费）";
        self.callBtn.hidden=YES;
        self.bottomView.hidden=YES;
//        UIButton *callsellerBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenwidth, bottomViewHeight)];
//        
//        [callsellerBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
//        [callsellerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [callsellerBtn setImage:[UIImage imageNamed:@"call_lxmj.png"] forState:UIControlStateNormal];
//        callsellerBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
//        [callsellerBtn setImageEdgeInsets:UIEdgeInsetsMake(10,0,10,30)];
//        callsellerBtn.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
//        [callsellerBtn addTarget:self action:@selector(callseller) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottomView addSubview:callsellerBtn];
        
        
        
        CGRect tableFrame=self.tableView.frame;
        tableFrame.size.height+=TOOLBAR_HEIGHT;
        self.tableView.frame=tableFrame;
        
        CGRect priceFrame=self.priceView.frame;
        priceFrame.origin.y+=TOOLBAR_HEIGHT;
        self.priceView.frame=priceFrame;
    }
}

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

#pragma mark -

-(void)querenshouhuo
{
    _warningWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleWaring title:@"确认收货" detail:nil canleButtonTitle:@"否" okButtonTitle:@"是" callBlock:^(MyWindowClick buttonIndex) {
        
        //Window隐藏，并置为nil，释放内存 不能少
        _warningWindow.hidden = YES;
        _warningWindow = nil;
        
        if (buttonIndex==MyWindowClickForOK) {
            [MessageFormat POST:CompleteOrder parameters:@{@"OrderId":[_dingdanDetailInfo getObjectByKey:@"OrderId"]} success:^(NSURLSessionDataTask *task, id responseObject) {
                [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:^{
                    NSNumber *statuscode=responseObject[@"code"];
                    if (statuscode.intValue==0) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [MessageFormat hintWithMessage:@"确认收货失败" inview:self.view completion:nil];
            } incontroller:self view:self.view];
        }
        
    }];
}

-(void)closedingdan
{
    _warningWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleWaring title:@"取消订单" detail:nil canleButtonTitle:@"否" okButtonTitle:@"是" callBlock:^(MyWindowClick buttonIndex) {
        
        //Window隐藏，并置为nil，释放内存 不能少
        _warningWindow.hidden = YES;
        _warningWindow = nil;
        
        if (buttonIndex==MyWindowClickForOK) {
            [MessageFormat POST:CancleOrder parameters:@{@"OrderId":[_dingdanDetailInfo getObjectByKey:@"OrderId"]} success:^(NSURLSessionDataTask *task, id responseObject) {
                [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:^{
                    NSNumber *statuscode=responseObject[@"code"];
                    if (statuscode.intValue==0) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [MessageFormat hintWithMessage:@"取消订单失败" inview:self.view completion:nil];
            } incontroller:self view:self.view];
        }
        
    }];
    
    
}

-(void)pay
{
    NSString *trade_no=[_dingdanDetailInfo getObjectByKey:@"OrderId"];
    NSString *total_fee=[_dingdanDetailInfo getObjectByKey:@"TotalPrice"];
    NSArray *temarr=[_dingdanDetailInfo getObjectByKey:@"OrderDataList"];
    NSString *subject;//=[_dingdanDetailInfo getObjectByKey:@"Name"];
    NSDictionary *dic=temarr.firstObject;
    if (temarr.count>1) {
        subject=[NSString stringWithFormat:@"%@等",[dic getObjectByKey:@"Name"]];
    }else{
        subject=[dic getObjectByKey:@"Name"];
    }
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088021159454933";
    NSString *seller = @"nan.zhao@freezeholdings.com";
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBANkWMut535UQXPWPUtLLow+NU+AmTCpuG3P/2J5PxRHphGoYccKyJlTkWNWTWa15SxsoFjqk7feYgVX439WIClWJM0Fc9dbfx0J4LWDl+Y6Nq18/nIHBLnxts8xxjphr1ucoB1U0c8r5ExEmtXVvUzcMTMEPisJuX/L59nQJ8wgfAgMBAAECgYEAxf2VG2bgIBf4cI3zQAYyBfEj2n+TX+9kYnupmVmvpxKPjiQVPTk19J7+1mu5kpnZgj8hZwMddoBFFaASpbGZmZMwvvIxEIMuhbPZeMhKFVEm38PqCZxwTapw/Xybf8GC13MEDvwEss0qp7ZO+1jBAFdMKEjDSbYoIfxu98j590ECQQD3X/hcjg8V1xk8Lnt9j5+pD7Veo7r9nr+cg/cNa6pzAs1Bv9Pawasczgi2gh7tzTFmwbgbQ3M4fwvXadJflX2JAkEA4KfhmUoLlALvBw/jXJSiw0Bu2RD6Iah3gePAbqJNfpCqmoZWBhgZCLQGoqRdwPpkugfTFobbkJm4QpCE/LXWZwJBAPA/m7VAHrSGaDLDrhmfAGAwKmSUvYmNwOhgXfMBytPSN8iQZk/B4c6i52FhdGpd64mxwH1x/5gyAy0d0DwWsokCQHpug6AKnmy3fJSYsAvQZTOLdd2ORwL40MhU2pZwlVMYfCFifJctotb/ZW5VrVJyI1rO0NdB/366h5SfNhqS7pkCQQDWJJiZEO7+xoy+f9tkwWN5pO+uspC8SXp9+iJIr5QAQVtm1kVZwFxReJa2L1gKx4pwUsB2hlMQIrUF/z13eQjA";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = trade_no;//[self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = subject; //商品标题
    //            order.productDescription = product.body; //商品描述
    order.amount = total_fee; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@/ShopApi/ShopApi/notify_url_ios",AFAppDotNetAPIBaseURLString]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPay-Info.plist定义URL types
    NSString *appScheme = @"yishengyue";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            //                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }
}

-(void)callseller
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否拨打卖家电话"delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
}

#pragma mark - UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PHONECALL_SALESHOP]];
    }
    [alertView removeFromSuperview];
    alertView=nil;
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
