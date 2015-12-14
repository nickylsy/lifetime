//
//  UIView+RoundRectView.h
//  tusheng
//
//  Created by Xtoucher08 on 15/8/10.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RoundRectView)

-(void)setcornerRadius:(CGFloat)cornerRadius;

-(void)setcornerRadius:(CGFloat)cornerRadius borderWidh:(CGFloat)borderwidth borderColor:(UIColor *)bordercolor;

-(void)setCircleCorner;
@end
