//
//  RuleController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/20.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "RuleController.h"
#import "AFAppDotNetAPIClient.h"

@interface RuleController ()

@end

@implementation RuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *URLString=[NSString stringWithFormat:@"%@/Share/Share/agreement",AFAppDotNetAPIBaseURLString];
    NSURL *url=[NSURL URLWithString:URLString];
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

@end
