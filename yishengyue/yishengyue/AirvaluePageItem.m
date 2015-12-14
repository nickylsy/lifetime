//
//  AirvaluePageItem.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/17.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AirvaluePageItem.h"
#import "CircleProgressView.h"
#import "Mydefine.h"

@interface AirvaluePageItem()
@property(retain,nonatomic)CircleProgressView *progressview;
@property(retain,nonatomic)UILabel *hintLab;
@end

@implementation AirvaluePageItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame string:(NSString *)biaozhunstring maxNumber:(CGFloat)num isJiaquan:(BOOL)isjiaquan
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=UIColorFromRGB(0xefefef);
        CGFloat screenheight=[UIScreen mainScreen].bounds.size.height;
        CGFloat screenwidth=[UIScreen mainScreen].bounds.size.width;
        CGFloat scrollheight=frame.size.height;
        _progressview=[[CircleProgressView alloc] initWithFrame:CGRectMake(20, screenheight>480?scrollheight/10:scrollheight/30, screenwidth*2/3, screenwidth*2/3)];
        _progressview.center=CGPointMake(screenwidth/2,_progressview.center.y);
        _progressview.isjiaquan=isjiaquan;
        _progressview.hintstring=biaozhunstring;
        [_progressview setTimeLimit:num];
        [_progressview setTintColor:UIColorFromRGB(0xa2a2a2)];
        
        [self addSubview:_progressview];
        
        
        _hintLab=[[UILabel alloc] initWithFrame:CGRectMake(0, _progressview.frame.origin.y+_progressview.frame.size.height, screenwidth, scrollheight-(_progressview.frame.origin.y+_progressview.frame.size.height))];
        _hintLab.numberOfLines=3;
        _hintLab.textAlignment=NSTextAlignmentCenter;
        _hintLab.textColor=UIColorFromRGB(0x4f4d4d);
        [self addSubview:_hintLab];
    }
    return self;
}


-(void)setScore:(CGFloat)score
{
    [_progressview setElapsedTime:score];
}

-(void)setHintString:(NSString *)string colorRange:(NSRange)range
{
    NSMutableAttributedString *att=[[NSMutableAttributedString alloc] initWithString:string];
    [att addAttributes:@{
                         NSForegroundColorAttributeName:UIColorFromRGB(MAIN_COLOR_VALUE) } range:range];
    [_hintLab setAttributedText:att];
}

-(void)updatelevelWithLevelstring:(NSString *)string image:(UIImage *)image color:(UIColor *)color
{
    [_progressview updatelevelWithLevelstring:string image:image color:color];
}
@end
