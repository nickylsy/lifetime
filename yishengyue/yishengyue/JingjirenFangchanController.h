//
//  JingjirenFangchanController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/22.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JingjirenFangchanController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *titleBar;

- (IBAction)goback:(UIButton *)sender;
- (IBAction)fenxiang:(UIButton *)sender;
@end
