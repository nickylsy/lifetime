//
//  MessageCenterController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/27.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterController : UIViewController

@property(copy,nonatomic)NSString *postURL;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)goback:(id)sender;

@end
