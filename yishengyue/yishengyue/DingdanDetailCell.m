//
//  DingdanDetailCell.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/14.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "DingdanDetailCell.h"
#import "UIButton+Rectbutton.h"
#import "Mydefine.h"
@implementation DingdanDetailCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self.tuihuoBtn setcornerRadius:5.0];
    self.tuihuoBtn.layer.borderColor=self.tuihuoBtn.titleLabel.textColor.CGColor;
    self.tuihuoBtn.layer.borderWidth=1;
    [self.tuihuoBtn addTarget:self action:@selector(tuihuo) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleTxt.textColor=UIColorFromRGB(FONT_COLOR_VALUE);
    self.priceLab.textColor=self.titleTxt.textColor;
    self.numberLab.textColor=self.titleTxt.textColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

-(void)tuihuo
{
    if ([self.mydelegate respondsToSelector:@selector(tuihuo:)]) {
        [self.mydelegate tuihuo:self];
    }
}
@end
