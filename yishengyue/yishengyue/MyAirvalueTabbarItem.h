//
//  MyAirvalueTabbarItem.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/6/12.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAirvalueTabbarItem : UIView
@property(retain,nonatomic)UIImageView *imageview;
@property(retain,nonatomic)UILabel *lable;

-(id)initWithFrame:(CGRect)frame Tifle:(NSString *)title Imagename:(NSString *)imagename SelectedImagename:(NSString *)selectedImagename;

-(void)beselected;
-(void)deselected;
@end
