//
//  HomeAirvalueView.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "HomeAirvalueView.h"
#import "UILabel+RectLabel.h"

@implementation HomeAirvalueView

-(void)awakeFromNib{
    [self.pmNameLabel setcornerRadius:self.pmNameLabel.frame.size.height/2 borderWidth:1 borderColor:[UIColor whiteColor]];
    [self.formaldehyNameLabel setcornerRadius:self.formaldehyNameLabel.frame.size.height/2 borderWidth:1 borderColor:[UIColor whiteColor]];
    [self.temperatureNameLabel setcornerRadius:self.temperatureNameLabel.frame.size.height/2 borderWidth:1 borderColor:[UIColor whiteColor]];
    [self.humidityNameLabel setcornerRadius:self.humidityNameLabel.frame.size.height/2 borderWidth:1 borderColor:[UIColor whiteColor]];
}



@end
