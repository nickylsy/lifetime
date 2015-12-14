//
//  GerenEditController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/3.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "GerenEditController.h"
#import "AppDelegate.h"
#import "Mydefine.h"
#import "GerenEditCell.h"
#import "AFAppDotNetAPIClient.h"
#import "MessageFormat.h"
#import "NSString+URLEncoding.h"
#import "UIWindow+YUBottomPoper.h"
#import "UIImageView+AFNetworking.h"
#import "UIViewController+ActivityHUD.h"

#define EDITCELL_REUSEIDENTIFIER @"editcell"

#define PARAMETERS_ARRAY @[@"UserName",@"Sex",@"RoomNum",@"IdCard",@"Hobby",@"LogoUrl",@"UserId",]

@implementation GerenEditController
{
    NSArray *_datas;
    NSData *_filedata;
    NSMutableArray *_gerenxinxi;
    NSString *_templogourlstring;
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self relayoutsubviews];
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _datas=@[@"昵称",@"性别",@"房间号",@"身份证",@"兴趣爱好"];
    self.tableview.backgroundColor=self.view.backgroundColor;
    self.tableview.separatorColor=self.tableview.backgroundColor;
    self.tableview.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15);
    
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    _gerenxinxi=[NSMutableArray array];
    [_gerenxinxi addObject:myapp.user.username];
    [_gerenxinxi addObject:myapp.user.sex];
    [_gerenxinxi addObject:myapp.user.roomNum];
    [_gerenxinxi addObject:myapp.user.idCard];
    [_gerenxinxi addObject:myapp.user.hobby];
    
    UITapGestureRecognizer *stopedittap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopedit)];
    [self.view addGestureRecognizer:stopedittap];
    
    _templogourlstring=myapp.user.logoURLString;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
    self.touxiangImg.userInteractionEnabled=YES;
    [self.touxiangImg addGestureRecognizer:tap];
    [self.touxiangImg setImageWithURL:[NSURL URLWithString:_templogourlstring]];
}

-(void)chooseImage
{

    NSArray * titles=[NSArray arrayWithObjects:@"马上拍照",@"从相册选择", nil];
    NSArray * styles=[NSArray arrayWithObjects:YUDefaultStyle,YUDefaultStyle, nil];

    [self.view.window showPopWithButtonTitles:titles styles:styles whenButtonTouchUpInSideCallBack:^(int a) {
        switch (a) {
            case 0:
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                imagePicker.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                [self presentViewController:imagePicker animated:YES completion:nil];
             
                break;
            }
            case 1:
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                imagePicker.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                [self presentViewController:imagePicker animated:YES completion:nil];
                break;
            }
                
            default:
                break;
        }
    }];
}
-(void)relayoutsubviews
{
    //根据屏幕大小来确定各个子控件的大小和位置
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat priorityX=screenwidth/SCREENWIDTH_5S;

    self.touxiangView.frame=CGRectMake(0, 0, screenwidth,146*priorityX);
    
    self.touxiangLab.frame=CGRectMake(0, 0, 101*priorityX, 20*priorityX);
    self.touxiangLab.center=CGPointMake(26+self.touxiangLab.frame.size.width/2,20+self.touxiangLab.frame.size.height/2);
    
    [self.touxiangView bringSubviewToFront:self.touxiangLab];
    
    self.touxiangImg.frame=CGRectMake(0, 0, 90*priorityX, 90*priorityX);
    self.touxiangImg.center=CGPointMake(self.touxiangLab.center.x, self.touxiangLab.center.y+self.touxiangImg.frame.size.height/2+10);
    self.touxiangImg.layer.masksToBounds=YES;
    self.touxiangImg.layer.cornerRadius=self.touxiangImg.frame.size.width/2;
    
    self.tableview.frame=CGRectMake(0, self.touxiangView.frame.size.height+8.0, screenwidth, 200*priorityX);
    
    self.scrollview.contentSize=CGSizeMake(screenwidth, self.tableview.frame.origin.y+self.tableview.frame.size.height);
}

-(void)stopedit
{
    for (NSIndexPath *indexpath in self.tableview.indexPathsForVisibleRows) {
        GerenEditCell *cell=(GerenEditCell *)[self.tableview cellForRowAtIndexPath:indexpath];
        [cell.valueTxt endEditing:YES];
    }
}

- (IBAction)goback:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)complete:(UIButton *)sender {
    [self stopedit];
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [dict setObject:myapp.user.ID forKey:PARAMETERS_ARRAY[6]];
    [dict setObject:_templogourlstring forKey:PARAMETERS_ARRAY[5]];
    for (NSIndexPath *indexpath in self.tableview.indexPathsForVisibleRows) {
        GerenEditCell *cell=(GerenEditCell *)[self.tableview cellForRowAtIndexPath:indexpath];
        if (indexpath.row==1) {
            [dict setObject:[NSString stringWithFormat:@"%li",cell.sexSmt.selectedSegmentIndex+1] forKey:PARAMETERS_ARRAY[indexpath.row]];
        } else {
            if (indexpath.row==3 && (cell.valueTxt.text.length!=16  && cell.valueTxt.text.length!=18)) {
                [MessageFormat hintWithMessage:@"身份证号码不正确" inview:self.view completion:nil];
                return;
            }
            [dict setObject:cell.valueTxt.text forKey:PARAMETERS_ARRAY[indexpath.row]];
        }
        
    }
    
    [MessageFormat POST:CompleteUser parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            AppDelegate *myapp=[UIApplication sharedApplication].delegate;
            [myapp.user refreshWithDict:dict];
        }
        [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:^(){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self view:self.view];
}

#pragma mark -
#pragma mark UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage  *img = [info objectForKey:UIImagePickerControllerEditedImage];
    _filedata = UIImageJPEGRepresentation(img,0.5);
    
    [self pleaseWaitInView:self.view];
    [[AFAppDotNetAPIClient sharedClient] POST:SavePic.URLEncodedString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:_filedata name:@"file" fileName:@"logo.jpeg" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self endWaiting];
        NSNumber *status=responseObject[@"code"];
        if (status.intValue==0) {
            NSDictionary *dict=responseObject[@"data"];
            _templogourlstring=dict[@"LogoUrl"];
            [self.touxiangImg setImageWithURL:[NSURL URLWithString:_templogourlstring]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endWaiting];
        NSLog(@"%@",error.debugDescription);
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark UITableview数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return tableView.frame.size.height/5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GerenEditCell *cell=[tableView dequeueReusableCellWithIdentifier:EDITCELL_REUSEIDENTIFIER];
    if (cell==nil) {
        cell=[[UINib nibWithNibName:@"GerenEditCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    }
    if (indexPath.row==1) {
        cell.valueTxt.hidden=YES;
        cell.sexSmt.hidden=NO;
        NSString *sexstring=_gerenxinxi[indexPath.row];
        cell.sexSmt.selectedSegmentIndex=[sexstring isEqualToString:@"女"]?1:0;
        cell.sexSmt.tintColor=UIColorFromRGB(MAIN_COLOR_VALUE);
        
    }else{
        cell.valueTxt.hidden=NO;
        cell.sexSmt.hidden=YES;
        cell.valueTxt.text=_gerenxinxi[indexPath.row];
        cell.valueTxt.delegate=self;
        cell.valueTxt.tag=indexPath.row;
    }
    cell.keyLab.text=_datas[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.tag=indexPath.row;
   
    return cell;
}

#pragma mark -
#pragma mark UITableview代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark UITextField的代理方法


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat textfieldbottom=(textField.tag+1)*self.tableview.frame.size.height/5+self.touxiangView.frame.size.height+8+64;//textField底部相在self.view中的位置
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
