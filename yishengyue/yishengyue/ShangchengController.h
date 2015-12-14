//
//  ShangchengController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/25.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShangchengController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *gouwucheBtn;
@property (weak, nonatomic) IBOutlet UIView *titleBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *titleSmt;
@property (weak, nonatomic) IBOutlet UIView *shangchengView;

- (IBAction)showmenu:(id)sender;
- (IBAction)changePage:(UISegmentedControl *)sender;
- (IBAction)gotoshopcart:(UIButton *)sender;



@end
