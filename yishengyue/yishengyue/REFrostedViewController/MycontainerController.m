//
//  MycontainerController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MycontainerController.h"
#import "ChuangyeController.h"
#import "HomeController.h"
#import "GerenController.h"
#import "ShangchengController.h"
#import "QuanziController.h"

@implementation MycontainerController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    ChuangyeController *chuangye=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"chuangyecontroller"];
    HomeController *home=[[HomeController alloc] init];
    ShangchengController *shangcheng=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"shangchengcontroller"];
    QuanziController *quanzi=[[UIStoryboard storyboardWithName:@"Quanzi" bundle:nil] instantiateViewControllerWithIdentifier:@"quanzicontroller"];
    GerenController *geren=[[UIStoryboard storyboardWithName:@"YSY" bundle:nil] instantiateViewControllerWithIdentifier:@"gerencontroller"];
    
    [self addChildViewController:home];
    [self addChildViewController:chuangye];
    [self addChildViewController:shangcheng];
    [self addChildViewController:quanzi];
    [self addChildViewController:geren];
    
    [self.view addSubview:home.view];
}


-(void)changeViewcontrollerWithIndex:(int)index
{
    if (self.currentindex!=index) {
        [self transitionFromViewController:self.childViewControllers[self.currentindex] toViewController:self.childViewControllers[index] duration:0.2 options:UIViewAnimationOptionAllowAnimatedContent animations:nil completion:^(BOOL finished) {
            self.currentindex=index;
        }];
    }
}
@end
