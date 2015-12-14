//
//  LoginDialog.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/26.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginDialog : UIView
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UILabel *registerLab;

@property(nonatomic,copy)void(^dismissblock)();
@property(nonatomic,copy)void(^loginblock)(NSString *,NSString *);
@property(nonatomic,copy)void(^registerblock)();

- (IBAction)closeDialog:(id)sender;
- (IBAction)login:(id)sender;
@end
