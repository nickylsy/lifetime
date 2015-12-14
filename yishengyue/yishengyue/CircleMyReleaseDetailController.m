//
//  CircleMyReleaseDetailController.m
//  yishengyue
//
//  Created by 华为-xtoucher on 15/9/23.
//  Copyright © 2015年 Xtoucher08. All rights reserved.
//

#import "CircleMyReleaseDetailController.h"
#import "Mydefine.h"
#import "NSDictionary+GetObjectBykey.h"
#import "ReleaseInterestDetailView.h"
#import "ReleaseWorkDetailView.h"
#import "MessageFormat.h"
#import "AppDelegate.h"

@interface CircleMyReleaseDetailController ()

@end

@implementation CircleMyReleaseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    self.navigationItem.title=@"发布详情";
    
    CGFloat detailheight=0.0;
    
    CGFloat maxdetailheight=self.view.frame.size.height-64;
    
    //右上角删除按钮
    UIButton *rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0,40, 35)];
    [rightBtn setImage:[UIImage imageNamed:@"deleteBtn.png"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
    rightBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(deleteInfo) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
    if ([self.type isEqualToString:@"1"]) {
        ReleaseInterestDetailView *detailView=[[UINib nibWithNibName:@"MyReleaseDetailView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
        detailView.descLab.text=[_circleInfo getObjectByKey:@"Introduction"];
        CGSize temsize=[detailView.descLab sizeThatFits:CGSizeMake(detailView.descLab.frame.size.width, MAXFLOAT)];
        CGFloat descheight=temsize.height;
        
        detailheight=descheight+187;
        if (detailheight>maxdetailheight) {
            detailheight=maxdetailheight;
        }
        detailView.frame=CGRectMake(0,64 , self.view.frame.size.width, detailheight);
        
        detailView.themeLab.text=[_circleInfo getObjectByKey:@"Title"];
        detailView.createtimeLab.text=[NSString stringWithFormat:@"发布时间：%@",[_circleInfo getObjectByKey:@"CreateTime"]];
        detailView.gotimeLab.text=[_circleInfo getObjectByKey:@"ReleaseTime"];
        detailView.locationLab.text=[_circleInfo getObjectByKey:@"Address"];
        detailView.numberLab.text=[_circleInfo getObjectByKey:@"Num"];
        detailView.typeLab.text=@"兴趣圈";
        
        
        [self.view addSubview:detailView];
    } else {
        ReleaseWorkDetailView *detailView=[[UINib nibWithNibName:@"MyReleaseDetailView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
        
        detailView.descLab.text=[_circleInfo getObjectByKey:@"Introduction"];
        CGSize temsize=[detailView.descLab sizeThatFits:CGSizeMake(detailView.descLab.frame.size.width, MAXFLOAT)];
        CGFloat descheight=temsize.height;
        detailView.themeLab.text=[_circleInfo getObjectByKey:@"Title"];
        detailView.typeLab.text=[self.type isEqualToString:@"2"]?@"工作圈":@"商务圈";
        detailheight=descheight+100;
        if (detailheight>maxdetailheight) {
            detailheight=maxdetailheight;
        }
        detailView.frame=CGRectMake(0,64 , self.view.frame.size.width, detailheight);
        [self.view addSubview:detailView];
    }

    
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


#pragma mark - 响应方法

-(void)deleteInfo
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除本条信息"delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
}

#pragma mark - UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        AppDelegate *myapp=[UIApplication sharedApplication].delegate;
        [MessageFormat POST:delsingle parameters:@{@"UserId":myapp.user.ID,@"InId":[_circleInfo getObjectByKey:@"InId"]} success:^(NSURLSessionDataTask *task, id responseObject) {
            NSNumber *statusCode=responseObject[@"code"];
            if (statusCode.intValue==0) {
                [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:MSG_REFRESH_CIRCLE_MYRELEASE_LIST object:nil];
                }];
            } else {
                [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        } incontroller:self view:self.view];
    }
    
    [alertView removeFromSuperview];
    alertView=nil;
}
@end
