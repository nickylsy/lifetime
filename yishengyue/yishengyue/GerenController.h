//
//  GerenController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/2.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VSTabBar;

@interface GerenController : UIViewController
@property (weak, nonatomic) IBOutlet VSTabBar *tabbar;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *topview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImg;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

- (IBAction)edit:(UIButton *)sender;
- (IBAction)showmenu:(UIButton *)sender;

@end
