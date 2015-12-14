//
//  UILabel+RectLabel.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "UILabel+RectLabel.h"

@implementation UILabel (RectLabel)
-(void)setcornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderwidth borderColor:(UIColor *)bordercolor
{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=cornerRadius;
    self.layer.borderWidth=borderwidth;
    self.layer.borderColor=bordercolor.CGColor;
}
@end
