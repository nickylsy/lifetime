//
//  ShouyiController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/22.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ShouyiController.h"
#import "TotalShouyiController.h"
#import "ZhangdanController.h"
#import "ShangchengShouyiController.h"
#import "TixianController.h"
#import "MessageFormat.h"
#import "AppDelegate.h"
#import "NSDictionary+GetObjectBykey.h"

@interface ShouyiController ()

@end

@implementation ShouyiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.shouyiListBtn.imageView.contentMode=self.backBtn.imageView.contentMode;
    
    
    UITapGestureRecognizer *fangchanImgTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fangchanshouyi)];
    self.fangchanShouyiImg.userInteractionEnabled=YES;
    [self.fangchanShouyiImg addGestureRecognizer:fangchanImgTap];
    
    UITapGestureRecognizer *fangchanLabTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fangchanshouyi)];
    self.fangchanShouyiLab.userInteractionEnabled=YES;
    [self.fangchanShouyiLab addGestureRecognizer:fangchanLabTap];
    
    UITapGestureRecognizer *shangchengImgTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shangchengshouyi)];
    self.shangchengShouyiImg.userInteractionEnabled=YES;
    [self.shangchengShouyiImg addGestureRecognizer:shangchengImgTap];
    
    UITapGestureRecognizer *shangchengLabTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shangchengshouyi)];
    self.shangchengShouyiLab.userInteractionEnabled=YES;
    [self.shangchengShouyiLab addGestureRecognizer:shangchengLabTap];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [MessageFormat POST:MyIncome parameters:@{@"UserId":myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSDictionary *dict=responseObject[@"data"];
            self.totalShouyiValueLab.text=[NSString stringWithFormat:@"￥%@",[dict getObjectByKey:@"MyIncome"]];//dict[@"MyIncome"];
            self.fangchanShouyiValueLab.text=[NSString stringWithFormat:@"￥%@",[dict getObjectByKey:@"HouseIncome"]];//dict[@"HouseIncome"];
            self.shangchengShouyiValueLab.text=[NSString stringWithFormat:@"￥%@",[dict getObjectByKey:@"ShopIncome"]==nil?@"0.00":[dict getObjectByKey:@"ShopIncome"]];//dict[@"ShopIncome"];
        }else{
            [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self view:self.view];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -

-(void)fangchanshouyi
{
    TotalShouyiController *totalshouyicontorller=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"totalshouyicontroller"];
    [self.navigationController pushViewController:totalshouyicontorller animated:YES];
}

-(void)shangchengshouyi
{
    ShangchengShouyiController *shangchengshouyicontroller=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"shangchengshouyicontroller"];
    [self.navigationController pushViewController:shangchengshouyicontroller animated:YES];
}

- (IBAction)goback:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)zhangdan:(id)sender {
    ZhangdanController *zhangdancontorller=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"zhangdancontroller"];
    [self.navigationController pushViewController:zhangdancontorller animated:YES];
}

- (IBAction)tixian:(id)sender {
    
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    if (myapp.alipayaccount==nil) {
        [MessageFormat hintWithMessage:@"请先到个人中心绑定支付宝" inview:self.view completion:nil];
        return;
    }
    
    TixianController *tixiancontroller=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"tixiancontroller"];
    [self.navigationController pushViewController:tixiancontroller animated:YES];
}
@end
