//
//  AboutusController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/10.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutusController : UIViewController
@property(copy,nonatomic)NSString *urlstring;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)goback:(UIButton *)sender;
@end
