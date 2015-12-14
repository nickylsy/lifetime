//
//  CircleDetailController.m
//  yishengyue
//
//  Created by 华为-xtoucher on 15/9/18.
//  Copyright © 2015年 Xtoucher08. All rights reserved.
//

#import "CircleDetailController.h"
#import "Mydefine.h"
#import "MessageFormat.h"
#import "InterestDetailView.h"
#import "WorkDetailView.h"
#import "NSDictionary+GetObjectBykey.h"
#import "UIView+RoundRectView.h"
#import "UIImageView+AFNetworking.h"

@interface CircleDetailController ()

{
    NSDictionary *_circleInfo;
}
@end

@implementation CircleDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    
    self.UserView.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    [[AFAppDotNetAPIClient sharedClient] POST:Singleinteres.URLEncodedString parameters:@{@"InId":self.circleID,@"Type":self.type} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statusCode=responseObject[@"code"];
        if (statusCode.intValue==0) {
            _circleInfo=((NSArray *)responseObject[@"data"]).firstObject;
            
            [self.iconImageView setcornerRadius:self.iconImageView.frame.size.height/2 borderWidh:2.0 borderColor:[UIColor whiteColor]];
            [self.iconImageView setImageWithURL:[NSURL URLWithString:[_circleInfo getObjectByKey:@"LogoUrl"]]];
            self.nameLab.text=[_circleInfo getObjectByKey:@"UserName"];
            self.telLab.text=[_circleInfo getObjectByKey:@"Tel"];
            self.houseNumberLab.text=[_circleInfo getObjectByKey:@"RoomNum"];
            
            [self createDetailView];
        } else {
            [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark -
#pragma mark -------------------------------

-(void)createDetailView
{
//    CGFloat temwidth=self.view.frame.size.width-120;
//    UILabel *temlab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, temwidth, MAXFLOAT)];
//    temlab.font=[UIFont systemFontOfSize:14.0];
//    temlab.text=[_circleInfo getObjectByKey:@"Introduction"];
//    CGSize temsize=[temlab sizeThatFits:CGSizeMake(temwidth, MAXFLOAT)];
//    CGFloat descheight=temsize.height;
    
    CGFloat detailheight=0.0;
    
    CGFloat maxdetailheight=self.view.frame.size.height-64-100;
    
    if ([self.type isEqualToString:@"1"]) {
        InterestDetailView *detailView=[[UINib nibWithNibName:@"CircleDetailView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
        detailView.descLab.text=[_circleInfo getObjectByKey:@"Introduction"];
        CGSize temsize=[detailView.descLab sizeThatFits:CGSizeMake(detailView.descLab.frame.size.width, MAXFLOAT)];
        CGFloat descheight=temsize.height;
        
        detailheight=descheight+241;
        if (detailheight>maxdetailheight) {
            detailheight=maxdetailheight;
        }
//        detailView.descLab.contentInset=UIEdgeInsetsZero;
        detailView.frame=CGRectMake(0,164 , self.view.frame.size.width, detailheight);
        
        detailView.themeLab.text=[_circleInfo getObjectByKey:@"Title"];
        detailView.createtimeLab.text=[NSString stringWithFormat:@"发布时间：%@",[_circleInfo getObjectByKey:@"CreateTime"]];
        detailView.gotimeLab.text=[_circleInfo getObjectByKey:@"ReleaseTime"];
        detailView.locationLab.text=[_circleInfo getObjectByKey:@"Address"];
        detailView.numberLab.text=[_circleInfo getObjectByKey:@"Num"];
        
        [detailView.phoneBtn addTarget:self action:@selector(phonecall) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:detailView];
    } else {
        WorkDetailView *detailView=[[UINib nibWithNibName:@"CircleDetailView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
        
        detailView.descLab.text=[_circleInfo getObjectByKey:@"Introduction"];
        CGSize temsize=[detailView.descLab sizeThatFits:CGSizeMake(detailView.descLab.frame.size.width, MAXFLOAT)];
        CGFloat descheight=temsize.height;
        detailView.themeLab.text=[_circleInfo getObjectByKey:@"Title"];
        
        [detailView.phoneBtn addTarget:self action:@selector(phonecall) forControlEvents:UIControlEventTouchUpInside];
        
        detailheight=descheight+154;
        if (detailheight>maxdetailheight) {
            detailheight=maxdetailheight;
        }
        detailView.frame=CGRectMake(0,164 , self.view.frame.size.width, detailheight);
        [self.view addSubview:detailView];
    }
}

#pragma mark -
#pragma mark -------------------------------


- (IBAction)goback:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)phonecall
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否拨打发起人电话"delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
}

#pragma mark - UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[_circleInfo getObjectByKey:@"Tel"]]]];
    }
    
    [alertView removeFromSuperview];
    alertView=nil;
}
@end
