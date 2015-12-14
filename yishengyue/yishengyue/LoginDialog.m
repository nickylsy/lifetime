//
//  LoginDialog.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/26.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "LoginDialog.h"

@implementation LoginDialog

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
    self.layer.cornerRadius=10.0;
    self.registerLab.userInteractionEnabled=YES;
    UITapGestureRecognizer *registertap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registeruser)];
    [self.registerLab addGestureRecognizer:registertap];
}

-(void)registeruser
{
    if (self.registerblock) {
        self.registerblock();
    }
    [self dismissview];
}
- (IBAction)closeDialog:(id)sender {
    [self dismissview];
}

- (IBAction)login:(id)sender {
    
    if (self.loginblock) {
        self.loginblock(self.phoneNumTxt.text,self.passwordTxt.text);
    }
    [self dismissview];
}

-(void)dismissview
{
    [self removeFromSuperview];
    if (self.dismissblock) {
        self.dismissblock();
    }
}
@end
