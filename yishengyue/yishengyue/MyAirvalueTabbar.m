//
//  MyAirvalueTabbar.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/6/12.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MyAirvalueTabbar.h"
#import "MyAirvalueTabbarItem.h"
#import "Mydefine.h"

@interface MyAirvalueTabbar()

@property(nonatomic,retain)UIView *indicator;
@property(assign,nonatomic)int selectedIndex;

@end

@implementation MyAirvalueTabbar

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=UIColorFromRGB(0xedeced);
        
        CGFloat indicatorheight=4;
        CGFloat bottomheight=1;
        CGFloat itemheight=frame.size.height-bottomheight;
        CGFloat itemwidth=frame.size.width/4;
        MyAirvalueTabbarItem *pm25item=[[MyAirvalueTabbarItem alloc] initWithFrame:CGRectMake(0, 0, itemwidth, itemheight) Tifle:@"PM2.5" Imagename:@"tab_pm25.png" SelectedImagename:@"tab_pm25_selected.png"];
        pm25item.tag=0;
        [self addSubview:pm25item];
        
        MyAirvalueTabbarItem *jiaquanitem=[[MyAirvalueTabbarItem alloc] initWithFrame:CGRectMake(itemwidth, 0, itemwidth, itemheight) Tifle:@"甲醛" Imagename:@"tab_jiaquan.png" SelectedImagename:@"tab_jiaquan_selected.png"];
        jiaquanitem.tag=1;
        [self addSubview:jiaquanitem];
        
        MyAirvalueTabbarItem *wenduitem=[[MyAirvalueTabbarItem alloc] initWithFrame:CGRectMake(itemwidth*2, 0, itemwidth, itemheight) Tifle:@"温度" Imagename:@"tab_wendu.png" SelectedImagename:@"tab_wendu_selected.png"];
        wenduitem.tag=2;
        [self addSubview:wenduitem];
        
        MyAirvalueTabbarItem *shiduitem=[[MyAirvalueTabbarItem alloc] initWithFrame:CGRectMake(itemwidth*3, 0, itemwidth, itemheight) Tifle:@"湿度" Imagename:@"tab_shidu.png" SelectedImagename:@"tab_shidu_selected.png"];
        shiduitem.tag=3;
        [self addSubview:shiduitem];
        
        UIImageView *bottomimageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-bottomheight, frame.size.width, bottomheight)];
        bottomimageview.backgroundColor=UIColorFromRGB(0xa7a7a7);
        [self addSubview:bottomimageview];
        
        self.indicator=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-indicatorheight, itemwidth, indicatorheight)];
        self.indicator.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
        self.indicator.alpha=0.8;
        [self addSubview:self.indicator];
        
        self.items=@[pm25item,jiaquanitem,wenduitem,shiduitem];
        [pm25item beselected];
        _selectedIndex=0;
        
        for (MyAirvalueTabbarItem *item in _items) {
            item.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSelectedItem:)];
            [item addGestureRecognizer:tap];
        }
    }
    
    return self;
}

-(void)changeSelectedItem:(UITapGestureRecognizer *)gesture
{
    
    [(MyAirvalueTabbarItem *)_items[_selectedIndex] deselected];
    [(MyAirvalueTabbarItem *)_items[gesture.view.tag] beselected];
    _selectedIndex=(int)gesture.view.tag;
    
    [UIView animateWithDuration:0.2 animations:^{
        _indicator.center=CGPointMake(self.frame.size.width/8+gesture.view.tag*self.frame.size.width/4, self.frame.size.height-1);
    } completion:^(BOOL finished) {
        if (self.selectedChangedblock) {
            self.selectedChangedblock(_selectedIndex);
        }
    }];
}

-(void)setSelectedItemindex:(int)index
{
    
    [(MyAirvalueTabbarItem *)_items[_selectedIndex] deselected];
    [(MyAirvalueTabbarItem *)_items[index] beselected];
    _selectedIndex=index;
    
    [UIView animateWithDuration:0.1 animations:^{
        _indicator.center=CGPointMake(self.frame.size.width/8+index*self.frame.size.width/4, self.frame.size.height-1);
    } completion:nil];
}
@end
