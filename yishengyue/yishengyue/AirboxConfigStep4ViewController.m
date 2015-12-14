//
//  AirboxConfigStep4ViewController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/15.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AirboxConfigStep4ViewController.h"
#import "BoxHomepageController.h"
#import <MapKit/MapKit.h>
#import "MessageFormat.h"
#import "Airbox.h"
#import "AsyncUdpSocket.h"
#import "BDKNotifyHUD.h"
#import "Mydefine.h"
#import "UIButton+Rectbutton.h"
#import "AirboxConfigErrorViewController.h"
#import "AppDelegate.h"
#import "UIViewController+ActivityHUD.h"

@interface AirboxConfigStep4ViewController ()<NSXMLParserDelegate,UITextFieldDelegate>
{
    NSString *_currentXMLtag;
}
@end

@implementation AirboxConfigStep4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self relayoutsubviews];
    
    self.boxnameTxt.delegate=self;
    UITapGestureRecognizer *stopinputTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopinput)];
    [self.view addGestureRecognizer:stopinputTap];
    
    self.navBar.barTintColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    [self setstatusbarColor:self.navBar.barTintColor];
}

-(void)stopinput
{
    [self.boxnameTxt endEditing:YES];
}

-(void)relayoutsubviews
{
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat screenheight=self.view.frame.size.height;
    CGFloat priorityX=screenwidth/SCREENWIDTH_5S;
    CGFloat priorityY=screenheight/SCREENHEIGHT_5S;
    
    self.stepImg.frame=CGRectMake(15*priorityX, 81*priorityY, 290*priorityX, 76*priorityY);
    
    self.centerview.frame=CGRectMake(17, 165, 286*priorityX, 202*priorityX);
    self.centerview.center=CGPointMake(screenwidth/2, screenheight/2);
    
    self.finishBtn.frame=CGRectMake(15*priorityX, 507*priorityY, 290*priorityX, 40*priorityX);
    [self.finishBtn setcornerRadius:40*priorityX/2];
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



- (IBAction)setboxname:(id)sender {
    NSLog(@"%@",self.boxnameTxt.text);
    if (self.boxnameTxt.text.length<1) {
        [MessageFormat hintWithMessage:@"请输入盒子名字" inview:self.view completion:nil];
        return;
    }
    
    Airbox *box=[Airbox boxWithName:self.boxnameTxt.text ID:self.boxID];
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [myapp.boxes addObject:box];
    
    NSString *setboxnamestr=[MessageFormat setboxnameWithboxID:box.ID boxname:box.name];
    [MessageFormat sendMessage:setboxnamestr socketDelegate:self tag:1];
    
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

#pragma mark - XML解析方法

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //    NSLog(@"elementName:%@-----namespaceURI:%@------qualifiedName:%@-------attributes:%@",elementName,namespaceURI,qName,attributeDict);
    _currentXMLtag=elementName;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([_currentXMLtag isEqualToString:@"ret"]) {
        NSString *hintstr;
        if ([string isEqualToString:@"0"]) {
            hintstr=@"设置名字成功";
        }else{
            hintstr=@"设置名字失败";
        }
        [MessageFormat hintWithMessage:hintstr inview:self.view completion:nil];
        if (self.navigationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

@end
