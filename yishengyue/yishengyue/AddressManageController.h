//
//  AddressManageController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/17.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressManageController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)goback:(UIButton *)sender;
@end
