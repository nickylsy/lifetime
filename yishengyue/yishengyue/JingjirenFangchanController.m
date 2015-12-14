//
//  JingjirenFangchanController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/22.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "JingjirenFangchanController.h"
#import "Mydefine.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "MessageFormat.h"
#import "AppDelegate.h"

@interface JingjirenFangchanController ()
{
    AppDelegate *_myapp;
}
@end

@implementation JingjirenFangchanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    self.view.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.titleBar.backgroundColor=self.view.backgroundColor;
    _myapp=[UIApplication sharedApplication].delegate;
    
    NSString *urlstring=[NSString stringWithFormat:@"%@/Share/Share/index/UserId/%@",AFAppDotNetAPIBaseURLString,_myapp.user.ID];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
    
    [self.webView loadRequest:request];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)fenxiang:(UIButton *)sender {
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"AppLogo" ofType:@"png"];
        
        NSString *temstring=[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSString *shareTitle=[temstring componentsSeparatedByString:@","].firstObject;
        NSString *descString=[temstring componentsSeparatedByString:@","].lastObject;
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:descString
                                           defaultContent:@"房产"
                                                    image:[ShareSDK imageWithPath:imagePath]
                                                    title:shareTitle
                                                      url:[NSString stringWithFormat:@"%@/Share/Share/sharedetail/UserId/%@",AFAppDotNetAPIBaseURLString,_myapp.user.ID]
                                              description:@"全民经纪人-房产"
                                                mediaType:SSPublishContentMediaTypeNews];
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
//        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
        
        
        NSArray *shareList = [ShareSDK customShareListWithType:
                              SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                              SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),nil];
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:shareList
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        [MessageFormat hintWithMessage:@"分享成功" inview:self.view completion:nil];
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                        [[AFAppDotNetAPIClient sharedClient] POST:ShareSucess parameters:@{@"UserId":_myapp.user.ID,@"Type":type==ShareTypeWeixiSession?@"2":@"1"} success:^(NSURLSessionDataTask *task, id responseObject) {
                                            
                                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            
                                        }];
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    }
                                }];

    }else{
        [MessageFormat hintWithMessage:@"请安装微信" inview:self.view completion:^{
            
        }];
    }
}
@end
