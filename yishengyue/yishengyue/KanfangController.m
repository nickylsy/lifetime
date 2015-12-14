//
//  KanfangController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/27.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "KanfangController.h"
#import "AFAppDotNetAPIClient.h"
#import "NSString+URLEncoding.h"
#import "UIViewController+ActivityHUD.h"

@interface KanfangController ()<UIWebViewDelegate>

@end

@implementation KanfangController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    [[AFAppDotNetAPIClient sharedClient] POST:_postURL.URLEncodedString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",(NSDictionary *)responseObject);
        
        self.webview.delegate=self;
        self.webview.scalesPageToFit=YES;
        
        NSString *urlstr=responseObject[@"data"];
        NSURL *url =[NSURL URLWithString:[urlstr URLEncodedString]];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [self.webview loadRequest:request];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    }];
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

- (IBAction)goback:(id)sender {
    
    [self.webview loadHTMLString:@"" baseURL:nil];
    [self.webview stopLoading];
    [self.webview setDelegate:nil];
    [self.webview removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - webview代理方法

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
     [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
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
    [self endWaiting];
}


@end
