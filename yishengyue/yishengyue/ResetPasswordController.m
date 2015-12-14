//
//  ResetPasswordController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ResetPasswordController.h"
#import "Mydefine.h"
#import "MessageFormat.h"
#import "DES3Util.h"

@interface ResetPasswordController ()<UITextFieldDelegate>

@end

@implementation ResetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=UIColorFromRGB(0xf7f7f7);
    self.setpasswordTxt.delegate=self;
    self.repeatpasswordTxt.delegate=self;
   
    
    self.psdIMg.backgroundColor=UIColorFromRGB(0xd2d2d2);
    self.repeatImg.backgroundColor=self.psdIMg.backgroundColor;

    
    self.seePSDBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    self.OKBtn.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.OKBtn.layer.masksToBounds=YES;
    self.OKBtn.layer.cornerRadius=5.0;
    
    UITapGestureRecognizer *stopedittap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopkeyboard)];
    self.view.userInteractionEnabled=YES;
    [self.view addGestureRecognizer:stopedittap];
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

-(void)stopkeyboard
{
    [self.setpasswordTxt endEditing:YES];
    [self.repeatpasswordTxt endEditing:YES];
}

- (IBAction)changePSDMode:(UIButton *)sender {
    self.setpasswordTxt.secureTextEntry=sender.selected;
    self.repeatpasswordTxt.secureTextEntry=sender.selected;
    sender.selected=!sender.selected;
}

- (IBAction)resetpassword:(UIButton *)sender {
    if (self.setpasswordTxt.text.length<1) {
        [MessageFormat hintWithMessage:@"请输入密码" inview:self.view completion:^{
            [self.setpasswordTxt becomeFirstResponder];
        }];
        return;
    }
    if (self.repeatpasswordTxt.text.length<1) {
        [MessageFormat hintWithMessage:@"请重复密码" inview:self.view completion:^{
            [self.repeatpasswordTxt becomeFirstResponder];
        }];
        return;
    }
    if (![self.repeatpasswordTxt.text isEqualToString:self.setpasswordTxt.text]) {
        [MessageFormat hintWithMessage:@"两次输入的密码不一致" inview:self.view completion:nil];
        return;
    }
    
    [MessageFormat POST:EditRegister parameters:@{@"Tel":self.phonenumber,@"PassWord":[DES3Util encrypt:self.setpasswordTxt.text]} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            [MessageFormat hintWithMessage:(NSString *)responseObject[@"message"] inview:self.view completion:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self view:self.view];
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
