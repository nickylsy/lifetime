//
//  QuerenDingdanController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/30.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "QuerenDingdanController.h"
#import "AddressCell.h"
#import "Mydefine.h"
#import "QuerenDingdanTableViewCell.h"
#import "ChooseAddressController.h"
#import "AFAppDotNetAPIClient.h"
#import "AppDelegate.h"
#import "AddressInfo.h"
#import "CartShop.h"
#import "UIImageView+AFNetworking.h"
#import "MessageFormat.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#define ADDREUSEIDENTIFIER @"addresscell"
#define WULIUREUSEIDENTIFIER @"wuliucell"
#define QUERENDREUSEINGDANIDENTIFIER @"querendingdancell"
#define NUMBERREUSEINDENTIFIER @"numbercell"

@interface QuerenDingdanController ()<UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *_myapp;
}
@end

@implementation QuerenDingdanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableview.backgroundColor=UIColorFromRGB(0xf6f6f6);
    self.tableview.contentInset=UIEdgeInsetsMake(0, 0, 50, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.totalLab.text=self.totalstring;
    _myapp=[UIApplication sharedApplication].delegate;
    
    [[AFAppDotNetAPIClient sharedClient] POST:AddressData.URLEncodedString parameters:@{@"UserId":_myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        _myapp.defaultaddress=nil;
        if (statuscode.intValue==0) {
            _myapp.defaultaddress=[AddressInfo addressinfoWithDict:responseObject[@"data"]];
            [self.tableview reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    [self.tableview reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - tableview数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
        case 1:
        {
            return self.goods.count;
        }
        case 2:
        {
            return 2;
        }
        default:
            break;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            AddressCell *cell=[tableView dequeueReusableCellWithIdentifier:ADDREUSEIDENTIFIER];
            if (cell==nil) {
                cell=[[UINib nibWithNibName:@"AddressCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
            }
            cell.nameLab.text=_myapp.defaultaddress.name;
            cell.phoneNumLab.text=_myapp.defaultaddress.phoneNum;
            cell.addressLab.text=_myapp.defaultaddress.address;
            
            cell.selectedImg.hidden=YES;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 1:
        {
            QuerenDingdanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:QUERENDREUSEINGDANIDENTIFIER];
            if (cell==nil) {
                cell=[[UINib nibWithNibName:@"QuerenDingdanTableViewCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
            }
            
            CartShop *c=self.goods[indexPath.row];
            [cell.goodImg setImageWithURL:[NSURL URLWithString:c.banner.URLEncodedString]];
            cell.titleTxtview.text=c.name;
            cell.priceLab.text=c.price;
            cell.numberLab.text=[NSString stringWithFormat:@"x%@",c.shopNum];
            
            cell.oldpriceLab.hidden=YES;
            cell.backgroundColor=tableView.backgroundColor;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 2:
        {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indexPath.row==0?WULIUREUSEIDENTIFIER:NUMBERREUSEINDENTIFIER];
            if (cell==nil) {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indexPath.row==0?WULIUREUSEIDENTIFIER:NUMBERREUSEINDENTIFIER];
            };
            if (indexPath.row==0) {
                cell.textLabel.text=@"配送方式";
                cell.textLabel.textColor=UIColorFromRGB(0xababab);
                cell.detailTextLabel.text=@"快递 免邮";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"共%lu件商品",self.goods.count];
            }
            cell.detailTextLabel.textColor=UIColorFromRGB(0xa2a2a2);
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=tableView.backgroundColor;
            UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, indexPath.row==0?2:1)];
            imageview.backgroundColor=UIColorFromRGB(0xededed);
            [cell.contentView addSubview:imageview];
            return cell;
        }
        default:
            break;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return 100;
        }
        case 1:
        {
            return 100;
        }
        case 2:
        {
            return 44;
        }
        default:
            break;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section==0) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,10)];
        
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 1)];
        imageview.backgroundColor=UIColorFromRGB(0xededed);
        [view addSubview:imageview];
        return view;;
    }
    return nil;
}
#pragma mark - tableview代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        ChooseAddressController *choosecontroller=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"chooseaddresscontroller"];
        [self.navigationController pushViewController:choosecontroller animated:YES];
    }
}

#pragma mark -

- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] >0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

- (IBAction)OK:(UIButton *)sender {
    if (_myapp.defaultaddress==nil) {
        [MessageFormat hintWithMessage:@"请添加地址" inview:self.view completion:nil];
        return;
    }
    NSMutableArray *array=[NSMutableArray array];
    for (CartShop *c in self.goods) {
        [array addObject:@{@"ShopId":c.shopID,@"ShopNum":c.shopNum}];
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:[self toJSONData:array]
                                                 encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:@{@"UserId":_myapp.user.ID,@"List":jsonString,@"AddressId":_myapp.defaultaddress.ID,@"Type":@"3"}];
    
    if (self.clearcart) {
        NSMutableString *cartid=[[NSMutableString alloc] init];
        for (CartShop *c in self.goods) {
            if (c.selected) {
                [cartid appendFormat:@"%@,",c.cartID];
            }
        }
        
        [dic setObject:[cartid substringWithRange:NSMakeRange(0, cartid.length-1)] forKey:@"CartList"];
    }
    
    [MessageFormat POST:CreateOrder parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
//            [MessageFormat hintWithMessage:@"下单成功" inview:self.tableview completion:^{
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            }];
            NSString *trade_no=responseObject[@"data"][@"WIDout_trade_no"];
            NSString *total_fee=responseObject[@"data"][@"WIDtotal_fee"];
            NSString *subject=responseObject[@"data"][@"WIDtotal_fee"];
            
            
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
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }];
                
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } incontroller:self view:self.view];
}
@end
