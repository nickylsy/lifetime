//
//  AirvaluePageItem.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/17.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirvaluePageItem : UIView

-(instancetype)initWithFrame:(CGRect)frame string:(NSString *)biaozhunstring maxNumber:(CGFloat)num isJiaquan:(BOOL)isjiaquan;

-(void)setScore:(CGFloat)score;
-(void)setHintString:(NSString *)string colorRange:(NSRange)range;

-(void)updatelevelWithLevelstring:(NSString *)string image:(UIImage *)image color:(UIColor *)color;
@end
