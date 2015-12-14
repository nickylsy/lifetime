//
//  ShangchengTableViewCell.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/29.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ShangchengTableViewCell.h"
#import "Mydefine.h"

@implementation ShangchengTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.fenxiangBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    self.centerview.layer.borderWidth=1;
    self.centerview.layer.borderColor=UIColorFromRGB(0xebebeb).CGColor;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
