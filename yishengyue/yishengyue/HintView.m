//
//  HintView.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/29.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "HintView.h"

#define TOPJIAN_HEIGHT 10

@implementation HintView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame string:(NSString *)string
{
    if (self=[super initWithFrame:frame]) {
        
        UIImageView *topjian=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hinttop.png"]];
        topjian.frame=CGRectMake(frame.size.width*5/7, 0, TOPJIAN_HEIGHT*1.5, TOPJIAN_HEIGHT);
        [self addSubview:topjian];
        
        
        UITextView *label=[[UITextView alloc] initWithFrame:CGRectMake(0, TOPJIAN_HEIGHT, frame.size.width, frame.size.height-TOPJIAN_HEIGHT)];
        label.font=[UIFont systemFontOfSize:14.0];
        label.text=string;
        label.backgroundColor=[UIColor blackColor];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentNatural;
        label.editable=NO;
        label.layer.masksToBounds=YES;
        label.layer.cornerRadius=5;
        [self addSubview:label];
        
        
        self.layer.masksToBounds=YES;
        self.alpha=0.85;
        self.backgroundColor=[UIColor clearColor];
        self.hidden=YES;
    }
    return self;
}

@end
