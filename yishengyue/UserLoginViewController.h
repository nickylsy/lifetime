//
//  UserLoginViewController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/20.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEL_KEY @"Tel"
#define PASSWORD_KEY @"PassWord"

@interface UserLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView      * phoneItem;
@property (weak, nonatomic) IBOutlet UIView      * passwordItem;
@property (weak, nonatomic) IBOutlet UIButton    * loginBtn;
@property (weak, nonatomic) IBOutlet UITextField * phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField * passwordTxt;
@property (weak, nonatomic) IBOutlet UILabel     * forgetpsdLab;
@property (weak, nonatomic) IBOutlet UILabel     * registerLab;
@property (weak, nonatomic) IBOutlet UILabel *youkeLab;

- (IBAction)login:(id)sender;
@end
