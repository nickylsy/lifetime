//
//  ShoppingcartTableViewCell.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/23.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingcartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoimageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *choiceImg;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UIView *centerview;

@end
