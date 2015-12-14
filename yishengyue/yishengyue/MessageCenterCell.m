//
//  MessageCenterCell.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/28.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MessageCenterCell.h"
#import "Mydefine.h"

@implementation MessageCenterCell

- (void)awakeFromNib {
    // Initialization code
    self.centerview.layer.masksToBounds=YES;
    self.centerview.layer.cornerRadius=5.0;
    self.centerview.layer.borderWidth=1;
    self.centerview.layer.borderColor=UIColorFromRGB(0XCACACA).CGColor;
    
//    self.centerview.layer.shadowOffset=CGSizeMake(0, 2);
//    self.centerview.layer.shadowOpacity=0.8;
//    self.centerview.layer.shadowColor=[UIColor blackColor].CGColor;
    
    self.contentLab.textColor=UIColorFromRGB(0x868686);
    self.dateLab.textColor=UIColorFromRGB(0x969696);
    self.titleLab.textColor=UIColorFromRGB(FONT_COLOR_VALUE);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
