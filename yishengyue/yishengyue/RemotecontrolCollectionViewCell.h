//
//  RemotecontrolCollectionViewCell.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/11.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemotecontrolCollectionViewCell : UICollectionViewCell
@property (retain, nonatomic)UIImageView *contentImg;
@property (retain, nonatomic)UILabel *contentLab;

-(instancetype)initWithFrame:(CGRect)frame;

@end
