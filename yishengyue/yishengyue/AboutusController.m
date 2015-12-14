//
//  AboutusController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/10.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AboutusController.h"
#import "UIViewController+ActivityHUD.h"
#import "NSString+URLEncoding.h"

@interface AboutusController ()<UIWebViewDelegate>

@end

@implementation AboutusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.webView.delegate=self;
    
    NSURL *url=[NSURL URLWithString:self.urlstring.URLEncodedString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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
- (IBAction)goback:(UIButton *)sender {
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
    [self.webView setDelegate:nil];
    [self.webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - webview代理方法

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    NSLog(@"finish");
    [self endWaiting];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start");
    [self pleaseWaitInView:self.view];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"fail----%@",error.debugDescription);
    [MessageFormat hintWithMessage:@"加载失败" inview:self.view completion:nil];
    [self endWaiting];
}


@end
