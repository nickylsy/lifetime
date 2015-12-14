//
//  MydingdanController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/13.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MydingdanController.h"
#import "DingdanCell.h"
#import "TuihuoCell.h"
#import "HMSegmentedControl.h"
#import "Mydefine.h"
#import "AFAppDotNetAPIClient.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "NSDictionary+GetObjectBykey.h"
#import "DingdanDetailController.h"
#import "WKAlertView.h"
#import "UIImageView+AFNetworking.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MessageFormat.h"
#import "NSString+PriceString.h"
#import "DingdanSuccessDetailController.h"

#define MYSHOPREUSEIDENTIFIER @"myshopreuseridentifier"
#define MYTUIHUOREUSEIDENTIFIER @"tuihuocell"

@interface MydingdanController ()<UITableViewDataSource,UITableViewDelegate,DingdancellDelegate>
{
    NSMutableArray *_waitDingdanList;
    NSMutableArray *_payDingdanList;
    NSMutableArray *_successDingdanList;
    NSMutableArray *_closeDingdanList;
    NSMutableArray *_tuihuoDingdanList;
    
    CGPoint _waitOffset;
    CGPoint _payOffset;
    CGPoint _successOffset;
    CGPoint _closeOffset;
    CGPoint _tuihuoOffset;
    
    UIWindow *_warningWindow;
    int _currentPage;
}
@property (weak, nonatomic) IBOutlet HMSegmentedControl *tabbar;

@end

@implementation MydingdanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _waitOffset=CGPointZero;
    _payOffset=CGPointZero;
    _successOffset=CGPointZero;
    _closeOffset=CGPointZero;
    _tuihuoOffset=CGPointZero;
    _currentPage=0;
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"DingdanCell" bundle:nil] forCellReuseIdentifier:MYSHOPREUSEIDENTIFIER];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=UIColorFromRGB(0xf6f6f6);
    self.tableView.bounces=YES;
    
    [self.tabbar setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [self.tabbar setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [self.tabbar setSelectionIndicatorHeight:3.0];
    [self.tabbar setSelectionIndicatorColor:UIColorFromRGB(MAIN_COLOR_VALUE)];
    self.tabbar.showVerticalDivider=YES;
    self.tabbar.verticalDividerColor=UIColorFromRGB(0xdfdfdf);
    self.tabbar.userDraggable=NO;
    [self.tabbar setSegmentEdgeInset:UIEdgeInsetsZero];
    [self.tabbar setSectionTitles:[NSArray arrayWithObjects:@"未付款",@"进行中",@"交易成功",@"交易关闭",@"退货", nil]];
    self.tabbar.layer.borderWidth=1;
    self.tabbar.layer.borderColor=UIColorFromRGB(0xdfdfdf).CGColor;
    self.tabbar.font=[UIFont systemFontOfSize:13.0];
    
    [self.tabbar setIndexChangeBlock:^(NSInteger index) {
        switch (_currentPage) {
            case 0:
            {
                _waitOffset=self.tableView.contentOffset;
                break;
            }
            case 1:
            {
                _payOffset=self.tableView.contentOffset;
                break;
            }
            case 2:
            {
                _successOffset=self.tableView.contentOffset;
                break;
            }
            case 3:
            {
                _closeOffset=self.tableView.contentOffset;
                break;
            }
            case 4:
            {
                _tuihuoOffset=self.tableView.contentOffset;
                break;
            }

            default:
                break;
        }
        
        _currentPage=(int)index;
        switch (index) {
            case 0:
            {
                if (_waitDingdanList==nil) {
                    [self.tableView.header beginRefreshing];
                    [self refershData];
                }else{
                    [self.tableView reloadData];
                    self.tableView.contentOffset=_waitOffset;
                }
                break;
            }
            case 1:
            {
                if (_payDingdanList==nil) {
                    [self.tableView.header beginRefreshing];
                    [self refershData];
                } else {
                    [self.tableView reloadData];
                    self.tableView.contentOffset=_payOffset;
                }
                break;
            }
            case 2:
            {
                if (_successDingdanList==nil) {
                    [self.tableView.header beginRefreshing];
                    [self refershData];
                } else {
                    [self.tableView reloadData];
                    self.tableView.contentOffset=_successOffset;
                }
                break;
            }
            case 3:
            {
                if (_closeDingdanList==nil) {
                    [self.tableView.header beginRefreshing];
                    [self refershData];
                } else {
                    [self.tableView reloadData];
                    self.tableView.contentOffset=_closeOffset;
                }
                break;
            }
            case 4:
            {
                if (_tuihuoDingdanList==nil) {
                    [self.tableView.header beginRefreshing];
                    [self refershData];
                } else {
                    [self.tableView reloadData];
                    self.tableView.contentOffset=_tuihuoOffset;
                }
                break;
            }
            default:
                break;
        }
        
        
        
    }];
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
//    [self setbeginRefreshing];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self setbeginRefreshing];
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setbeginRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableView数据源方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_currentPage) {
        case 0:
        {
            return _waitDingdanList.count;
        }
        case 1:
        {
            return _payDingdanList.count;
        }
        case 2:
        {
            return _successDingdanList.count;
        }
        case 3:
        {
            return _closeDingdanList.count;
        }
        case 4:
        {
            return _tuihuoDingdanList.count;
        }
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentPage==4) {
        TuihuoCell *cell=[tableView dequeueReusableCellWithIdentifier:MYTUIHUOREUSEIDENTIFIER];
        if (cell==nil) {
            cell=[[UINib nibWithNibName:@"DingdanCell" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=tableView.backgroundColor;
        
        NSDictionary *dict=_tuihuoDingdanList[indexPath.row];
        
        cell.IDLab.text=[NSString stringWithFormat:@"订单号：%@",[dict getObjectByKey:@"OrderId"]];
        
        NSString *paystate=[dict getObjectByKey:@"OrderStatus"];
        cell.payStateLab.text=paystate;
        cell.payStateLab.textColor=[paystate isEqualToString:@"未付款"]?[UIColor redColor]:UIColorFromRGB(FONT_COLOR_VALUE);;
        cell.dateLab.text=[NSString stringWithFormat:@"下单时间:%@",dict[@"CreateTime"]];
        NSArray *picArr=[dict getObjectByKey:@"data"];
        NSDictionary *picDict=picArr.firstObject;
        [cell.pictureImg setImageWithURL:[NSURL URLWithString:[picDict getObjectByKey:@"Banner"]]];
        
        cell.nameTxt.text=[dict getObjectByKey:@"Name"];
        cell.priceLab.text=[NSString priceStringWithPrice:[dict getObjectByKey:@"Price"]];
        cell.numberLab.text=[NSString stringWithFormat:@"x%@",[dict getObjectByKey:@"ShopNum"]];
        return cell;
    } else {
        DingdanCell *cell=[tableView dequeueReusableCellWithIdentifier:MYSHOPREUSEIDENTIFIER];
        if (cell==nil) {
            cell=[[UINib nibWithNibName:@"DingdanCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=tableView.backgroundColor;
        cell.mydelegate=self;
        
        NSDictionary *dict;
        switch (_currentPage) {
            case 0:
            {
                dict=_waitDingdanList[indexPath.row];
                break;
            }
            case 1:
            {
                dict=_payDingdanList[indexPath.row];
                break;
            }
            case 2:
            {
                dict=_successDingdanList[indexPath.row];
                break;
            }
            case 3:
            {
                dict=_closeDingdanList[indexPath.row];
                break;
            }
            default:
                break;
        }
        
        cell.IDLab.text=[NSString stringWithFormat:@"订单号：%@",[dict getObjectByKey:@"OrderId"]];
        
        NSString *paystate=[dict getObjectByKey:@"OrderStatus"];
        cell.payStateLab.text=paystate;
        cell.payStateLab.textColor=[paystate isEqualToString:@"未付款"]?[UIColor redColor]:UIColorFromRGB(FONT_COLOR_VALUE);;
        cell.dateLab.text=[NSString stringWithFormat:@"下单时间:%@",dict[@"CreateTime"]];
        NSLog(@"%@",cell.dateLab.text);
        [cell setImages:dict[@"data"]];
        if ([paystate isEqualToString:@"交易成功"]) {
            [cell setState:DingdanStateSuccess];
        }else if ([paystate isEqualToString:@"未付款"])
        {
            [cell setState:DingdanStateWaiting];
        }else if ([paystate isEqualToString:@"进行中"])
        {
            [cell setState:DingdanStatePay];
        }else
        {
            [cell setState:DingdanStateFail];
        }
        return cell;

    }
    
    return nil;
}

#pragma mark - UITableView代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (_currentPage==4) {
        return;
    }
    NSDictionary *dict;
    switch (_currentPage) {
        case 0:
        {
            dict=_waitDingdanList[indexPath.row];
            break;
        }
        case 1:
        {
            dict=_payDingdanList[indexPath.row];
            break;
        }
        case 2:
        {
            dict=_successDingdanList[indexPath.row];
            DingdanCell *cell=(DingdanCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            DingdanSuccessDetailController *detail=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"dingdansuccessdetailcontroller"];
            detail.state=cell.state;
            detail.orderID=[dict getObjectByKey:@"OrderId"];
            [self.navigationController pushViewController:detail animated:YES];
            return;
        }
        case 3:
        {
            dict=_closeDingdanList[indexPath.row];
            DingdanCell *cell=(DingdanCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            DingdanSuccessDetailController *detail=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"dingdansuccessdetailcontroller"];
            detail.state=cell.state;
            detail.orderID=[dict getObjectByKey:@"OrderId"];
            [self.navigationController pushViewController:detail animated:YES];
            return;
        }
        default:
            break;
    }
    
    DingdanCell *cell=(DingdanCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    DingdanDetailController *detail=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"dingdandetailcontroller"];
    detail.state=cell.state;
    detail.orderID=[dict getObjectByKey:@"OrderId"];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -
- (IBAction)goback:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 开始刷新函数
- (void)setbeginRefreshing
{
    self.tableView.header=nil;
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
}

-(void)refershData
{
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:myapp.user.ID forKey:@"UserId"];
    if (self.tabbar.selectedSegmentIndex==4) {
        _tuihuoDingdanList=nil;
        [[AFAppDotNetAPIClient sharedClient] POST:TuiList.URLEncodedString parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.tableView.header endRefreshing];
            NSNumber *statuscode=responseObject[@"code"];
            if (statuscode.intValue==0) {
                _tuihuoDingdanList=[NSMutableArray array];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    [_tuihuoDingdanList addObject:dic];
                }
                
            }
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }];
    } else {
        switch (self.tabbar.selectedSegmentIndex) {
            case 0:
            {
                [dict setObject:@"1" forKey:@"Status"];
                _waitDingdanList=nil;
                break;
            }
            case 1:
            {
                [dict setObject:@"2" forKey:@"Status"];
                _payDingdanList=nil;
                break;
            }
            case 2:
            {
                [dict setObject:@"3" forKey:@"Status"];
                _successDingdanList=nil;
                break;
            }
            case 3:
            {
                [dict setObject:@"5" forKey:@"Status"];
                _closeDingdanList=nil;
                break;
            }
            default:
                break;
        }
        
        [[AFAppDotNetAPIClient sharedClient] POST:MyOrderList.URLEncodedString parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.tableView.header endRefreshing];
            NSLog(@"end");
            NSNumber *statuscode=responseObject[@"code"];
            if (statuscode.intValue==0) {
                switch (self.tabbar.selectedSegmentIndex) {
                    case 0:
                    {
                        _waitDingdanList=[NSMutableArray array];
                        for (NSDictionary *dic in responseObject[@"data"]) {
                            [_waitDingdanList addObject:dic];
                        }
                        break;
                    }
                    case 1:
                    {
                        _payDingdanList=[NSMutableArray array];
                        for (NSDictionary *dic in responseObject[@"data"]) {
                            [_payDingdanList addObject:dic];
                        }
                        break;
                    }
                    case 2:
                    {
                        _successDingdanList=[NSMutableArray array];
                        for (NSDictionary *dic in responseObject[@"data"]) {
                            [_successDingdanList addObject:dic];
                        }
                        break;
                    }
                    case 3:
                    {
                        _closeDingdanList=[NSMutableArray array];
                        for (NSDictionary *dic in responseObject[@"data"]) {
                            [_closeDingdanList addObject:dic];
                        }
                        break;
                    }
                    default:
                        break;
                }
                
            }
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }];

    }
}

#pragma mark - Dingdancell代理方法
-(void)pay:(DingdanCell *)cell
{
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
    
    NSDictionary *dict;
    switch (_currentPage) {
        case 0:
        {
            dict=_waitDingdanList[indexPath.row];
            break;
        }
        case 1:
        {
            dict=_payDingdanList[indexPath.row];
            break;
        }
        case 2:
        {
            dict=_successDingdanList[indexPath.row];
            break;
        }
        case 3:
        {
            dict=_closeDingdanList[indexPath.row];
            break;
        }
        default:
            break;
    }
    
    NSString *trade_no=[dict getObjectByKey:@"OrderId"];
    NSString *total_fee=[dict getObjectByKey:@"Price"];
    NSString *subject=[dict getObjectByKey:@"Name"];
    
    
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
    order.notifyURL =  [NSString stringWithFormat:@"%@/ShopApi/ShopApi/notify_url_ios",AFAppDotNetAPIBaseURLString]; //回调URL
    
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
            [self clearlists];
            [self.tableView.header beginRefreshing];
            [self refershData];
        }];
        
    }

}

-(void)querenshouhuo:(DingdanCell *)cell
{
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
    
    NSDictionary *dict;
    switch (_currentPage) {
        case 0:
        {
            dict=_waitDingdanList[indexPath.row];
            break;
        }
        case 1:
        {
            dict=_payDingdanList[indexPath.row];
            break;
        }
        case 2:
        {
            dict=_successDingdanList[indexPath.row];
            break;
        }
        case 3:
        {
            dict=_closeDingdanList[indexPath.row];
            break;
        }
        default:
            break;
    }
    
    _warningWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleWaring title:@"确认收货" detail:nil canleButtonTitle:@"否" okButtonTitle:@"是" callBlock:^(MyWindowClick buttonIndex) {
        
        //Window隐藏，并置为nil，释放内存 不能少
        _warningWindow.hidden = YES;
        _warningWindow = nil;
        
        if (buttonIndex==MyWindowClickForOK) {
            [MessageFormat POST:CompleteOrder parameters:@{@"OrderId":[dict getObjectByKey:@"OrderId"]} success:^(NSURLSessionDataTask *task, id responseObject) {
                [self clearlists];
                [self.tableView.header beginRefreshing];
                [self refershData];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            } incontroller:self view:self.tableView];
        }
        
    }];
}

-(void)closeDingdan:(DingdanCell *)cell
{
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
    
    NSDictionary *dict;
    switch (_currentPage) {
        case 0:
        {
            dict=_waitDingdanList[indexPath.row];
            break;
        }
        case 1:
        {
            dict=_payDingdanList[indexPath.row];
            break;
        }
        case 2:
        {
            dict=_successDingdanList[indexPath.row];
            break;
        }
        case 3:
        {
            dict=_closeDingdanList[indexPath.row];
            break;
        }
        default:
            break;
    }
    
    _warningWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleWaring title:@"取消订单" detail:nil canleButtonTitle:@"否" okButtonTitle:@"是" callBlock:^(MyWindowClick buttonIndex) {
        
        //Window隐藏，并置为nil，释放内存 不能少
        _warningWindow.hidden = YES;
        _warningWindow = nil;
        
        if (buttonIndex==MyWindowClickForOK) {
            [MessageFormat POST:CancleOrder parameters:@{@"OrderId":[dict getObjectByKey:@"OrderId"]} success:^(NSURLSessionDataTask *task, id responseObject) {
                [self clearlists];
                [self.tableView.header beginRefreshing];
                [self refershData];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            } incontroller:self view:self.tableView];
        }
        
    }];
}
#pragma mark -

-(void)clearlists
{
    _closeDingdanList=nil;
    _waitDingdanList=nil;
    _payDingdanList=nil;
    _successDingdanList=nil;
    _tuihuoDingdanList=nil;
}
@end
