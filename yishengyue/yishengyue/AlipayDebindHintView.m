//
//  AlipayDebindHintView.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/27.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AlipayDebindHintView.h"
#import "UIButton+Rectbutton.h"

@implementation AlipayDebindHintView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=10.0;
   
    [self.cancelBtn setcornerRadius:5.0];
    [self.okBtn setcornerRadius:5.0];
}
- (IBAction)cancel:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
}

- (IBAction)ok:(id)sender {
    if (self.okBlock) {
        self.okBlock(self.PSDTxt.text);
    }
    [self cancel:sender];
}
@end
