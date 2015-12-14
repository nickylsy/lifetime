//
//  TuihuoController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/21.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "TuihuoController.h"
#import "Mydefine.h"
#import "UIView+RoundRectView.h"
#import "NSDictionary+GetObjectBykey.h"
#import "AddPicViewItem.h"
#import "UIWindow+YUBottomPoper.h"
#import "MessageFormat.h"
#import "TuihuoRuleController.h"
#import "UIViewController+ActivityHUD.h"

#define TAG_FLAG 111


@interface TuihuoController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *_pics;
}
@end

@implementation TuihuoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"退货";
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    self.nameLab.textColor=UIColorFromRGB(FONT_COLOR_VALUE);
    self.priceLab.textColor=self.nameLab.textColor;
    self.numberLab.textColor=self.nameLab.textColor;
    
    [self.scrollView setcornerRadius:5.0 borderWidh:1.0 borderColor:UIColorFromRGB(0xe6e6e6)];
    [self.reasonTxt setcornerRadius:5.0 borderWidh:1.0 borderColor:UIColorFromRGB(0xe1e1e1)];
    [self.descTxt setcornerRadius:5.0 borderWidh:1.0 borderColor:UIColorFromRGB(0xe1e1e1)];
    [self.okBtn setcornerRadius:5.0];
    
    self.nameLab.text=[self.shopInfo getObjectByKey:@"Name"];
    NSString *priceString=[self.shopInfo getObjectByKey:@"DiscountPrice"];
    NSString *numberString=[self.shopInfo getObjectByKey:@"ShopNum"];
    self.priceLab.text=[NSString stringWithFormat:@"%.2f",priceString.floatValue*numberString.intValue];
    self.numberLab.text=numberString;
    
    _pics=[NSMutableArray array];
    [self refreshPics];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endedit)];
    self.view.userInteractionEnabled=YES;
    [self.view addGestureRecognizer:tap];

    UITapGestureRecognizer *ruleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRule)];
    [self.ruleLab addGestureRecognizer:ruleTap];
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
#pragma mark - 

- (IBAction)tuihuo:(UIButton *)sender {
    if (self.reasonTxt.text.length<1 ||self.descTxt.text.length<1 ||  _pics.count<1) {
        [MessageFormat hintWithMessage:@"请补全信息" inview:self.view completion:nil];
        return;
    }
//    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [self pleaseWaitInView:self.view];
    [[AFAppDotNetAPIClient sharedClient] POST:ReturnOrder parameters:@{@"Did":[_shopInfo getObjectByKey:@"Did"],@"ReturnType":@"1",@"Reason":self.reasonTxt.text,@"Desc":self.descTxt.text} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
            [MessageFormat hintWithMessage:@"申请成功" inview:self.view completion:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endWaiting];
    }];

}

-(void)showRule
{
    TuihuoRuleController *tuihuorule=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"tuihuorulecontroller"];
    [self.navigationController pushViewController:tuihuorule animated:YES];
}
-(void)endedit
{
    [self.reasonTxt resignFirstResponder];
    [self.descTxt resignFirstResponder];
}


-(void)refreshPics
{
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag==TAG_FLAG) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat itemHeight=80;
    for (int i=0; i<_pics.count; i++) {
        AddPicViewItem *item=[[UINib nibWithNibName:@"AddPicViewItem" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
        item.contentImg.image=_pics[i];
        item.deleteImg.tag=i;
        item.frame=CGRectMake(i*itemHeight, 0, itemHeight, itemHeight);
        item.tag=TAG_FLAG;
        [self.scrollView addSubview:item];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletepic:)];
        item.deleteImg.userInteractionEnabled=YES;
        [item.deleteImg addGestureRecognizer:tap];
    }
    
    AddPicViewItem *item=[[UINib nibWithNibName:@"AddPicViewItem" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    item.contentImg.image=[UIImage imageNamed:@"add_picture.png"];
    item.frame=CGRectMake(_pics.count*itemHeight, 0, itemHeight, itemHeight);
    item.deleteImg.hidden=YES;
    item.tag=TAG_FLAG;
    [self.scrollView addSubview:item];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addpic)];
    item.contentImg.userInteractionEnabled=YES;
    [item.contentImg addGestureRecognizer:tap];
    
    self.scrollView.contentSize=CGSizeMake(itemHeight*(_pics.count+1), itemHeight);
}


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

#pragma mark - UIImagePickerController Delegate
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

@end
