//
//  AddroomViewController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AddroomViewController.h"
#import "HMSegmentedControl.h"
#import "SMVerticalSegmentedControl.h"


@interface AddroomViewController ()

@end

@implementation AddroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webview.delegate=self;
    self.webview.scalesPageToFit=YES;
    NSString *urlString=@"http://www.baidu.com";
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    
    
    
    self.roomTab.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    [self.roomTab setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [self.roomTab setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [self.roomTab setSelectionIndicatorHeight:2];
    [self.roomTab setSelectionIndicatorColor:[UIColor redColor]];
    self.roomTab.showVerticalDivider=YES;
    [self.roomTab setVerticalDividerColor:[UIColor grayColor]];
    [self.roomTab setSectionTitles:[NSArray arrayWithObjects:@"客厅",@"卧室",@"主卧室",@"卫生间",@"厨房", nil]];
    
    self.roomTab.layer.borderWidth=1;
    self.roomTab.layer.borderColor=[UIColor grayColor].CGColor;


    self.goodsTab.textColor = [UIColor grayColor];
    self.goodsTab.selectedTextColor = [UIColor blackColor];
    self.goodsTab.textAlignment = SMVerticalSegmentedControlTextAlignmentCenter;
    self.goodsTab.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
    self.goodsTab.selectionIndicatorThickness = 0;
    self.goodsTab.selectionBoxBorderWidth = 2;
    self.goodsTab.selectionBoxBackgroundColorAlpha = 0.5;
    self.goodsTab.selectionBoxBorderColorAlpha = 0.7;
    self.goodsTab.indexChangeBlock = ^(NSInteger index) {
        //TODO: add handler
  
    }; 

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


/****webview代理方法*/

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finish");
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"fail----%@",error);
}


- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
