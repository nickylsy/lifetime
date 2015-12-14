//
//  HomeFuncItem.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeFuncItem : UIView


@property(retain,nonatomic)UIButton *btn;
@property(retain,nonatomic)UILabel *lab;

+(instancetype)itemWithFrame:(CGRect)frame image:(UIImage *)image Highlightedimage:(UIImage *)Highlightedimage text:(NSString *)text;
-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image Highlightedimage:(UIImage *)Highlightedimage text:(NSString *)text;

-(void)showMessagenumberWihtNumber:(int)number;
@end
