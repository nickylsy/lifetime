//
//  RegisterPhoneController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/30.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterPhoneController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaTxt;
@property (weak, nonatomic) IBOutlet UIButton *huoquBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIImageView *phonehengxianImg;
@property (weak, nonatomic) IBOutlet UIImageView *yanzhenghengxianImg;
@property (weak, nonatomic) IBOutlet UIView *xieyiView;
@property (weak, nonatomic) IBOutlet UILabel *xieyitouLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *xieyiweiLab;
- (IBAction)goback:(UIButton *)sender;
- (IBAction)next:(UIButton *)sender;
- (IBAction)getyanzheng:(UIButton *)sender;

@end
