//
//  LearnViewController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/13.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AsyncUdpSocketDelegate;

@interface LearnViewController : UIViewController
@property (weak, nonatomic ) IBOutlet UILabel * timeLab;
@property (retain,nonatomic) NSTimer          * timer;
@property (copy,nonatomic  ) NSString         * boxID;
@property (copy,nonatomic  ) NSString         * btnID;
//@property (copy,nonatomic  ) NSString         * username;
@property (nonatomic,assign) BOOL             needinputname;

@end
