//
//  KanfangController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/27.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KanfangController : UIViewController

@property(copy,nonatomic)NSString *postURL;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)goback:(id)sender;

@end
