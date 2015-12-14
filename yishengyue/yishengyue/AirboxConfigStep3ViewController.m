//
//  AirboxConfigStep3ViewController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/15.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AirboxConfigStep3ViewController.h"
#import "AsyncSocket.h"
#import "MessageFormat.h"
#import "AirboxConfigStep4ViewController.h"
#import "AirboxConfigErrorViewController.h"
#import "Mydefine.h"
#import "UIButton+Rectbutton.h"
#import "AppDelegate.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#define BOXIP @"192.168.4.1"
#define BOXPORT 15168

@interface AirboxConfigStep3ViewController ()<AsyncSocketDelegate,NSXMLParserDelegate>
{
    NSString *_currentXMLtag;
    BOOL _configOK;
    NSString *_boxSSID;
    BOOL _temFlag;
    NSString *_temssid;
}

@end

@implementation AirboxConfigStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor=[UIColor colorWithRed:238 green:238 blue:238 alpha:1];
    
//    self.startBindingBtn.layer.masksToBounds=YES;
//    self.startBindingBtn.layer.cornerRadius=5.0;
    [self relayoutsubviews];
    _boxSSID=[self currentSSID];
    
    for (UIImageView *imageview in self.pointview.subviews) {
        NSMutableArray *array=[NSMutableArray array];
        for (int i=(int)imageview.tag; i<=imageview.tag+6; i++) {
            NSString *picname=[NSString stringWithFormat:@"schedule%i.png",7-i%7];
            [array addObject:[UIImage imageNamed:picname]];
        }
        [imageview setAnimationImages:array];
    }
    for (UIImageView *imageview in self.pointview.subviews) {
        [imageview setAnimationRepeatCount:0];
        [imageview setAnimationDuration:7*0.15];
        [imageview startAnimating];
    }
    
    _configOK=NO;
    _temFlag=NO;
    AsyncSocket *socket=[[AsyncSocket alloc] initWithDelegate:self];
    [socket connectToHost:BOXIP onPort:BOXPORT withTimeout:2.0 error:nil];
}

-(NSString *)tcpMsg
{
    return [NSString stringWithFormat:@"AD_AP_INFO;SSID:%@;PASSWORD:%@",self.ssid,self.password];
}



-(void)stopanimations
{
    for (UIImageView *imageview in self.pointview.subviews) {
        [imageview stopAnimating];
    }
}
-(void)relayoutsubviews
{
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat screenheight=self.view.frame.size.height;
    CGFloat priorityX=screenwidth/SCREENWIDTH_5S;
    CGFloat priorityY=screenheight/SCREENHEIGHT_5S;
    
    self.stepImg.frame=CGRectMake(15*priorityX, 81*priorityY, 290*priorityX, 76*priorityY);
    
    self.centerview.frame=CGRectMake(16, 161, 288*priorityY, 246*priorityY);
    self.centerview.center=CGPointMake(screenwidth/2, screenheight/2);
    
    self.startBindingBtn.frame=CGRectMake(15*priorityX, 507*priorityY, 135*priorityX, 40*priorityX);
    [self.startBindingBtn setcornerRadius:40*priorityX/2];
    self.startBindingBtn.center=CGPointMake(screenwidth/2-self.startBindingBtn.frame.size.width/2-10, self.startBindingBtn.center.y);
    
    self.completeBtn.frame=self.startBindingBtn.frame;
    [self.completeBtn setcornerRadius:40*priorityX/2];
    self.completeBtn.center=CGPointMake(screenwidth/2+self.startBindingBtn.frame.size.width/2+10, self.startBindingBtn.center.y);
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




- (IBAction)startBinding:(id)sender {
    if (_configOK) {
        AppDelegate *myapp=[UIApplication sharedApplication].delegate;
        NSString *bindboxstr=[MessageFormat bindToboxwithuserID:myapp.user.ID boxID:self.boxID];
        [MessageFormat sendMessage:bindboxstr socketDelegate:self tag:1];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)finish:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark XML解析方法

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
//    NSLog(@"%@",string);
    if ([_currentXMLtag isEqualToString:@"ret"]) {
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"YSY" bundle:nil];
        if ([string isEqualToString:@"0"]) {
            AirboxConfigStep4ViewController *step4= [mainStoryboard instantiateViewControllerWithIdentifier:@"step4viewcontroller"];
            step4.boxID=_boxID;
            [self.navigationController pushViewController:step4 animated:YES];
        }else{
            AirboxConfigErrorViewController *errorview= [mainStoryboard instantiateViewControllerWithIdentifier:@"airboxconfigerror"];
            [self.navigationController pushViewController:errorview animated:YES];
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    NSLog(@"elementName:%@-----namespaceURI:%@------qualifiedName:%@",elementName,namespaceURI,qName);
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}
#pragma  mark AsyncScoket代理方法

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"%@---host:%@",sock.description,host);
    
    if (_temFlag==NO) {
        NSString *msg=[self tcpMsg];
        NSData *data=[msg dataUsingEncoding:NSUTF8StringEncoding];
        
        
        [sock writeData:data withTimeout:3.0 tag:5];
        [sock readDataWithTimeout:30.0 tag:5];
    }
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"收到TCP消息------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSString *statusString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([statusString isEqualToString:@"AD_AP_STATUS:OK\r\n"]) {
            _configOK=YES;
            NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(detectSSID:) userInfo:nil repeats:YES];
            [timer fire];
        }else// if ([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"AD_AP_STATUS:FAIL"])
        {
            _configOK=NO;
            [self showButtons];
        }
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"%@",err);
    [sock disconnect];
    _configOK=YES;
//    _temFlag=YES;
//    
//    AsyncSocket *socket=[[AsyncSocket alloc] initWithDelegate:self];
//    [socket connectToHost:BOXIP onPort:BOXPORT withTimeout:2.0 error:nil];
    NSTimer *temtimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(detectSSID:) userInfo:nil repeats:YES];
    [temtimer fire];
}

//-(void)detectSSID
//{
//    if (![_temssid isEqualToString:[self currentSSID]]) {
//        <#statements#>
//    }
//}
-(void)detectSSID:(NSTimer *)timer
{
    if (![[self currentSSID] isEqualToString:_boxSSID]) {
        [timer invalidate];
        [self showButtons];
    }
}

-(void)showButtons
{
    [self stopanimations];
    
    self.startBindingBtn.hidden=NO;
    self.completeBtn.hidden=NO;
    
    [self.startBindingBtn setTitle:_configOK?@"继续绑定":@"重新配置" forState:UIControlStateNormal];
    [self.completeBtn setTitle:_configOK?@"完成":@"取消" forState:UIControlStateNormal];
    self.hintLab.text=_configOK?@"配置成功":@"";
}

- (NSString *)currentSSID {
    NSString *ssid;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSDictionary *dict = (__bridge_transfer NSDictionary*)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        ssid=dict[@"SSID"];
        
//        boxID=[ssid substringFromIndex:4];
//        NSLog(@"当前盒子的ID是:%@",boxID);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return ssid;
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"发送TCP消息成功");
    
}
@end
