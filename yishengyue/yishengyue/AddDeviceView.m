//
//  AddDeviceView.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AddDeviceView.h"
#import "BDKNotifyHUD.h"

@implementation AddDeviceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)addDevice:(id)sender {
    if (self.devicelogoImg.image==nil) {
        BDKNotifyHUD *hud=[BDKNotifyHUD notifyHUDWithImage:nil text:@"请选择图标"];
        hud.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:hud];
        [hud presentWithDuration:0.5 speed:0.3 inView:self completion:^{
            [hud removeFromSuperview];
        }];
        return;
    }
    if (self.devicenameTxt.text.length<1) {
        BDKNotifyHUD *hud=[BDKNotifyHUD notifyHUDWithImage:nil text:@"请输入名字"];
        hud.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:hud];
        [hud presentWithDuration:0.5 speed:0.3 inView:self completion:^{
            [hud removeFromSuperview];
        }];
        return;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObject:self.devicenameTxt.text forKey:KEY_NAME];
    [dic setValue:[NSNumber numberWithInteger:self.tag] forKey:KEY_CATEGORY];
    [[NSNotificationCenter defaultCenter] postNotificationName:MSG_ADDDEVICE object:nil userInfo:dic];
    [self cancel:sender];
}

-(void)setDismissBlock:(void (^)())correctBlock
{
    self.onDismissalWithout=correctBlock;
}

- (IBAction)cancel:(id)sender {
    if (self.onDismissalWithout) {
       self.onDismissalWithout();
    }
    [self removeFromSuperview];
}

- (IBAction)changelogo:(UIButton *)sender {
    self.tag=sender.tag;
    switch (sender.tag) {
        case 1:
        {
            self.devicelogoImg.image=[UIImage imageNamed:@"tv.png"];
            break;
        }
        case 2:
        {
            self.devicelogoImg.image=[UIImage imageNamed:@"kongtiao.png"];
            break;
        }
        case 3:
        {
            self.devicelogoImg.image=[UIImage imageNamed:@"aircleaner.png"];
            break;
        }
        case 4:
        {
            self.devicelogoImg.image=[UIImage imageNamed:@"other.png"];
            break;
        }
        default:
            break;
    }
}
-(void)setborder
{
    self.layer.borderWidth=1;
    self.devicelogoImg.layer.borderWidth=1;
}
@end
