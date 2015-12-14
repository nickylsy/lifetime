//
//  ChuangyeController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/29.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ChuangyeController.h"
#import "ChuangyeCell.h"
#import "Mydefine.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "JingjirenFangchanController.h"
#import "JingjirenShangchengController.h"
#import "NSDictionary+GetObjectBykey.h"
#import "AFAppDotNetAPIClient.h"
#import "CYHelpView.h"

#define CHUANGYE_CELL_REUSE @"chuangyecell"



@interface ChuangyeController ()
{
//    NSArray *_tableviewcelldatas;
    NSMutableArray *_helpInfo;
    UIWindow *_helpWindow;
}
@end

@implementation ChuangyeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everChuangye"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everChuangye"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showhelp"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showhelp"];
    }
    
    self.menuBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.helpBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.view.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.titleBar.backgroundColor=self.view.backgroundColor;
    
    
    [self.fangchanBtn addTarget:self action:@selector(gotojingjirenFangchan) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *fangchanTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotojingjirenFangchan)];
    self.fangchanLab.userInteractionEnabled=YES;
    [self.fangchanLab addGestureRecognizer:fangchanTap];
    
    [self.shangchengBtn addTarget:self action:@selector(gotojingjirenShangcheng) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *shangchengTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotojingjirenShangcheng)];
    self.shangchengLab.userInteractionEnabled=YES;
    [self.shangchengLab addGestureRecognizer:shangchengTap];
    
    [self.shouyiBtn addTarget:self action:@selector(gotoshouyi) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *shouyiTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoshouyi)];
    self.shouyiLab.userInteractionEnabled=YES;
    [self.shouyiLab addGestureRecognizer:shouyiTap];
    
    [[AFAppDotNetAPIClient sharedClient] POST:GetShareRoles.URLEncodedString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _helpInfo=responseObject[@"data"];
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showhelp"]) {
                // 这里判断是否第一次
                [self showHelpInfo:nil];
            }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -

-(void)gotojingjirenFangchan
{
    JingjirenFangchanController *fangchan=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"jingjirenfangchancontroller"];
    fangchan.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self.frostedViewController presentViewController:fangchan animated:YES completion:nil];
}

-(void)gotojingjirenShangcheng
{
    JingjirenShangchengController *shangcheng=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"jingjirenshangchengcontroller"];
    shangcheng.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self.frostedViewController presentViewController:shangcheng animated:YES completion:nil];
}

-(void)gotoshouyi
{
    UINavigationController *shouyiNav=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"shouyiNavcontroller"];
    shouyiNav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:shouyiNav animated:YES completion:nil];
}

#pragma mark -
- (IBAction)showmenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)showHelpInfo:(UIButton *)sender {
    
    _helpWindow=[[UIWindow alloc] initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
    _helpWindow.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _helpWindow.windowLevel=100;
    [_helpWindow makeKeyAndVisible];
    _helpWindow.hidden=NO;
    _helpWindow.alpha=1;
    
    CYHelpView *h=[[UINib nibWithNibName:NSStringFromClass([CYHelpView class]) bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    h.frame=CGRectMake(0, 0, _helpWindow.frame.size.width-60, 300.0);
    [h setHelpInfo:_helpInfo];
    h.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [h.knowBtn addTarget:self action:@selector(hideHelpInfo) forControlEvents:UIControlEventTouchUpInside];
    [_helpWindow addSubview:h];
}

-(void)hideHelpInfo
{
    _helpWindow.hidden=YES;
    [_helpWindow resignKeyWindow];
    _helpWindow=nil;
}
@end
