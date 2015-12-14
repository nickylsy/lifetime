//
//  MyInputView.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/14.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MyInputView.h"
#import "BDKNotifyHUD.h"
#import "MessageFormat.h"

@implementation MyInputView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
       
    }
    return self;
}

-(void)awakeFromNib
{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=5.0;
    
    self.okBtn.layer.masksToBounds=YES;
    self.okBtn.layer.cornerRadius=5.0;
    
    self.cancelBtn.layer.masksToBounds=YES;
    self.cancelBtn.layer.cornerRadius=5.0;
}
- (IBAction)ok:(id)sender {
    if (self.nameTxt.text.length<1) {
        [MessageFormat hintWithMessage:@"您还没有输入" inview:self completion:nil];
        return;
    }
    [self cancel:sender];
}

- (IBAction)cancel:(id)sender {
    if (self.dismisscallback) {
        self.dismisscallback(self.nameTxt.text);
        [self removeFromSuperview];
    }
}

@end
