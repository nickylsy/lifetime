//
//  MyAirvalueTabbarItem.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/6/12.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MyAirvalueTabbarItem.h"
#import "Mydefine.h"

@interface MyAirvalueTabbarItem()
{
    UIImage *_sectionimage;
    UIImage *_selectedsectionimage;
}
@end

@implementation MyAirvalueTabbarItem

-(id)initWithFrame:(CGRect)frame Tifle:(NSString *)title Imagename:(NSString *)imagename SelectedImagename:(NSString *)selectedImagename
{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=UIColorFromRGB(0xefefef);
        
        _sectionimage=[UIImage imageNamed:imagename];
        _selectedsectionimage=[UIImage imageNamed:selectedImagename];
        
        self.imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 30)];
        self.imageview.contentMode=UIViewContentModeScaleAspectFit;
        self.imageview.image=_sectionimage;
        [self addSubview:self.imageview];
        
        self.lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height-40)];
        self.lable.textAlignment=NSTextAlignmentCenter;
        self.lable.textColor=UIColorFromRGB(0xa5a5a5);
        self.lable.text=title;
        [self addSubview:self.lable];
    }
    return self;
}

-(void)beselected
{
    self.imageview.image=_selectedsectionimage;
    self.lable.textColor=UIColorFromRGB(0x25c5b6);
}

-(void)deselected
{
    self.imageview.image=_sectionimage;
    self.lable.textColor=UIColorFromRGB(0xa5a5a5);
}
@end
