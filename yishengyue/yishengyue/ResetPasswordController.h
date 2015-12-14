//
//  ResetPasswordController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordController : UIViewController
@property(copy,nonatomic)NSString *phonenumber;
@property (weak, nonatomic) IBOutlet UITextField *setpasswordTxt;
@property (weak, nonatomic) IBOutlet UITextField *repeatpasswordTxt;
@property (weak, nonatomic) IBOutlet UIButton *seePSDBtn;
@property (weak, nonatomic) IBOutlet UIImageView *psdIMg;
@property (weak, nonatomic) IBOutlet UIImageView *repeatImg;
@property (weak, nonatomic) IBOutlet UIButton *OKBtn;


- (IBAction)changePSDMode:(UIButton *)sender;
- (IBAction)resetpassword:(UIButton *)sender;
@end
