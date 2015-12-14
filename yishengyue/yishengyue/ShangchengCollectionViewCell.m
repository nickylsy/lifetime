//
//  ShangchengCollectionViewCell.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/29.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ShangchengCollectionViewCell.h"
#import "Mydefine.h"

@implementation ShangchengCollectionViewCell

-(void)awakeFromNib
{
    self.layer.borderWidth=1;
    self.layer.borderColor=UIColorFromRGB(0xe9e9e9).CGColor;
    
    self.fenxiangBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
}

@end
