//
//  JingjirenShangchengCell.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/9/2.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "JingjirenShangchengCell.h"
#import "Mydefine.h"

@implementation JingjirenShangchengCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderWidth=1;
    self.layer.borderColor=UIColorFromRGB(0xe9e9e9).CGColor;
    
    self.nameLab.textColor=UIColorFromRGB(FONT_COLOR_VALUE);
    
    self.shareBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
}
@end
