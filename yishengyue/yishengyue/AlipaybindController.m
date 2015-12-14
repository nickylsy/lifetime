//
//  AlipaybindController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/27.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AlipaybindController.h"
#import "UIButton+Rectbutton.h"
#import "MessageFormat.h"
#import "AppDelegate.h"
#import "DES3Util.h"

@interface AlipaybindController ()<UITextFieldDelegate>
{
    AppDelegate *_myapp;
}
@end

@implementation AlipaybindController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myapp=[UIApplication sharedApplication].delegate;
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    [self.bindBtn setcornerRadius:5.0];
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

- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)bindAlipay:(id)sender {
    [self.nameTxt endEditing:YES];
    [self.accountTxt endEditing:YES];
    [self.passwordTxt endEditing:YES];
    
    if (self.nameTxt.text.length<1||self.accountTxt.text.length<1||self.passwordTxt.text.length<1) {
        [MessageFormat hintWithMessage:@"请填写所有信息" inview:self.view completion:nil];
        return;
    }
    
    [MessageFormat POST:AddAccount parameters:@{@"UserId":_myapp.user.ID,@"UserName":self.nameTxt.text,@"Account":self.accountTxt.text,@"PassWord":[DES3Util encrypt:self.passwordTxt.text]} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _myapp.alipayaccount=[[AlipayAccount alloc] init];
            _myapp.alipayaccount.account=self.accountTxt.text;
            _myapp.alipayaccount.username=self.accountTxt.text;
            _myapp.alipayaccount.alipayID=responseObject[@"data"];
            [MessageFormat hintWithMessage:@"绑定成功" inview:self.view completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }else{
            [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self view:self.view];
}

#pragma mark - UITextField的代理方法

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame =CGRectMake(textField.superview.frame.origin.x+textField.frame.origin.x, textField.superview.frame.origin.y+textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height);
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
