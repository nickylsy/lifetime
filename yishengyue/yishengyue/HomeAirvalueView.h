//
//  HomeAirvalueView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeValueModel.h"
@interface HomeAirvalueView : UIView

@property (weak, nonatomic) IBOutlet UILabel *pmValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *formaldehydeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempertureValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *pmNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *formaldehyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityNameLabel;

@property (nonatomic,strong)NSTimer * timer;
-(void)configDataValueWithModel:(HomeValueModel *)model;

@end
