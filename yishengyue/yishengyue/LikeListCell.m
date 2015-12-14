//
//  LikeListCell.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/9/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "LikeListCell.h"
#import "Mydefine.h"
#import "UIView+RoundRectView.h"

@implementation LikeListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self.iconImg setCircleCorner];
    [self.phoneBtn setcornerRadius:5.0];
    [self.phoneBtn setTitle: @"电话\n预约" forState: UIControlStateNormal];
    self.phoneBtn.titleLabel.numberOfLines=0;
    self.phoneBtn.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    
    [self.centerView setcornerRadius:5.0];
    self.backgroundColor=[UIColor clearColor];
    
    self.nameLab.textColor=UIColorFromRGB(0x9f9d9e);
    self.themeLab.textColor=self.nameLab.textColor;
    self.timeLab.textColor=self.nameLab.textColor;
    self.descLab.textColor=self.nameLab.textColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
