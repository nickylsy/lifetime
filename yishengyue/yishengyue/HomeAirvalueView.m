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

-(void)awakeFromNib
{
    [self.pm25Name setcornerRadius:self.pm25Name.frame.size.height/2 borderWidth:1 borderColor:[UIColor whiteColor]];
    [self.jiaquanName setcornerRadius:self.jiaquanName.frame.size.height/2 borderWidth:1 borderColor:[UIColor whiteColor]];
    [self.wenduName setcornerRadius:self.wenduName.frame.size.height/2 borderWidth:1 borderColor:[UIColor whiteColor]];
    [self.shiduName setcornerRadius:self.shiduName.frame.size.height/2 borderWidth:1 borderColor:[UIColor whiteColor]];
}
@end
