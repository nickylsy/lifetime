//
//  CircleDetailController.h
//  yishengyue
//
//  Created by 华为-xtoucher on 15/9/18.
//  Copyright © 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleDetailController : UIViewController
@property (nonatomic,copy)NSString *circleID;
@property(nonatomic,copy)NSString *type;
@property (weak, nonatomic) IBOutlet UIView *UserView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UILabel *houseNumberLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)goback:(UIButton *)sender;
@end
