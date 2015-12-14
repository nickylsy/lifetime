//
//  LikeListController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/9/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeListController : UIViewController

@property(copy,nonatomic)NSString *interestID;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)goback:(UIButton *)sender;
@end
