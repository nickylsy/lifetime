//
//  LearnViewController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/13.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "LearnViewController.h"
#import "BDKNotifyHUD.h"
#import "AsyncUdpSocket.h"
#import "MessageFormat.h"
#import "MyInputView.h"
#import "AppDelegate.h"

@interface LearnViewController () <AsyncUdpSocketDelegate,UITextFieldDelegate,NSXMLParserDelegate>
{
    NSString *_currentXMLtag;
    NSString *_XMLaction;
    BOOL _flag;
    AppDelegate *_myapp;
}
@end

@implementation LearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myapp=[UIApplication sharedApplication].delegate;
    _flag=YES;
    
    NSString *str=[MessageFormat learnWithboxID:self.boxID username:_myapp.user.ID btnID:self.btnID];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MessageFormat sendMessage:str socketDelegate:self tag:1];
        self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changetime) userInfo:nil repeats:YES];
        [self.timer fire];
    });
    
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

-(void)changetime
{
    int a=self.timeLab.text.intValue;
    self.timeLab.text=[NSString stringWithFormat:@"%i",--a];
    if (a==0) {
        [self.timer invalidate];
        NSString *str=[MessageFormat learnretWithboxID:self.boxID btnID:self.btnID];
        [MessageFormat sendMessage:str socketDelegate:self tag:2];
    }
}

-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
        NSLog(@"收到udp数据---%@----host:%@----port:%i----tag:%ld",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],host,port,tag);
        [sock close];
        NSXMLParser *paser=[[NSXMLParser alloc] initWithData:data];
        paser.delegate=self;
        [paser parse];sock=nil;

  
    return YES;
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{

    if (sock.userData==2) {
        [self showretWithstring:@"学习失败"];
    }
    [sock close];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentXMLtag=elementName;
    if ([elementName isEqualToString:@"para"]) {
        _XMLaction=attributeDict[@"action"];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([_XMLaction isEqualToString:@"learnret"]) {
        if ([_currentXMLtag isEqualToString:@"boxid"]) {
            if (![string isEqualToString:self.boxID]) {
                _flag=NO;
            }
        }
        if ([_currentXMLtag isEqualToString:@"btnid"]) {
            if (![string isEqualToString:self.btnID]) {
                _flag=NO;
            }
        }
        if ([_currentXMLtag isEqualToString:@"ret"]) {
            if (string.intValue!=0) {
                _flag=NO;
            }
        }
    }
    
    if ([_XMLaction isEqualToString:@"setbtnname"]) {
        if ([_currentXMLtag isEqualToString:@"ret"]) {
            BDKNotifyHUD *hud=[BDKNotifyHUD notifyHUDWithImage:nil text:string.intValue==0?@"设置名字成功":@"设置名字失败"];
            hud.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*3/4);
            [self.view addSubview:hud];
            [hud presentWithDuration:0.5 speed:0.3 inView:self.view completion:^{
                [hud removeFromSuperview];
                 [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([_XMLaction isEqualToString:@"learnret"]) {
        NSString *hintstr;
        if (_flag) {
            hintstr=@"学习成功";
        }else
        {
            hintstr=@"学习失败";
            self.needinputname=NO;
        }
        [self showretWithstring:hintstr];
    }
}

-(void)showretWithstring:(NSString *)string
{
    BDKNotifyHUD *hud=[BDKNotifyHUD notifyHUDWithImage:nil text:string];
    hud.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:hud];
    [hud presentWithDuration:0.5 speed:0.3 inView:self.view completion:^{
        [hud removeFromSuperview];
        if (self.needinputname) {
            MyInputView *inputnameview=[[UINib nibWithNibName:@"MyInputView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
            inputnameview.center=self.view.center;
            inputnameview.hintLab.text=@"请输入按钮名字";
            inputnameview.nameTxt.delegate=self;
            [inputnameview setDismisscallback:^(NSString *name) {
                if (name.length>0) {
                    NSString *setnamestr=[MessageFormat setbuttonnameWithboxID:_boxID btnID:_btnID btnname:name];
                    [MessageFormat sendMessage:setnamestr socketDelegate:self tag:1];
                }
                self.view.alpha=1;
            }];
            [self.view addSubview:inputnameview];
            self.view.alpha=0.8;
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.superview.frame;
    CGFloat offset=self.view.frame.size.height-frame.size.height-frame.origin.y-50;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset <216.0)
        textField.superview.frame = CGRectMake(frame.origin.x,frame.origin.y+offset-216.0, textField.superview.frame.size.width, textField.superview.frame.size.height);
    
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
    textField.superview.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
}


@end
