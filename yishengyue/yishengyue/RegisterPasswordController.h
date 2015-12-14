//
//  RegisterPasswordController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/30.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterPasswordController : UIViewController
@property(copy,nonatomic)NSString *phonenumber;
@property (weak, nonatomic) IBOutlet UITextField *setpasswordTxt;
@property (weak, nonatomic) IBOutlet UITextField *repeatpasswordTxt;
@property (weak, nonatomic) IBOutlet UIButton *seePSDBtn;
@property (weak, nonatomic) IBOutlet UIImageView *psdIMg;
@property (weak, nonatomic) IBOutlet UIImageView *repeatImg;
@property (weak, nonatomic) IBOutlet UIImageView *emailImg;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;


- (IBAction)changePSDMode:(UIButton *)sender;
- (IBAction)registeruser:(UIButton *)sender;

@end
