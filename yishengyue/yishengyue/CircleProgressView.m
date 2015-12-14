//
//  CircleProgressView.m
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "CircleProgressView.h"
#import "CircleShapeLayer.h"
#import "Mydefine.h"

@interface CircleProgressView()

@end

@implementation CircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressLayer.frame = self.bounds;
    
//    [self.progressLabel sizeToFit];
    self.progressLabel.center = CGPointMake(self.center.x - self.frame.origin.x,self.frame.size.height/2);
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        
        CGFloat lvheight=self.frame.size.height/6;
        CGFloat lvcenterx=self.frame.size.width/2;
        CGFloat lvcentery=self.frame.size.height/4;
        CGFloat lvwidth=lvheight;
        
        _levelLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,lvwidth , lvheight)];
        _levelLabel.center=CGPointMake(lvcenterx,lvcentery);
        _levelLabel.textAlignment=NSTextAlignmentCenter;
        _levelLabel.font=[UIFont systemFontOfSize:lvheight];
        _levelLabel.text=nil;
        _levelLabel.textColor=[UIColor redColor];
        [self addSubview:_levelLabel];
        
        CGFloat imgwidth=lvheight/2;
        CGFloat imgcenterx=lvcenterx+lvwidth/2+imgwidth/2;
        CGFloat imgcentery=lvcentery+lvheight/2-imgwidth/2;
        
        _levelImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgwidth,imgwidth)];
        _levelImg.center=CGPointMake(imgcenterx, imgcentery);
        _levelImg.image=[UIImage imageNamed:nil];
        [self addSubview:_levelImg];
        
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height*2/3)];
        _progressLabel.font=[UIFont systemFontOfSize:self.frame.size.height/200*40];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.lineBreakMode=NSLineBreakByCharWrapping;
        _progressLabel.textColor=UIColorFromRGB(0x959596);
        
        [self addSubview:_progressLabel];
        
        UILabel *deslabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height*2/3, self.bounds.size.width, self.bounds.size.height/5)];
        deslabel.textAlignment=NSTextAlignmentCenter;
        deslabel.textColor=UIColorFromRGB(0x959596);
        deslabel.text=_hintstring;
        deslabel.font=[UIFont systemFontOfSize:self.frame.size.height/300*18];
//        deslabel.alpha=0.5;
        [self addSubview:deslabel];
        
        CGFloat numlabelwidth=deslabel.frame.size.width/9;
        CGFloat numlabelheight=deslabel.frame.size.height/2;
        UILabel *minlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, deslabel.frame.origin.y+numlabelheight, numlabelwidth, numlabelheight)];;
        minlabel.textAlignment=NSTextAlignmentRight;
        minlabel.font=[UIFont systemFontOfSize:numlabelheight*0.6];
        minlabel.text=@"0";
        minlabel.textColor=UIColorFromRGB(0x959596);
        [self addSubview:minlabel];
        
        UILabel *maxlabel=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-numlabelwidth, deslabel.frame.origin.y+numlabelheight, numlabelwidth, numlabelheight)];;
        maxlabel.textAlignment=NSTextAlignmentLeft;
        maxlabel.font=minlabel.font;
        maxlabel.text=[self stringDisposeWithFloat:self.timeLimit];
        maxlabel.textColor=UIColorFromRGB(0x959596);
        [self addSubview:maxlabel];
        
    }
    
    return _progressLabel;
}

- (double)percent {
    return self.progressLayer.percent;
}

- (NSTimeInterval)timeLimit {
    return self.progressLayer.timeLimit;
}

- (void)setTimeLimit:(NSTimeInterval)timeLimit {
    self.progressLayer.timeLimit = timeLimit;
}

- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
    _elapsedTime = elapsedTime;
    self.progressLayer.elapsedTime = elapsedTime;
    self.progressLabel.text=nil;
    self.progressLabel.text=_isjiaquan?[self stringDisposeWithFloat:_elapsedTime]:[self stringFromTimeInterval:_elapsedTime];
    
}

#pragma mark - Private Methods

- (void)setupViews {
    
    self.backgroundColor = UIColorFromRGB(0xefefef);
    self.clipsToBounds = false;
    
    //add Progress layer
    self.progressLayer = [[CircleShapeLayer alloc] initWithframe:self.bounds];
    self.progressLayer.backgroundColor = self.backgroundColor.CGColor;
    [self.layer addSublayer:self.progressLayer];
    
}

- (void)setTintColor:(UIColor *)tintColor {
    self.progressLayer.progressColor = tintColor;
//    self.progressLabel.textColor = tintColor;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval{

    return [NSString stringWithFormat:@"%.1f",interval];
}

-(void)updatelevelWithLevelstring:(NSString *)string image:(UIImage *)image color:(UIColor *)color
{
    CGFloat lvheight=self.frame.size.height/6;
    CGFloat lvcenterx=self.frame.size.width/2;
    CGFloat lvcentery=self.frame.size.height/4;
    
    CGSize size = CGSizeMake(10000,lvheight);  //设置宽高，其中高为允许的最大高度
    CGSize labelsize = [string sizeWithFont:[UIFont systemFontOfSize:lvheight] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat lvwidth=labelsize.width;
    
    
    _levelLabel.frame=CGRectMake(0, 0,lvwidth , lvheight);
    _levelLabel.center=CGPointMake(lvcenterx,lvcentery);
    _levelLabel.text=string;
    _levelLabel.textColor=color;
    [self setTintColor:color];
    
    CGFloat imgwidth=_levelImg.frame.size.width;
    CGFloat imgcenterx=lvcenterx+lvwidth/2+imgwidth/2;
    CGFloat imgcentery=lvcentery+lvheight/2-imgwidth/2;
    
    _levelImg.center=CGPointMake(imgcenterx, imgcentery);
    _levelImg.image=image;
}

-(NSString *)stringDisposeWithFloat:(float)floatValue
{
    NSString *str = [NSString stringWithFormat:@"%.3f",floatValue];
    int len = (int)str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}
@end

