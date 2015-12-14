//
//  ShoppingcartTableViewCell.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/23.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ShoppingcartTableViewCell.h"
#import "Mydefine.h"

@implementation ShoppingcartTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.centerview.layer.borderColor=UIColorFromRGB(0xe6e6e6).CGColor;
    self.centerview.layer.borderWidth=1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
