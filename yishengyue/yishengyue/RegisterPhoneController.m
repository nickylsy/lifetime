//
//  RegisterPhoneController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/30.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "RegisterPhoneController.h"
#import "Mydefine.h"
#import "MessageFormat.h"
#import "RegisterPasswordController.h"
#import "AFAppDotNetAPIClient.h"
#import "RuleController.h"

#define YANZHENGNMA_JIANGE 90

@interface RegisterPhoneController ()<UITextFieldDelegate>
{
    NSTimer *_timer;
    int _shengyushijian;
    NSString *_tempPhoneNum;
}
@end

@implementation RegisterPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=UIColorFromRGB(0xf7f7f7);
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    self.phoneTxt.delegate=self;
    self.yanzhengmaTxt.delegate=self;
    
    self.phonehengxianImg.backgroundColor=UIColorFromRGB(0xd2d2d2);
    self.yanzhenghengxianImg.backgroundColor=self.phonehengxianImg.backgroundColor;
    
    self.huoquBtn.layer.masksToBounds=YES;
    self.huoquBtn.layer.borderWidth=1.0;
    self.huoquBtn.tintColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    [self.huoquBtn setTitleColor:self.huoquBtn.tintColor forState:UIControlStateNormal];
    self.huoquBtn.layer.borderColor=self.huoquBtn.tintColor.CGColor;
    self.huoquBtn.layer.cornerRadius=self.huoquBtn.frame.size.height/2;
    
    self.nextBtn.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.nextBtn.layer.masksToBounds=YES;
    self.nextBtn.layer.cornerRadius=5.0;
    self.nextBtn.layer.borderColor=UIColorFromRGB(MAIN_COLOR_VALUE).CGColor;
    self.nextBtn.layer.borderWidth=1.0;
    
    self.xieyiView.backgroundColor=self.view.backgroundColor;
    self.xieyitouLab.backgroundColor=self.view.backgroundColor;
    self.xieyiweiLab.backgroundColor=self.view.backgroundColor;
    self.xieyiweiLab.textColor=self.huoquBtn.tintColor;
    
    UITapGestureRecognizer *singletap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xieyi)];
    self.xieyiweiLab.userInteractionEnabled=YES;
    [self.xieyiweiLab addGestureRecognizer:singletap];
    
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
    [self.phoneTxt endEditing:YES];
    [self.yanzhengmaTxt endEditing:YES];
}

- (IBAction)goback:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)next:(UIButton *)sender {
    
    
    if (self.phoneTxt.text.length<1) {
        [MessageFormat hintWithMessage:@"请输入电话号码" inview:self.view completion:^{
            [self.phoneTxt becomeFirstResponder];
        }];
        return;
    }
    if (self.phoneTxt.text.length<11) {
        [MessageFormat hintWithMessage:@"电话号码不正确" inview:self.view completion:^{
            [self.phoneTxt becomeFirstResponder];
        }];
        return;
    }
    if (self.yanzhengmaTxt.text.length<1) {
        [MessageFormat hintWithMessage:@"请输入验证码" inview:self.view completion:^{
            [self.yanzhengmaTxt becomeFirstResponder];
        }];
        return;
    }
    
    
    [[AFAppDotNetAPIClient sharedClient] POST:ValidateMessage.URLEncodedString parameters:@{@"Tel":_tempPhoneNum,@"Message":self.yanzhengmaTxt.text} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            UIStoryboard *autolayoutstoryboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
            RegisterPasswordController *passwordcontroller=[autolayoutstoryboard instantiateViewControllerWithIdentifier:@"registerpasswordcontroller"];
            passwordcontroller.phonenumber=self.phoneTxt.text;
            [self.navigationController pushViewController:passwordcontroller animated:YES];
        }else
        {
            [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    }];
    
    
}

- (IBAction)getyanzheng:(UIButton *)sender {
    
    if (self.phoneTxt.text.length<1) {
        [MessageFormat hintWithMessage:@"请输入电话号码" inview:self.view completion:^{
            [self.phoneTxt becomeFirstResponder];
        }];
        return;
    }
    if (self.phoneTxt.text.length<11) {
        [MessageFormat hintWithMessage:@"请输入正确的电话号码" inview:self.view completion:^{
            [self.phoneTxt becomeFirstResponder];
        }];
        return;
    }
    
    _tempPhoneNum=_phoneTxt.text;
    [MessageFormat POST:SendMessage.URLEncodedString parameters:@{@"Tel":_tempPhoneNum} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
        
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            sender.enabled=NO;
            _shengyushijian=YANZHENGNMA_JIANGE;
            sender.layer.borderColor=[UIColor lightGrayColor].CGColor;
            sender.titleLabel.text=[NSString stringWithFormat:@"请稍等(%i)",_shengyushijian];
            [sender setTitle:[NSString stringWithFormat:@"请稍等(%i)",_shengyushijian] forState:UIControlStateDisabled];
            _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(yanzhengmajishi) userInfo:nil repeats:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } incontroller:self view:self.view];
}

-(void)xieyi
{
    UIStoryboard *autolayoutstoryboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
    RuleController *xieyicontroller=[autolayoutstoryboard instantiateViewControllerWithIdentifier:@"xieyicontroller"];
    
    [self.navigationController pushViewController:xieyicontroller animated:YES];
}

-(void)yanzhengmajishi
{
    _shengyushijian--;
    if (_shengyushijian==0) {
        [_timer invalidate];
        _huoquBtn.titleLabel.text=@"获取验证码";
        [_huoquBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _huoquBtn.layer.borderColor=UIColorFromRGB(MAIN_COLOR_VALUE).CGColor;
        _huoquBtn.enabled=YES;
    }else{
        _huoquBtn.titleLabel.text=[NSString stringWithFormat:@"请稍等(%i)",_shengyushijian];
        [_huoquBtn setTitle:[NSString stringWithFormat:@"请稍等(%i)",_shengyushijian] forState:UIControlStateDisabled];
    }
}
#pragma mark -
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
