//
//  TixianController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TixianController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *alipayAccountLab;
@property (weak, nonatomic) IBOutlet UILabel *alipayUsernameLab;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;
@property (weak, nonatomic) IBOutlet UITextField *tixianNumLab;

- (IBAction)tixian:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@end
