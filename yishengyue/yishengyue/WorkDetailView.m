//
//  WorkDetailView.m
//  yishengyue
//
//  Created by 华为-xtoucher on 15/9/18.
//  Copyright © 2015年 Xtoucher08. All rights reserved.
//

#import "WorkDetailView.h"
#import "UIView+RoundRectView.h"

@implementation WorkDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.phoneBtn setcornerRadius:5.0];
}

@end
