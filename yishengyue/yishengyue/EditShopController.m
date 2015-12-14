//
//  EditShopController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/15.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "EditShopController.h"
#import "MessageFormat.h"
#import "UIImageView+AFNetworking.h"
#import "AddPicViewItem.h"

#import "UIWindow+YUBottomPoper.h"
#import "AFAppDotNetAPIClient.h"
#import "MessageFormat.h"
#import "UIViewController+ActivityHUD.h"
#import "AppDelegate.h"
#import "WKAlertView.h"


#define TAG_FLAG 111

@interface EditShopController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSMutableArray *_pics;
    UIWindow *_warningWindow;
}
@end

@implementation EditShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shopDetailTxt.placeholder=@"填写商品介绍或者特点，让您的商品更生动";
    _pics=[NSMutableArray array];
    
    [self refreshPics];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endedit)];
    self.view.userInteractionEnabled=YES;
    [self.view addGestureRecognizer:tap];
    
    [self hidecontentview];
    
    [MessageFormat POST:MySingleNeighborShop parameters:@{@"NeighborId":self.shopID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            [self showcontentview];
            NSDictionary *dict=responseObject[@"data"];
            self.shopTitleTxt.text=dict[@"Name"];
            for (NSString *s in dict[@"Pics"]) {
                NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:s]];
                [_pics addObject:[UIImage imageWithData:data]];
            }
            [self refreshPics];;
            self.shopDetailTxt.text=dict[@"Content"];
            self.shopPriceTxt.text=dict[@"Price"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self view:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hidecontentview
{
    self.shopDetailTxt.hidden=YES;
    self.picScrollview.hidden=YES;
    self.shopTitleTxt.hidden=YES;
    self.shopPriceTxt.hidden=YES;
}

-(void)showcontentview
{
    self.shopDetailTxt.hidden=NO;
    self.picScrollview.hidden=NO;
    self.shopTitleTxt.hidden=NO;
    self.shopPriceTxt.hidden=NO;
}

-(void)endedit
{
    [self.shopTitleTxt endEditing:YES];
    [self.shopDetailTxt resignFirstResponder];
    [self.shopPriceTxt endEditing:YES];
}


-(void)refreshPics
{
    for (UIView *view in self.picScrollview.subviews) {
        if (view.tag==TAG_FLAG) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat itemHeight=100;
    for (int i=0; i<_pics.count; i++) {
        AddPicViewItem *item=[[UINib nibWithNibName:@"AddPicViewItem" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
        item.contentImg.image=_pics[i];
        item.deleteImg.tag=i;
        item.frame=CGRectMake(i*itemHeight, 0, itemHeight, itemHeight);
        item.tag=TAG_FLAG;
        [self.picScrollview addSubview:item];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletepic:)];
        item.deleteImg.userInteractionEnabled=YES;
        [item.deleteImg addGestureRecognizer:tap];
    }
    
    AddPicViewItem *item=[[UINib nibWithNibName:@"AddPicViewItem" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    item.contentImg.image=[UIImage imageNamed:@"add_picture.png"];
    item.frame=CGRectMake(_pics.count*itemHeight, 0, itemHeight, itemHeight);
    item.deleteImg.hidden=YES;
    item.tag=TAG_FLAG;
    [self.picScrollview addSubview:item];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addpic)];
    item.contentImg.userInteractionEnabled=YES;
    [item.contentImg addGestureRecognizer:tap];
    
    self.picScrollview.contentSize=CGSizeMake(itemHeight*(_pics.count+1), itemHeight);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)deletepic:(UITapGestureRecognizer *)gesture
{
    [_pics removeObjectAtIndex:gesture.view.tag];
    [self refreshPics];
}

-(void)addpic
{
    [self endedit];
    if (_pics.count>3) {
        [MessageFormat hintWithMessage:@"最多添加4张图片" inview:self.view completion:nil];
        return;
    }
    NSArray * titles=[NSArray arrayWithObjects:@"拍摄",@"从手机里选择", nil];
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

- (IBAction)cancel:(id)sender {
    _warningWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleWaring title:@"取消编辑商品" detail:nil canleButtonTitle:@"否" okButtonTitle:@"是" callBlock:^(MyWindowClick buttonIndex) {
        
        //Window隐藏，并置为nil，释放内存 不能少
        _warningWindow.hidden = YES;
        _warningWindow = nil;
        
        if (buttonIndex==MyWindowClickForOK) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
}

- (IBAction)releaseShop:(id)sender {
    if (self.shopDetailTxt.text.length<1 ||self.shopTitleTxt.text.length<1 || self.shopPriceTxt.text.length<1 || _pics.count<1) {
        [MessageFormat hintWithMessage:@"请补全信息" inview:self.view completion:nil];
        return;
    }
//    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [self pleaseWaitInView:self.view];
    [[AFAppDotNetAPIClient sharedClient] POST:EditNeighborShop.URLEncodedString parameters:@{@"NeighborId":self.shopID,@"Name":self.shopTitleTxt.text,@"Price":self.shopPriceTxt.text,@"Content":self.shopDetailTxt.text} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        int i=0;
        for (UIImage *img in _pics) {
            i++;
            NSData *_filedata = UIImageJPEGRepresentation(img,0.5);
            [formData appendPartWithFileData:_filedata name:[NSString stringWithFormat:@"file%i",i ] fileName:[NSString stringWithFormat:@"shop%i.jpeg",i ] mimeType:@"image/jpeg"];
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self endWaiting];
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            [MessageFormat hintWithMessage:@"编辑成功" inview:self.view completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SHOPLIST object:nil];
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endWaiting];
    }];
}

#pragma mark -
#pragma mark UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage  *img = [info objectForKey:UIImagePickerControllerEditedImage];
    [_pics addObject:img];
    [self refreshPics];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextField的代理方法

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGRect frame =CGRectMake(textField.superview.frame.origin.x+textField.frame.origin.x, textField.superview.frame.origin.y+textField.frame.origin.y+64, textField.frame.size.width, textField.frame.size.height);
//    CGFloat offset=self.view.frame.size.height-frame.size.height-frame.origin.y-50;
//    
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset <216.0)
//        self.view.frame = CGRectMake(0.0f, offset-216.0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [UIView commitAnimations];
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
