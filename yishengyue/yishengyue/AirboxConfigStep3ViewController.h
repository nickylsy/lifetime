//
//  AirboxConfigStep3ViewController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/15.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AsyncUdpSocketDelegate;


@interface AirboxConfigStep3ViewController : UIViewController

@property(copy,nonatomic)NSString             * boxID;
@property (weak, nonatomic) IBOutlet UIImageView *stepImg;
@property (weak, nonatomic) IBOutlet UIButton * startBindingBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UIView *centerview;
@property(nonatomic,copy)NSString             * ssid;
@property(nonatomic,copy)NSString             * password;
@property (weak, nonatomic) IBOutlet UIView *pointview;
@property (weak, nonatomic) IBOutlet UILabel *hintLab;

- (IBAction)startBinding:(id)sender;
- (IBAction)finish:(id)sender;

@end
