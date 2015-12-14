//
//  MyshopsController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/14.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyshopsController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *shopsSgm;

- (IBAction)changePage:(UISegmentedControl *)sender;
- (IBAction)goback:(UIButton *)sender;
- (IBAction)addShop:(UIButton *)sender;
@end
