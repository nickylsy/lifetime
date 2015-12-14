//
//  QuerenDingdanController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/30.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressInfo;

@interface QuerenDingdanController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property(retain,nonatomic)NSMutableArray *goods;
@property(copy,nonatomic)NSString *totalstring;
@property(assign,nonatomic)BOOL  clearcart;

- (IBAction)OK:(UIButton *)sender;
@end
