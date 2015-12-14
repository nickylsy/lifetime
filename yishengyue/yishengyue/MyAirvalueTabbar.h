//
//  MyAirvalueTabbar.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/6/12.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAirvalueTabbar : UIView

@property(retain,nonatomic)NSArray *items;
@property(copy,nonatomic)void(^selectedChangedblock)(int index);

-(id)initWithFrame:(CGRect)frame;

-(void)setSelectedItemindex:(int)index;

@end
