//
//  AirboxConfigStep4ViewController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/15.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirboxConfigStep4ViewController : UIViewController

@property(copy,nonatomic)NSString                * boxID;
@property (weak, nonatomic) IBOutlet UITextField * boxnameTxt;
@property (weak, nonatomic) IBOutlet UIButton    * finishBtn;
@property (weak, nonatomic) IBOutlet UIImageView *stepImg;
@property (weak, nonatomic) IBOutlet UIView *centerview;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)setboxname:(id)sender;
@end
