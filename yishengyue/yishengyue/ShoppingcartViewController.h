//
//  ShoppingcartViewController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/23.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingcartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain,nonatomic)NSMutableArray       * goods;
@property (weak, nonatomic) IBOutlet UITableView * tableview;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;


- (IBAction)goback:(UIButton *)sender;
- (IBAction)querendingdan:(UIButton *)sender;
- (IBAction)selectAll:(UIButton *)sender;
- (IBAction)deleteShop:(UIButton *)sender;
@end
