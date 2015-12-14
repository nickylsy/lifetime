//
//  RemotecontrolCollectionViewCell.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/11.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "RemotecontrolCollectionViewCell.h"

@implementation RemotecontrolCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:self.bounds];
        imageview.image=[UIImage imageNamed:@"controlbtnborder.png"];
        [self addSubview:imageview];
        
        CGRect contentframe=CGRectMake(frame.size.width/2-frame.size.height/2+5,5, frame.size.height-10, frame.size.height-10);
        
        self.contentImg=[[UIImageView alloc] initWithFrame:contentframe];
        [self addSubview:self.contentImg];
        
        self.contentLab=[[UILabel alloc] initWithFrame:self.bounds];
        self.contentLab.textAlignment=NSTextAlignmentCenter;
        self.contentLab.textColor=[UIColor whiteColor];
        [self addSubview:self.contentLab];
    }
    return self;
}

@end
