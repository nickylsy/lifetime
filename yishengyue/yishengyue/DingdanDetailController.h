//
//  DingdanDetailController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/12.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DingdanCell.h"

@interface DingdanDetailController : UIViewController

@property(assign,nonatomic)DingdanState state;
@property(copy,nonatomic)NSString *orderID;

@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLab;
@property (weak, nonatomic) IBOutlet UITextView *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *dingdanNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *dingdanStateLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *priceDescLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *wuliuLab;
@property (weak, nonatomic) IBOutlet UIView *priceView;


@end
