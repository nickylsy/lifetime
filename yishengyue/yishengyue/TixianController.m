//
//  TixianController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "TixianController.h"
#import "MessageFormat.h"
#import "AppDelegate.h"
#import "UIButton+Rectbutton.h"

@interface TixianController ()<UITextFieldDelegate>
{
    AppDelegate *_myapp;
}
@end

@implementation TixianController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tixianNumLab.delegate=self;
    [self.okBtn setcornerRadius:5.0];
    _myapp=[UIApplication sharedApplication].delegate;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MessageFormat POST:DrawData parameters:@{@"UserId":_myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSDictionary *dict=responseObject[@"data"];
            self.totalMoneyLab.text=[NSString stringWithFormat:@"%@元",dict[@"Money"]];
            self.alipayAccountLab.text=dict[@"Data"][@"Account"];
            self.alipayUsernameLab.text=dict[@"Data"][@"UserName"];
        }else{
            [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self view:self.view];
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



- (IBAction)tixian:(id)sender {
    [self.tixianNumLab endEditing:YES];
    
    if (self.tixianNumLab.text.length<1) {
        [MessageFormat hintWithMessage:@"请输入转出金额" inview:self.view completion:nil];
        return;
    }
    
    if (self.tixianNumLab.text.doubleValue<=0.0) {
        [MessageFormat hintWithMessage:@"金额不能为0" inview:self.view completion:nil];
        return;
    }
    
    [MessageFormat POST:ReferDraw parameters:@{@"UserId":_myapp.user.ID,@"AlipayId":_myapp.alipayaccount.alipayID,@"Money":self.tixianNumLab.text} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            [MessageFormat hintWithMessage:@"申请成功" inview:self.view completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self view:self.view];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = 2;//小数点后需要限制的个数
    for (int i = (int)futureString.length-1; i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        
        flag++;
        
    }
    return YES;
    
}
@end
