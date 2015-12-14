//
//  ShangchengController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/25.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ShangchengController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "Mydefine.h"
#import "ShangchengTableViewCell.h"
#import "Shangcheng_ST_Controller.h"
#import "Shangcheng_LL_Controller.h"
#import "ShoppingcartViewController.h"

@interface ShangchengController()<UIWebViewDelegate>
@property(nonatomic,assign)int currentindex;
@end

@implementation ShangchengController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.menuBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.view.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.gouwucheBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    self.titleBar.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.titleSmt.layer.masksToBounds=YES;
    self.titleSmt.layer.borderColor=[UIColor whiteColor].CGColor;
    self.titleSmt.layer.cornerRadius=self.titleSmt.frame.size.height/2;
    self.titleSmt.layer.borderWidth=1.0;
    
    UIStoryboard *autolayoutstoryboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
    Shangcheng_ST_Controller *st=[autolayoutstoryboard instantiateViewControllerWithIdentifier:@"shangcheng_st_controller"];
    Shangcheng_LL_Controller *ll=[autolayoutstoryboard instantiateViewControllerWithIdentifier:@"shangcheng_ll_controller"];
    st.view.frame=self.shangchengView.bounds;
    ll.view.frame=self.shangchengView.bounds;
    [self addChildViewController:st];
    [self addChildViewController:ll];
    
    
    [self.shangchengView addSubview:ll.view];
    [self.shangchengView addSubview:st.view];
    
    self.currentindex=0;

}

- (IBAction)showmenu:(id)sender {
    Shangcheng_ST_Controller *st=self.childViewControllers[0];
    [st.searchBar endEditing:YES];
    st.fenleiSuperView.hidden=YES;
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)changePage:(UISegmentedControl *)sender {
    
    int index=(int)sender.selectedSegmentIndex;

    self.gouwucheBtn.hidden=index==1;

    if (self.currentindex!=index) {
        [self transitionFromViewController:self.childViewControllers[self.currentindex] toViewController:self.childViewControllers[index] duration:0.2 options:UIViewAnimationOptionAllowAnimatedContent animations:nil completion:^(BOOL finished) {
            self.currentindex=index;
        }];
    }
}

- (IBAction)gotoshopcart:(UIButton *)sender {
    
    Shangcheng_ST_Controller *st=self.childViewControllers[0];
    [st.searchBar endEditing:YES];
    st.fenleiSuperView.hidden=YES;
    
    UINavigationController *shoppingcart=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"shoppingcartNavcontroller"];
    shoppingcart.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    shoppingcart.navigationBar.barTintColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    [self presentViewController:shoppingcart animated:YES completion:nil];
}


@end
