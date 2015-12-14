//
//  TuihuoRuleController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/22.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "TuihuoRuleController.h"
#import "AFAppDotNetAPIClient.h"

@implementation TuihuoRuleController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"退货标准";
    
    NSString *urlstring=[NSString stringWithFormat:@"%@/Share/Share/returnshop",AFAppDotNetAPIBaseURLString];
    NSURL *url=[NSURL URLWithString:urlstring];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
@end
