//
//  AirboxConfigErrorViewController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/21.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirboxConfigErrorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *reconfigBtn;
@property (weak, nonatomic) IBOutlet UIImageView *stepImg;
@property (weak, nonatomic) IBOutlet UIImageView *failImg;
@property (weak, nonatomic) IBOutlet UILabel *failLab;
@property (weak, nonatomic) IBOutlet UILabel *hintLab;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)reconfig:(id)sender;
@end
