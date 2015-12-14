//
//  ChuangyeController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/29.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChuangyeController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIView *titleBar;
@property (weak, nonatomic) IBOutlet UIButton *shouyiBtn;
@property (weak, nonatomic) IBOutlet UILabel *shouyiLab;
@property (weak, nonatomic) IBOutlet UIButton *shangchengBtn;
@property (weak, nonatomic) IBOutlet UILabel *shangchengLab;
@property (weak, nonatomic) IBOutlet UIButton *fangchanBtn;
@property (weak, nonatomic) IBOutlet UILabel *fangchanLab;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;

- (IBAction)showmenu:(id)sender;
- (IBAction)showHelpInfo:(UIButton *)sender;
@end
