//
//  HomeFuncItem.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "HomeFuncItem.h"
#import "Mydefine.h"

@interface HomeFuncItem()
{
    UILabel *_messageNumberLab;
}
@end

@implementation HomeFuncItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)itemWithFrame:(CGRect)frame image:(UIImage *)image Highlightedimage:(UIImage *)selectedimage text:(NSString *)text
{
    return [[self alloc] initWithFrame:frame image:image Highlightedimage:selectedimage text:text];
}

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image Highlightedimage:(UIImage *)selectedimage text:(NSString *)text{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=UIColorFromRGB(0xffffff);
        
        CGFloat btnheight=frame.size.height/2;
        CGFloat labheight=20.0;
        self.btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0,btnheight,btnheight)];
        self.btn.center=CGPointMake(frame.size.width/2, frame.size.height/2-labheight/2);
        [self.btn setImage:image forState:UIControlStateNormal];
        [self.btn setImage:selectedimage forState:UIControlStateHighlighted];
        self.btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:self.btn];
        
        _messageNumberLab=[[UILabel alloc] initWithFrame:CGRectMake(btnheight*2/3, 0, btnheight/3, btnheight/3)];
        _messageNumberLab.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
        _messageNumberLab.textAlignment=NSTextAlignmentCenter;
        _messageNumberLab.textColor=[UIColor whiteColor];
        _messageNumberLab.layer.masksToBounds=YES;
        _messageNumberLab.layer.cornerRadius=_messageNumberLab.frame.size.height/2;
        _messageNumberLab.hidden=YES;
        _messageNumberLab.font=[UIFont systemFontOfSize:btnheight/3];
        [self.btn addSubview:_messageNumberLab];
        
        self.lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, labheight)];
        self.lab.center=CGPointMake(frame.size.width/2, self.btn.frame.origin.y+btnheight+labheight/2 + 5);
        self.lab.textAlignment=NSTextAlignmentCenter;
        self.lab.text=text;
        self.lab.textColor=[UIColor blackColor];
        self.lab.font=[UIFont systemFontOfSize:18];
        [self addSubview:self.lab];
    }
    return self;
}

-(void)showMessagenumberWihtNumber:(int)number
{
    if (number<1) {
        _messageNumberLab.hidden=YES;
    }else{
        _messageNumberLab.hidden=NO;
        _messageNumberLab.text=[NSString stringWithFormat:@"%i",number];
    }
}

@end
