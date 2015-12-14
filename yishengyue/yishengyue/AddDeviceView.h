//
//  AddDeviceView.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MSG_ADDDEVICE @"adddevicemsg"
#define KEY_NAME @"name"
#define KEY_CATEGORY @"category"

@interface AddDeviceView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *devicelogoImg;
@property (weak, nonatomic) IBOutlet UITextField *devicenameTxt;
@property (nonatomic, copy) void(^onDismissalWithout)();

- (IBAction)addDevice:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)changelogo:(UIButton *)sender;

- (void)setDismissBlock:(void(^)())correctBlock;

-(void)setborder;
@end
