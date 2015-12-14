//
//  AddInterestView.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/9/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AddInterestView.h"
#import "UIView+RoundRectView.h"
#import "Mydefine.h"
@implementation AddInterestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.descTxt setcornerRadius:5.0 borderWidh:1.0 borderColor:UIColorFromRGB(0xe5e5e5)];
    self.descTxt.placeholder=@"介绍几句吧";
    [self.releaseBtn setcornerRadius:5.0];
}

@end
