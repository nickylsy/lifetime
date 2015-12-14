//
//  AddCircleMassageController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/9/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AddCircleMessageController.h"
#import "Mydefine.h"
#import "AddInterestView.h"
#import "AddWorkView.h"
#import "DatePickView.h"
#import "MyPickView.h"
#import "NSDictionary+GetObjectBykey.h"
#import "MessageFormat.h"
#import "AppDelegate.h"

@interface AddCircleMessageController ()<UITextFieldDelegate,UITextViewDelegate,DatePickViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MyPickViewDelegate>
{
    UIButton *_interestBtn;
    UIButton *_workBtn;
    UIButton *_businessBtn;
    
    AddInterestView *_addinterestView;
    AddWorkView *_addworkView;
    AddWorkView *_addbusinessView;
    
    DatePickView *_datePicker;
    MyPickView *_typePicker;
    
    NSString *_temType;
}
@end

@implementation AddCircleMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    UITapGestureRecognizer *endEditTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endInput)];
    self.view.userInteractionEnabled=YES;
    [self.view addGestureRecognizer:endEditTap];
    
    _temType=[[self.typeList objectAtIndex:0] getObjectByKey:@"InterestName"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self createTabbar];
    [self createAddView];
    [self createPickerView];
}

-(void)createPickerView
{
    CGFloat screenwidth=[UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight=[UIScreen mainScreen].bounds.size.height;
    
    CGFloat width=self.view.frame.size.width;
    CGFloat height=250;
    CGFloat x=0;
    CGFloat y=self.view.frame.size.height-height-20;
    
    _datePicker=[[UINib nibWithNibName:@"DatePickView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _datePicker.frame=CGRectMake(x, y, width, height);
    _datePicker.mydelegate=self;
    _datePicker.center=CGPointMake(screenwidth/2, screenheight*3/2);
    _datePicker.picker.datePickerMode=UIDatePickerModeDateAndTime;
    _datePicker.timeFormatString=@"yyyy-MM-dd hh:mm";
    
    [self.view addSubview:_datePicker];
    
    _typePicker=[[UINib nibWithNibName:@"MyPickView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _typePicker.frame=CGRectMake(x, y, width, height);
    _typePicker.mydelegate=self;
    _typePicker.center=CGPointMake(screenwidth/2, screenheight*3/2);
    _typePicker.picker.dataSource=self;
    _typePicker.picker.delegate=self;

    [self.view addSubview:_typePicker];
    
    
}
-(void)createTabbar
{
    CGFloat itemWidth=[UIScreen mainScreen].bounds.size.width/3;
    _interestBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 44)];
    _interestBtn.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    _interestBtn.selected=YES;
    _interestBtn.tag=1;
    [_interestBtn setTitle:@"兴趣圈" forState:UIControlStateNormal];
    [_interestBtn setTitleColor:UIColorFromRGB(FONT_COLOR_VALUE) forState:UIControlStateNormal];
    [_interestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_interestBtn addTarget:self action:@selector(changeItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:_interestBtn];
    
    _workBtn=[[UIButton alloc] initWithFrame:CGRectMake(itemWidth, 0, itemWidth, 44)];
    _workBtn.selected=NO;
    _workBtn.tag=2;
    [_workBtn setTitle:@"工作圈" forState:UIControlStateNormal];
    [_workBtn setTitleColor:UIColorFromRGB(FONT_COLOR_VALUE) forState:UIControlStateNormal];
    [_workBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_workBtn addTarget:self action:@selector(changeItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:_workBtn];
    
    _businessBtn=[[UIButton alloc] initWithFrame:CGRectMake(itemWidth*2, 0, itemWidth, 44)];
    _businessBtn.selected=NO;
    _businessBtn.tag=3;
    [_businessBtn setTitle:@"商务圈" forState:UIControlStateNormal];
    [_businessBtn setTitleColor:UIColorFromRGB(FONT_COLOR_VALUE) forState:UIControlStateNormal];
    [_businessBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_businessBtn addTarget:self action:@selector(changeItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:_businessBtn];
}


-(void)createAddView
{
    _addworkView=[[UINib nibWithNibName:@"AddInterestView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
    _addworkView.frame=CGRectMake(0,108, [UIScreen mainScreen].bounds.size.width, 392);
    _addworkView.hidden=YES;
    _addworkView.themeTxt.delegate=self;
    _addworkView.descTxt.delegate=self;
    _addworkView.releaseBtn.tag=2;
    [_addworkView.releaseBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addworkView];
    
    _addbusinessView=[[UINib nibWithNibName:@"AddInterestView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
    _addbusinessView.frame=CGRectMake(0,108, [UIScreen mainScreen].bounds.size.width, 392);
    _addbusinessView.hidden=YES;
    _addbusinessView.themeTxt.delegate=self;
    _addbusinessView.descTxt.delegate=self;
    _addbusinessView.releaseBtn.tag=3;
    [_addbusinessView.releaseBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addbusinessView];
    
    _addinterestView=[[UINib nibWithNibName:@"AddInterestView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _addinterestView.frame=CGRectMake(0,108, [UIScreen mainScreen].bounds.size.width, 392);
    
    _addinterestView.themeTxt.delegate=self;
    _addinterestView.descTxt.delegate=self;
    _addinterestView.locationTxt.delegate=self;
    _addinterestView.numberTxt.delegate=self;
    _addinterestView.releaseBtn.tag=1;
    [_addinterestView.releaseBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *chooseTimeTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTime)];
    _addinterestView.timeView.userInteractionEnabled=YES;
    [_addinterestView.timeView addGestureRecognizer:chooseTimeTap];
    
    UITapGestureRecognizer *chooseTypeTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseType)];
    _addinterestView.typeView.userInteractionEnabled=YES;
    [_addinterestView.typeView addGestureRecognizer:chooseTypeTap];
    [self.view addSubview:_addinterestView];
    
    self.view.backgroundColor=_addinterestView.backgroundColor;
}


#pragma mark -
#pragma mark -------------------------------

-(void)stopedit
{
    [_addinterestView.themeTxt resignFirstResponder];
    [_addinterestView.descTxt resignFirstResponder];
    [_addinterestView.locationTxt resignFirstResponder];
    [_addinterestView.numberTxt resignFirstResponder];
    
    [_addworkView.themeTxt resignFirstResponder];
    [_addworkView.descTxt resignFirstResponder];
    
    [_addbusinessView.themeTxt resignFirstResponder];
    [_addbusinessView.descTxt resignFirstResponder];
}

#pragma mark -------------------------------

#pragma mark - MyPickViewDelegate

-(void)updateString
{
    _addinterestView.typeLab.text=_temType;
}

#pragma mark - DatePickViewDelegate
-(void)updateTime:(NSString *)timestring
{
    _addinterestView.timeLab.text=timestring;
}

-(void)hidepicker
{
    [UIView animateWithDuration:0.5 animations:^{
        _datePicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*3/2);
        _typePicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*3/2);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 响应方法

-(void)endInput
{
    [self stopedit];
    [self hidepicker];
}

-(void)chooseTime
{
    [self stopedit];
    [self.view bringSubviewToFront:_datePicker];
    [UIView animateWithDuration:0.5 animations:^{
        _datePicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-_datePicker.frame.size.height/2);
    } completion:^(BOOL finished) {
        
    }];
    
}


-(void)chooseType
{
    [self stopedit];
    [self.view bringSubviewToFront:_typePicker];
    [UIView animateWithDuration:0.5 animations:^{
        _typePicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-_typePicker.frame.size.height/2);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)changeItem:(UIButton *)sender
{
    [self stopedit];
    [self hidepicker];
    sender.selected=YES;
    sender.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    switch (sender.tag) {
        case 1:
        {
            _addbusinessView.hidden=NO;
            _addworkView.hidden=YES;
            _addbusinessView.hidden=YES;
            [self.view bringSubviewToFront:_addinterestView];
            
            _workBtn.selected=NO;
            _workBtn.backgroundColor=[UIColor whiteColor];
            _businessBtn.selected=NO;
            _businessBtn.backgroundColor=[UIColor whiteColor];
            break;
        }
        case 2:
        {
            _addbusinessView.hidden=YES;
            _addworkView.hidden=NO;
            _addbusinessView.hidden=YES;
            [self.view bringSubviewToFront:_addworkView];
            
            _interestBtn.selected=NO;
            _interestBtn.backgroundColor=[UIColor whiteColor];
            _businessBtn.selected=NO;
            _businessBtn.backgroundColor=[UIColor whiteColor];
            break;
        }
        case 3:
        {
            _addbusinessView.hidden=YES;
            _addworkView.hidden=YES;
            _addbusinessView.hidden=NO;
            [self.view bringSubviewToFront:_addbusinessView];
            
            _workBtn.selected=NO;
            _workBtn.backgroundColor=[UIColor whiteColor];
            _interestBtn.selected=NO;
            _interestBtn.backgroundColor=[UIColor whiteColor];
            break;
        }
        default:
            break;
    }
}

-(void)commit:(UIButton *)sender
{
    [self stopedit];
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    NSMutableDictionary *paraDict=[NSMutableDictionary dictionaryWithDictionary:@{@"UserId":myapp.user.ID}];
    switch (sender.tag) {
        case 1:
        {
            if (_addinterestView.themeTxt.text.length<1) {
                [MessageFormat hintWithMessage:@"请输入主题" inview:self.view completion:nil];
                return;
            }
            if ([_addinterestView.timeLab.text isEqualToString:@"请选择时间"]) {
                [MessageFormat hintWithMessage:@"请选择时间" inview:self.view completion:nil];
                return;
            }
            if (_addinterestView.locationTxt.text.length<1) {
                [MessageFormat hintWithMessage:@"请输入地点" inview:self.view completion:nil];
                return;
            }
            if (_addinterestView.numberTxt.text.length<1) {
                [MessageFormat hintWithMessage:@"请输入人数" inview:self.view completion:nil];
                return;
            }
            if ([_addinterestView.typeLab.text isEqualToString:@"请选择类型"]) {
                [MessageFormat hintWithMessage:@"请选择类型" inview:self.view completion:nil];
                return;
            }
            if (_addinterestView.descTxt.text.length<1) {
                [MessageFormat hintWithMessage:@"请输入简介" inview:self.view completion:nil];
                return;
            }
            
            [paraDict setObject:_addinterestView.themeTxt.text forKey:@"Title"];
            for (NSDictionary *dict in self.typeList) {
                NSString *typestring=[dict getObjectByKey:@"InterestName"];
                if ([typestring isEqualToString:_addinterestView.typeLab.text]) {
                    [paraDict setObject:[dict getObjectByKey:@"id"] forKey:@"IntId"];
                }
            }
            [paraDict setObject:@"1" forKey:@"Type"];
            [paraDict setObject:_addinterestView.descTxt.text forKey:@"Introduction"];
            [paraDict setObject:_addinterestView.locationTxt.text forKey:@"Address"];
            [paraDict setObject:_addinterestView.numberTxt.text forKey:@"Num"];
            [paraDict setObject:_addinterestView.timeLab.text forKey:@"ReleaseTime"];
            break;
        }
        case 2:
        {
            if (_addworkView.themeTxt.text.length<1) {
                [MessageFormat hintWithMessage:@"请输入主题" inview:self.view completion:nil];
                return;
            }
            if (_addworkView.descTxt.text.length<1) {
                [MessageFormat hintWithMessage:@"请输入简介" inview:self.view completion:nil];
                return;
            }
            
            [paraDict setObject:@"2" forKey:@"Type"];
            [paraDict setObject:_addworkView.descTxt.text forKey:@"Introduction"];
            [paraDict setObject:_addworkView.themeTxt.text forKey:@"Title"];

            break;
        }
        case 3:
        {
            if (_addbusinessView.themeTxt.text.length<1) {
                [MessageFormat hintWithMessage:@"请输入主题" inview:self.view completion:nil];
                return;
            }
            if (_addbusinessView.descTxt.text.length<1) {
                [MessageFormat hintWithMessage:@"请输入简介" inview:self.view completion:nil];
                return;
            }
            
            [paraDict setObject:@"3" forKey:@"Type"];
            [paraDict setObject:_addbusinessView.descTxt.text forKey:@"Introduction"];
            [paraDict setObject:_addbusinessView.themeTxt.text forKey:@"Title"];
            break;
        }
        default:
            break;
    }
    
    [MessageFormat POST:peradd parameters:paraDict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statusCode=responseObject[@"code"];
        if (statusCode.intValue==0) {
            [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:^{
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } incontroller:self view:self.view];
}


- (IBAction)goback:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextField的代理方法


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidepicker];
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
    //    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  
}

#pragma mark -
#pragma mark - UITextView的代理方法


//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self hidepicker];
    CGRect frame =CGRectMake(textView.superview.frame.origin.x+textView.frame.origin.x, textView.superview.frame.origin.y+textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height);
    CGFloat offset=self.view.frame.size.height-frame.size.height-frame.origin.y-50;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset <216.0)
        self.view.frame = CGRectMake(0.0f, offset-216.0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UIPickerView数据源方法

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.typeList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.typeList objectAtIndex:row] getObjectByKey:@"InterestName"];
}
#pragma mark - UIPickerView代理方法

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return pickerView.frame.size.height/self.typeList.count;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _temType=[[self.typeList objectAtIndex:row] getObjectByKey:@"InterestName"];
}
@end
