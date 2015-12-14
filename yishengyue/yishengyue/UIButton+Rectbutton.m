//
//  UIButton+Rectbutton.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/6/10.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "UIButton+Rectbutton.h"

@implementation UIButton (Rectbutton)

-(void)setcornerRadius:(CGFloat)cornerRadius
{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=cornerRadius;
}

@end
