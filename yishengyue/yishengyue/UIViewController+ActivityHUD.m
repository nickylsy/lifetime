//
//  UIViewController+ActivityHUD.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/18.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "UIViewController+ActivityHUD.h"
#import "AppDelegate.h"

@implementation UIViewController (ActivityHUD)

-(void)pleaseWaitInView:(UIView *)view
{
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [myapp.activityHUD showInView:view];
    self.view.alpha=0.8;
}

-(void)endWaiting
{
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [myapp.activityHUD dismiss];
    self.view.alpha=1;
}

-(void)anythingError
{
    [self endWaiting];
}

-(void)setstatusbarColor:(UIColor *)color
{
    
    UIView *statusbarbackground=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
    statusbarbackground.backgroundColor=color;
    [self.view addSubview:statusbarbackground];
}
@end
