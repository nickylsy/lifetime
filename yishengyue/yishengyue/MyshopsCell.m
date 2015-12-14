//
//  MyshopsCell.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/13.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MyshopsCell.h"
#import "Mydefine.h"

@implementation MyshopsCell

- (void)awakeFromNib {
    // Initialization code
    
    self.xiajiaLab.layer.masksToBounds=YES;
    self.xiajiaLab.layer.cornerRadius=self.xiajiaLab.frame.size.height/2;
    
    self.xiajiaBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.editBtn.imageView.contentMode=self.xiajiaBtn.imageView.contentMode;
    
    self.titleLab.textColor=UIColorFromRGB(0x313131);
    self.timeLab.textColor=UIColorFromRGB(0x989898);
    
    self.centerView.layer.masksToBounds=YES;
    self.centerView.layer.cornerRadius=5.0;
    self.centerView.layer.borderColor=UIColorFromRGB(0xc8c8c8).CGColor;
    self.centerView.layer.borderWidth=1.0;
    
    self.xiangqingBtn.layer.masksToBounds=YES;
    self.xiangqingBtn.layer.cornerRadius=5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setState:(MyshopState)state
{
    switch (state) {
        case MyshopStateSelling:
        {
            self.xiajiaLab.hidden=YES;
            self.xiangqingBtn.hidden=YES;
            self.editView.hidden=NO;
            break;
        }
            
        case MyshopStateUndercarriage:
        {
            self.xiajiaLab.hidden=NO;
            self.xiangqingBtn.hidden=NO;
            self.editView.hidden=YES;
            break;
        }
            
        default:
            break;
    }
}
@end
