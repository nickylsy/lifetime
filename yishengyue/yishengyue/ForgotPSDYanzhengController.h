//
//  ForgotPSDYanzhengController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPSDYanzhengController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaTxt;
@property (weak, nonatomic) IBOutlet UIButton *huoquBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIImageView *phonehengxianImg;
@property (weak, nonatomic) IBOutlet UIImageView *yanzhenghengxianImg;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)goback:(UIButton *)sender;
- (IBAction)next:(UIButton *)sender;
- (IBAction)getyanzheng:(UIButton *)sender;
@end
