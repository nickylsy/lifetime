//
//  TuihuoCell.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/20.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "TuihuoCell.h"
#import "Mydefine.h"

@implementation TuihuoCell

- (void)awakeFromNib {
    // Initialization code
    
    self.centerView.layer.masksToBounds=YES;
    self.centerView.layer.borderWidth=1;
    self.centerView.layer.cornerRadius=2.0;
    self.centerView.layer.borderColor=UIColorFromRGB(0xe8e8e8).CGColor;
    
    self.IDLab.textColor=UIColorFromRGB(FONT_COLOR_VALUE);
    self.payStateLab.textColor=self.IDLab.textColor;
    self.priceLab.textColor=self.IDLab.textColor;
    self.numberLab.textColor=self.IDLab.textColor;
    self.nameTxt.textColor=self.IDLab.textColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
