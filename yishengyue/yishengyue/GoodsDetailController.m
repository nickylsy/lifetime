//
//  GoodsDetailController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/2.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "GoodsDetailController.h"
#import "GoodsDetailView.h"
#import "Mydefine.h"
#import "AFAppDotNetAPIClient.h"
#import "ST_GoodsDetail.h"
#import "UIImageView+AFNetworking.h"
#import "MessageFormat.h"
#import "AppDelegate.h"
#import "QuerenDingdanController.h"
#import "CartShop.h"
#import "ST_Goods.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>

@interface GoodsDetailController ()<UIScrollViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>
{
    GoodsDetailView *_detailview;
    ST_GoodsDetail *_detail;
    UIWebView *_webview;
    
    UIScrollView *_scrollview;
}
@end

@implementation GoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(16, 7, 46, 30)];
    backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [backBtn setImage:[UIImage imageNamed:@"navback_white.png"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(4, -25, 4, 15)];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=backItem;
    
    
    [MessageFormat POST:SingleShop parameters:@{@"ShopId":self.shop.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _detail=[ST_GoodsDetail detailWithDict:responseObject[@"data"]];
            [self createSubviews];
            
            [_detailview setimages:_detail.bannerImages];
            _detailview.titleLab.text=_detail.name;
            _detailview.priceLab.text=_detail.price;
            
            [_detailview.funcBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
            UITapGestureRecognizer *shareTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share)];
            _detailview.funcLab.userInteractionEnabled=YES;
            [_detailview.funcLab addGestureRecognizer:shareTap];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
        
    } incontroller:self view:self.view];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"商品详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopedit)];
    self.view.userInteractionEnabled=YES;
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}

-(void)createSubviews
{
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat screenheight=self.view.frame.size.height;
    
    _scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0,64, screenwidth, screenheight-STATUSBAR_HEIGHT-TOOLBAR_HEIGHT*2)];
    _scrollview.backgroundColor=self.view.backgroundColor;
    _scrollview.bounces=NO;
    _scrollview.showsVerticalScrollIndicator=NO;
    _scrollview.delegate=self;
    [self.view addSubview:_scrollview];
    
    _detailview=[[UINib nibWithNibName:@"GoodsDetailView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _detailview.frame=CGRectMake(0, 0,screenwidth, (screenwidth-16)/2+167);
    _detailview.numberTxt.enabled=NO;
//    [_detailview setimages:_detail.bannerImages];
//    _detailview.titleLab.text=_detail.name;
//    _detailview.priceLab.text=_detail.price;
    [_scrollview addSubview:_detailview];
    
    CGFloat padding=10.0;
    _webview=[[UIWebView alloc] initWithFrame:CGRectMake(padding, _detailview.frame.size.height, screenwidth-padding*2.0, 1)];
    _webview.delegate=self;
    _webview.scrollView.scrollEnabled=NO;
    _webview.scalesPageToFit=YES;
    _webview.dataDetectorTypes=UIDataDetectorTypeNone;
    [_scrollview addSubview:_webview];
    
    NSURL *url=[NSURL URLWithString:_detail.content.URLEncodedString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [_webview loadRequest:request];
    
 
    _scrollview.contentSize=CGSizeMake(screenwidth, _webview.frame.origin.y+_webview.frame.size.height+10);
    
    
    UIButton *addtoshoppingcartBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, screenheight-TOOLBAR_HEIGHT, screenwidth/2, TOOLBAR_HEIGHT)];
    [addtoshoppingcartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    addtoshoppingcartBtn.tintColor=[UIColor whiteColor];
    addtoshoppingcartBtn.backgroundColor=UIColorFromRGB(0x4be1d3);
    [addtoshoppingcartBtn addTarget:self action:@selector(addtoshoppingcart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addtoshoppingcartBtn];
    
    UIButton *buyBtn=[[UIButton alloc] initWithFrame:CGRectMake(screenwidth/2, screenheight-TOOLBAR_HEIGHT, screenwidth/2, TOOLBAR_HEIGHT)];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    buyBtn.tintColor=[UIColor whiteColor];
    buyBtn.backgroundColor=UIColorFromRGB(0x22bdae);
    [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIButton *callBtn=[[UIButton alloc] initWithFrame:CGRectMake(287, 7, 46, 30)];
    [callBtn setImage:[UIImage imageNamed:@"call_lxmj.png"] forState:UIControlStateNormal];
    [callBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 25, 3, 0)];
    callBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [callBtn addTarget:self action:@selector(callseller) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:callBtn];
    
}

#pragma mark -

-(void)goback
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)stopedit
{
    [_detailview.numberTxt endEditing:YES];
    if (_detailview.numberTxt.text.length<1) {
        _detailview.numberTxt.text=@"1";
    }
}
-(void)addtoshoppingcart
{
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [MessageFormat POST:SaveShoppingCart parameters:@{@"UserId":myapp.user.ID,@"ShopId":self.shop.ID,@"ShopNum":_detailview.numberTxt.text} success:^(NSURLSessionDataTask *task, id responseObject) {
        [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } incontroller:self view:self.view];
}

-(void)buy
{
    QuerenDingdanController *queren=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"querendingdancontroller"];
    
    
    queren.goods=[NSMutableArray array];
    CartShop *c=[[CartShop alloc] init];
    c.name=_detail.name;
    c.shopID=self.shop.ID;
    c.price=_detail.price;
    c.banner=self.shop.banner;
    c.shopNum=_detailview.numberTxt.text;
    [queren.goods addObject:c];
    
    CGFloat totalprice=[c.price substringFromIndex:1].floatValue*c.shopNum.intValue;
    queren.totalstring=[NSString stringWithFormat:@"合计:￥%.2f",totalprice];
    
    queren.clearcart=NO;
    
    [self.navigationController pushViewController:queren animated:YES];
}

-(void)callseller
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否拨打卖家电话"delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
}

-(void)share
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        
        AppDelegate *myapp=[UIApplication sharedApplication].delegate;
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:nil
                                           defaultContent:@"商城"
                                                    image:[ShareSDK imageWithUrl:self.shop.banner]
                                                    title:self.shop.name
                                                      url:[NSString stringWithFormat:@"%@/Share/Share/shopindex/sharecode/%@/shopid/%@",AFAppDotNetAPIBaseURLString,myapp.user.shareCode,self.shop.ID]
                                              description:@"全民经纪人-商城"
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
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                        [MessageFormat hintWithMessage:@"分享成功" inview:self.view completion:nil];
                                        [[AFAppDotNetAPIClient sharedClient] POST:ShopShareSucess parameters:@{@"UserId":myapp.user.ID,@"ShopId":self.shop.ID,@"Code":myapp.user.shareCode,@"Type":type==ShareTypeWeixiSession?@"2":@"1"} success:^(NSURLSessionDataTask *task, id responseObject) {
                                            
                                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            NSLog(@"fail");
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
#pragma mark - UIScrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self stopedit];
}

#pragma mark - webview代理方法
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    CGRect frame=webView.frame;
//    frame.size.height=webView.scrollView.contentSize.height;
//    webView.frame = frame;
    
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    
    
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    newFrame.size.width=actualSize.width;
    webView.frame = newFrame;
    
    NSLog(@"%@",NSStringFromCGRect(newFrame));

    _scrollview.contentSize=CGSizeMake(self.view.frame.size.width, _webview.frame.origin.y+_webview.frame.size.height+10);
}

#pragma mark - UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_detail.phoneNumber]]];
    }
    
    [alertView removeFromSuperview];
    alertView=nil;
}


@end
