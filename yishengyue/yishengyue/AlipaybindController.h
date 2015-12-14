//
//  AlipaybindController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/27.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlipaybindController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *accountTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;


- (IBAction)goback:(id)sender;
- (IBAction)bindAlipay:(id)sender;
@end
