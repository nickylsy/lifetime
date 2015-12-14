//
//  SmarcontrolCollectionViewCell.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/22.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmarcontrolCollectionViewCell : UICollectionViewCell
@property (retain, nonatomic) UIImageView *logoImg;
@property (retain, nonatomic) UILabel *nameLab;

//-(id)initAddcell;

-(id)initWithFrame:(CGRect)frame;

@end
