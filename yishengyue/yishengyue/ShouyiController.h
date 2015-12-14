//
//  ShouyiController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/22.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShouyiController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shouyiListBtn;
@property (weak, nonatomic) IBOutlet UIImageView *fangchanShouyiImg;
@property (weak, nonatomic) IBOutlet UILabel *fangchanShouyiLab;
@property (weak, nonatomic) IBOutlet UIImageView *shangchengShouyiImg;
@property (weak, nonatomic) IBOutlet UILabel *shangchengShouyiLab;
@property (weak, nonatomic) IBOutlet UILabel *totalShouyiValueLab;
@property (weak, nonatomic) IBOutlet UILabel *fangchanShouyiValueLab;
@property (weak, nonatomic) IBOutlet UILabel *shangchengShouyiValueLab;

- (IBAction)goback:(id)sender;
- (IBAction)zhangdan:(id)sender;
- (IBAction)tixian:(id)sender;
@end
