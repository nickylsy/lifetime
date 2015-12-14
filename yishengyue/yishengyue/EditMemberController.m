//
//  EditMemberController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/8.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "EditMemberController.h"
#import "AppDelegate.h"
#import "MessageFormat.h"
#import "FamilyMember.h"
#import "AFAppDotNetAPIClient.h"
#import "DatePickView.h"
#import "Mydefine.h"

@interface EditMemberController ()<UITextFieldDelegate,DatePickViewDelegate>
{
    DatePickView *_datepicker;
}
@end
@implementation EditMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setExtraCellLineHidden:self.tableView];
    
    UITapGestureRecognizer *stopedit=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopedit)];
    [self.view addGestureRecognizer:stopedit];
    
    
    UITapGestureRecognizer *chooseBirth=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBirthday)];
    [self.birthdayCell addGestureRecognizer:chooseBirth];
    
    
    
    CGFloat priorityY=self.view.frame.size.height/SCREENHEIGHT_5S;
    
    CGFloat width=self.view.frame.size.width;
    CGFloat height=priorityY>=1?250/SCREENHEIGHT_5S*self.view.frame.size.height:250;
    CGFloat x=0;
    CGFloat y=self.view.frame.size.height-height-20;
    
    _datepicker=[[UINib nibWithNibName:@"DatePickView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _datepicker.frame=CGRectMake(x, y, width, height);
    _datepicker.mydelegate=self;
    _datepicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*3/2);
    
    [self.view addSubview:_datepicker];
    
    [self setMemberInfo];
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

-(void)setMemberInfo
{
    self.nameTxt.text=self.member.name;
    self.birthdayLab.text=self.member.birthday;
    self.ageTxt.text=self.member.age;
    self.relationshipTxt.text=self.member.relationship;
    self.phoneTxt.text=self.member.phoneNum;
}

- (IBAction)completeEdit:(UIButton *)sender {
    [self stopedit];
    if (self.nameTxt.text.length<1||self.ageTxt.text.length<1||self.birthdayLab.text.length<1||self.relationshipTxt.text.length<1||self.phoneTxt.text.length<1) {
        [MessageFormat hintWithMessage:@"请补全所有信息" inview:self.view completion:nil];
        return;
    }
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:_member.ID forKey:@"FamilyId"];
    [dict setObject:self.nameTxt.text forKey:@"Name"];
    [dict setObject:self.birthdayLab.text forKey:@"Birthday"];
    [dict setObject:self.ageTxt.text forKey:@"Age"];
    [dict setObject:self.relationshipTxt.text forKey:@"Relationship"];
    [dict setObject:self.phoneTxt.text forKey:@"Tel"];
    
    [MessageFormat POST:EditFamily parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:^(){
            if (statuscode.intValue==0) {
                
                [_member updateWithDict:responseObject[@"data"]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self view:self.view];
}

-(void)updateTime:(NSString *)timestring
{
    self.birthdayLab.text=timestring;
}

-(void)stopedit
{
    [self hidepicker];
    [self.nameTxt endEditing:YES];
    [self.ageTxt endEditing:YES];
    [self.relationshipTxt endEditing:YES];
    [self.phoneTxt endEditing:YES];
}

-(void)chooseBirthday
{
    [self stopedit];
    [UIView animateWithDuration:0.5 animations:^{
        _datepicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-20-_datepicker.frame.size.height/2);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)hidepicker
{
    [UIView animateWithDuration:0.5 animations:^{
        _datepicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*3/2);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}


#pragma mark UITextField的代理方法


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidepicker];
    CGFloat textfieldbottom=textField.tag*40+64;//textField底部相在self.view中的位置
    CGFloat offset=self.view.frame.size.height-textfieldbottom-50;
    
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
