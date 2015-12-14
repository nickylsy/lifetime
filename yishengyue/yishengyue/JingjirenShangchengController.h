//
//  JingjirenShangchengController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/23.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JingjirenShangchengController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *titleBar;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;

- (IBAction)goback:(id)sender;
- (IBAction)showHelpMsg:(id)sender;

@end
