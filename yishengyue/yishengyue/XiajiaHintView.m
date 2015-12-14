//
//  XiajiaHintView.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "XiajiaHintView.h"
#import "Mydefine.h"

@implementation XiajiaHintView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    self.layer.masksToBounds=YES;
    self.layer.borderColor=UIColorFromRGB(0x6f6e6e).CGColor;
    self.layer.cornerRadius=5.0;
    self.layer.borderWidth=1.0;
    
    self.BeizhuTxt.layer.masksToBounds=YES;
    self.BeizhuTxt.layer.borderColor=UIColorFromRGB(0xf2f2f2).CGColor;
    self.BeizhuTxt.layer.cornerRadius=3.0;
    self.BeizhuTxt.layer.borderWidth=1.0;
    
    self.BeizhuTxt.placeholder=@"请输入下架商品备注";
}
- (IBAction)cancel:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (IBAction)OK:(id)sender {
    if (self.OKBlock) {
        self.OKBlock(self.BeizhuTxt.text);
    }
    [self cancel:sender];
}
@end
