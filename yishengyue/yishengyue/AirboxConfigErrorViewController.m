//
//  AirboxConfigErrorViewController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/21.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AirboxConfigErrorViewController.h"
#import "Mydefine.h"
#import "UIButton+Rectbutton.h"
#import "UIViewController+ActivityHUD.h"

@interface AirboxConfigErrorViewController ()

@end

@implementation AirboxConfigErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self relayoutsubviews];
    self.navBar.barTintColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.navigationController.navigationBar.tintColor=self.navBar.barTintColor;
    [self setstatusbarColor:self.navBar.barTintColor];
}

-(void)relayoutsubviews
{
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat screenheight=self.view.frame.size.height;
    CGFloat priorityX=screenwidth/SCREENWIDTH_5S;
    CGFloat priorityY=screenheight/SCREENHEIGHT_5S;
    
    self.stepImg.frame=CGRectMake(15*priorityX, 81*priorityY, 290*priorityX, 76*priorityY);
    
    self.failImg.frame=CGRectMake(135*priorityX, 217*priorityY, 50*priorityX, 50*priorityX);
    self.failImg.center=CGPointMake(screenwidth/2, self.failImg.center.y);
    
    self.failLab.frame=CGRectMake(118*priorityX, 275*priorityY, 85*priorityX, 40*priorityY);
    
    self.hintLab.frame=CGRectMake(34*priorityX, 323*priorityY, 252*priorityX, 28*priorityY);
    
    self.reconfigBtn.frame=CGRectMake(15*priorityX, 507*priorityY, 290*priorityX, 40*priorityX);
    [self.reconfigBtn setcornerRadius:40*priorityX/2];
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

- (IBAction)reconfig:(id)sender {

    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
