//
//  UIViewController+ActivityHUD.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/18.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageFormat.h"

@interface UIViewController (ActivityHUD)<MyXMLParseDelegate>
-(void)pleaseWaitInView:(UIView *)view;
-(void)endWaiting;
-(void)setstatusbarColor:(UIColor *)color;
@end
