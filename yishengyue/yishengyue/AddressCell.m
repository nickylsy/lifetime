//
//  AddressCell.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/30.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    // Initialization code
    [self.addressLab sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
