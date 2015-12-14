//
//  SmarcontrolCollectionViewCell.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/22.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "SmarcontrolCollectionViewCell.h"

@implementation SmarcontrolCollectionViewCell

//-(id)initAddcell
//{
//    self=[super init];
//    if (self!=nil) {
//        CGFloat x=self.frame.size.width/2;
//        CGFloat y=self.frame.size.height/2;
//        CGFloat width=self.frame.size.width*0.64;
//        CGFloat height=self.frame.size.height*0.64;
//        
//        self.logoImg.frame=CGRectMake(x, y, width, height);
//        self.logoImg.image=[UIImage imageNamed:@"add.png"];
//    }
//    return self;
//}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        CGFloat x=self.frame.size.width/4;
        CGFloat y=self.frame.size.height/6;
        CGFloat width=self.frame.size.width/2;
        CGFloat height=self.frame.size.height/2;
        
        self.logoImg=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self addSubview:self.logoImg];
        
        self.nameLab=[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.7, self.frame.size.width, self.frame.size.height/5)];
        self.nameLab.textAlignment=NSTextAlignmentCenter;
        self.nameLab.textColor=[UIColor grayColor];
        [self addSubview:self.nameLab];
    }
    return self;
}

@end
