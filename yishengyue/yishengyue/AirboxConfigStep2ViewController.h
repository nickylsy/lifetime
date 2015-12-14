//
//  AirboxConfigStep2ViewController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/15.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirboxConfigStep2ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField * password;
@property (weak, nonatomic) IBOutlet UITextField * SSIDList;
@property (weak, nonatomic) IBOutlet UIButton    * connectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *stepImg;
@property (weak, nonatomic) IBOutlet UIImageView *hintImg;

- (IBAction)connect:(id)sender;

@end
