//
//  ViewController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/15.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AirboxConfigStep1ViewController.h"
#import "AirboxConfigStep2ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Mydefine.h"
#import "MessageFormat.h"
#import "UIButton+Rectbutton.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface AirboxConfigStep1ViewController ()

@end

@implementation AirboxConfigStep1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self relayoutsubview];
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
;
}


-(void)relayoutsubview
{
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat screenheight=self.view.frame.size.height;
    CGFloat priorityX=screenwidth/SCREENWIDTH_5S;
    CGFloat priorityY=screenheight/SCREENHEIGHT_5S;
    
    self.stepImg.frame=CGRectMake(15*priorityX, 81*priorityY, 290*priorityX, 76*priorityY);
    
    self.hintview.frame=CGRectMake(15*priorityX, 165*priorityY, 289*priorityX, 328*priorityY);
    
    self.okBtn.frame=CGRectMake(15*priorityX, 507*priorityY, 290*priorityX, 40*priorityX);
    [self.okBtn setcornerRadius:40*priorityX/2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startConfig:(id)sender {
    if (![[[self currentSSID] substringWithRange:NSMakeRange(0, 11)] isEqualToString:@"AI-THINKER_"]) {
        [MessageFormat hintWithMessage:@"请连上盒子WIFI" inview:self.view completion:nil];
        return;
    }
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"YSY" bundle:nil];
     AirboxConfigStep2ViewController *step2= [mainStoryboard instantiateViewControllerWithIdentifier:@"step2viewcontroller"];
    [self.navigationController pushViewController:step2 animated:YES];
}

- (IBAction)goback:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
@end
