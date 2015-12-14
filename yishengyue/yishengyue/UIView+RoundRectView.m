//
//  UIView+RoundRectView.m
//  tusheng
//
//  Created by Xtoucher08 on 15/8/10.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "UIView+RoundRectView.h"

@implementation UIView (RoundRectView)

-(void)setcornerRadius:(CGFloat)cornerRadius
{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=cornerRadius;
}

-(void)setcornerRadius:(CGFloat)cornerRadius borderWidh:(CGFloat)borderwidth borderColor:(UIColor *)bordercolor
{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=cornerRadius;
    self.layer.borderWidth=borderwidth;
    self.layer.borderColor=bordercolor.CGColor;
}

-(void)setCircleCorner
{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=self.frame.size.height/2;
}
@end
