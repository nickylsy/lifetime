//
//  AlipayDebindHintView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/27.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlipayDebindHintView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UITextField *PSDTxt;

@property(copy,nonatomic)void(^okBlock)(NSString *);
@property(copy,nonatomic)void(^cancelBlock)();
- (IBAction)cancel:(id)sender;
- (IBAction)ok:(id)sender;
@end
