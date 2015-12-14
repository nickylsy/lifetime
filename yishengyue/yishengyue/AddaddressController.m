//
//  AddaddressController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/1.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AddaddressController.h"
#import "GCPlaceholderTextView.h"
#import "Mydefine.h"
#import "AreaPickerView.h"
#import "HZAreaPickerView.h"
#import "MessageFormat.h"
#import "AppDelegate.h"
#import "AddressInfo.h"
#import <NotificationCenter/NotificationCenter.h>

@implementation AddressDetailInfo

@end

@interface AddaddressController ()<UITextFieldDelegate,UITextViewDelegate,AreaPickerViewDelegate>
{
    AreaPickerView *_areapicker;
    AppDelegate *_myapp;
}
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *xiangxiTxtview;

@end

@implementation AddaddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.xiangxiTxtview.placeholder=@"详细地址";
    [self setExtraCellLineHidden:self.tableView];
    self.tableView.backgroundColor=UIColorFromRGB(0xf6f6f6);
    self.addressdetail=[[AddressDetailInfo alloc] init];
    
    _myapp=[UIApplication sharedApplication].delegate;
    CGFloat priorityY=self.view.frame.size.height/SCREENHEIGHT_5S;
    
    CGFloat width=self.view.frame.size.width;
    CGFloat height=priorityY>=1?250/SCREENHEIGHT_5S*self.view.frame.size.height:250;
    CGFloat x=0;
    CGFloat y=self.view.frame.size.height-height-20;
    
    _areapicker=[[UINib nibWithNibName:@"AreaPickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _areapicker.frame=CGRectMake(x, y, width, height);
    _areapicker.mydelegate=self;
    _areapicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*3/2);
    
    
    
    [self.view addSubview:_areapicker];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosearea)];
    [self.areacell addGestureRecognizer:tap];
    
    if (self.type==AddressManageTypeEdit) {
        self.navigationItem.title=@"编辑收货地址";
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.type==AddressManageTypeEdit) {
        [MessageFormat POST:SingleAddress parameters:@{@"AddressId":self.addressID} success:^(NSURLSessionDataTask *task, id responseObject) {
            NSNumber *statuscode=responseObject[@"code"];
            if (statuscode.intValue==0) {
                NSDictionary *dict=responseObject[@"data"];
                
                self.addressdetail.ID=[dict[@"AddressId"] isEqual:[NSNull null]]?@"":dict[@"AddressId"];
                self.addressdetail.name=[dict[@"Name"] isEqual:[NSNull null]]?@"":dict[@"Name"];
                self.addressdetail.postalcode=[dict[@"PostalCode"] isEqual:[NSNull null]]?@"":dict[@"PostalCode"];
                self.addressdetail.phoneNum=[dict[@"Tel"] isEqual:[NSNull null]]?@"":dict[@"Tel"];
                self.addressdetail.province=[dict[@"Province"] isEqual:[NSNull null]]?@"":dict[@"Province"];
                self.addressdetail.city=[dict[@"City"] isEqual:[NSNull null]]?@"":dict[@"City"];
                self.addressdetail.area=[dict[@"Area"] isEqual:[NSNull null]]?@"":dict[@"Area"];
                self.addressdetail.detailaddress=[dict[@"Address"] isEqual:[NSNull null]]?@"":dict[@"Address"];
                
                NSString *area=[NSString stringWithFormat:@"%@%@%@",self.addressdetail.province,self.addressdetail.city,self.addressdetail.area];
                self.nameTxt.text=self.addressdetail.name;
                self.youbianTxt.text=self.addressdetail.postalcode;
                self.phoneNumTxt.text=self.addressdetail.phoneNum;
                self.areacell.detailTextLabel.text=area.length<1?@"               ":area;
                self.xiangxiTxtview.text=self.addressdetail.detailaddress;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.debugDescription);
        } incontroller:self view:self.view];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)choosearea
{
    [self stopedit];
    [UIView animateWithDuration:0.5 animations:^{
        _areapicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-20-_areapicker.frame.size.height/2);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)stopedit
{
    [self.nameTxt endEditing:YES];
    [self.youbianTxt endEditing:YES];
    [self.phoneNumTxt endEditing:YES];
    [self.xiangxiTxtview endEditing:YES];
    [self.xiangxiTxtview resignFirstResponder];
}

- (IBAction)addAddress:(UIButton *)sender {
    if (self.nameTxt.text.length<1 || self.phoneNumTxt.text.length<1 || self.youbianTxt.text.length<1 || self.areacell.detailTextLabel.text.length<1 || self.xiangxiTxtview.text.length<1 || self.addressdetail.province==nil || self.addressdetail.city==nil || self.addressdetail.area==nil) {
        [MessageFormat hintWithMessage:@"请补全信息" inview:self.view completion:nil];
        return;
    }
    
    if (self.phoneNumTxt.text.length!=11) {
        [MessageFormat hintWithMessage:@"电话号码错误" inview:self.view completion:nil];
        return;
    }
    if (self.youbianTxt.text.length!=6) {
        [MessageFormat hintWithMessage:@"邮编错误" inview:self.view completion:nil];
        return;
    }
    
    if (self.type==AddressManageTypeEdit) {
        NSDictionary *dict=@{@"AddressId":self.addressID,@"Name":self.nameTxt.text,@"Tel":self.phoneNumTxt.text,@"PostalCode":self.youbianTxt.text,@"Address":self.xiangxiTxtview.text,@"Province":self.addressdetail.province,@"City":self.addressdetail.city,@"Area":self.addressdetail.area};
        
        [MessageFormat POST:EditAddress parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            NSNumber *statuscode=responseObject[@"code"];
            if (statuscode.intValue==0) {
                for (AddressInfo *add in _myapp.addresses) {
                    if ([add.ID isEqualToString:self.addressID]) {
                        add.name=self.nameTxt.text;
                        add.phoneNum=self.phoneNumTxt.text;
                        add.postalcode=self.youbianTxt.text;
                        add.address=[NSString stringWithFormat:@"%@%@",self.areacell.detailTextLabel.text,self.xiangxiTxtview.text];
                    }
                }
                [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ADDRESSLIST object:nil];
                }];
            }
        } failure:nil incontroller:self view:self.view];
    }else{
        NSDictionary *dict=@{@"UserId":_myapp.user.ID,@"Name":self.nameTxt.text,@"Tel":self.phoneNumTxt.text,@"PostalCode":self.youbianTxt.text,@"Address":self.xiangxiTxtview.text,@"Province":self.addressdetail.province,@"City":self.addressdetail.city,@"Area":self.addressdetail.area};
        
        [MessageFormat POST:SaveAddress parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            NSNumber *statuscode=responseObject[@"code"];
            if (statuscode.intValue==0) {
                NSMutableDictionary *mutabldict=[NSMutableDictionary dictionaryWithDictionary:dict];
                [mutabldict setObject:responseObject[@"data"][@"AddressId"] forKey:@"AddressId"];
                AddressInfo *add=[AddressInfo addressinfoWithDict:mutabldict];
                add.address=[NSString stringWithFormat:@"%@%@%@%@",self.addressdetail.province,self.addressdetail.city,self.addressdetail.area,add.address];
                if (_myapp.addresses) {
                    [_myapp.addresses addObject:add];
                }else{
                    _myapp.addresses=[NSMutableArray arrayWithObject:add];
                }
                
                [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ADDRESSLIST object:nil];
                }];
            }
        } failure:nil incontroller:self view:self.view];
    }
    
}

#pragma mark - AreaPickerView代理方法
-(void)hidepicker
{
    [UIView animateWithDuration:0.5 animations:^{
        _areapicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*3/2);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)updateAreaWithProvice:(NSString *)province City:(NSString *)city Area:(NSString *)area
{
    self.addressdetail.province=province;
    self.addressdetail.city=city;
    self.addressdetail.area=area;
    
    self.areacell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@",province,city,area];
}
#pragma mark - 隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}

#pragma mark - 让分割线从最左边到最右边
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - UITextField的代理方法

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

#pragma mark - UITextView的代理方法

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self hidepicker];
    CGFloat textfieldbottom=textView.tag*40+64;//textField底部相在self.view中的位置
    CGFloat offset=self.view.frame.size.height-textfieldbottom-50;
    
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

@end
