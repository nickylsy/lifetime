//
//  ViewController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/15.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirboxConfigStep1ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView * stepImg;
@property (weak, nonatomic) IBOutlet UIView *hintview;

@property (weak, nonatomic) IBOutlet UIButton    * okBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)startConfig:(id)sender;
- (IBAction)goback:(id)sender;

@end

