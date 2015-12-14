//
//  AirboxConfigStep2ViewController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/15.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AirboxConfigStep2ViewController.h"
#import "AirboxConfigStep3ViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "UIButton+Rectbutton.h"
#import "Mydefine.h"
#import "MessageFormat.h"




@interface AirboxConfigStep2ViewController ()<UITextFieldDelegate>

@end

@implementation AirboxConfigStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self relayoutsubviews];
    
    self.password.delegate=self;
    self.SSIDList.delegate=self;
    [self.SSIDList setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UITapGestureRecognizer *hidekeyboardTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidekeyboard)];
    [self.view addGestureRecognizer:hidekeyboardTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)hidekeyboard
{
    [self.SSIDList endEditing:YES];
    [self.password endEditing:YES];
}
-(void)relayoutsubviews
{
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat screenheight=self.view.frame.size.height;
    CGFloat priorityX=screenwidth/SCREENWIDTH_5S;
    CGFloat priorityY=screenheight/SCREENHEIGHT_5S;
    
    self.stepImg.frame=CGRectMake(15*priorityX, 81*priorityY, 290*priorityX, 76*priorityY);
    
    self.hintImg.frame=CGRectMake(61*priorityY, 184*priorityY, 200*priorityY, 200*priorityY);
    self.hintImg.center=CGPointMake(screenwidth/2, screenheight/2);
    
    self.SSIDList.frame=CGRectMake(26*priorityX, 408*priorityY, 270*priorityX, 30);
    
    self.password.frame=self.SSIDList.frame;
    self.password.center=CGPointMake(self.SSIDList.center.x, self.SSIDList.center.y+38*priorityX);
    
    self.connectBtn.frame=CGRectMake(15*priorityX, 507*priorityY, 290*priorityX, 40*priorityX);
    [self.connectBtn setcornerRadius:40*priorityX/2];
}



- (IBAction)connect:(id)sender {
    
    if (self.SSIDList.text.length<1) {
        [MessageFormat hintWithMessage:@"请输入SSID" inview:self.view completion:nil];
        return;
    }
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"YSY" bundle:nil];
    AirboxConfigStep3ViewController *step3= [mainStoryboard instantiateViewControllerWithIdentifier:@"step3viewcontroller"];
    step3.ssid=self.SSIDList.text;
    step3.password=self.password.text;
    step3.boxID=[self getboxID];
    [self.navigationController pushViewController:step3 animated:YES];

}

- (NSString *)getboxID {
    NSString *boxID;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSDictionary *dict = (__bridge_transfer NSDictionary*)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSString *ssid=dict[@"SSID"];
        
        boxID=[ssid substringFromIndex:4];
        NSLog(@"当前盒子的ID是:%@",boxID);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return boxID;
}

-(void)stopkeyboard
{
    [self.password endEditing:YES];
}

#pragma mark UITextField的代理方法

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    CGFloat offset=self.view.frame.size.height-frame.size.height-frame.origin.y-50;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset <216.0)
        self.view.frame = CGRectMake(0.0f, offset-216.0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

@end
