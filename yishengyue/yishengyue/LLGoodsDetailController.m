//
//  LLGoodsDetailController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/2.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "LLGoodsDetailController.h"
#import "LL_GoodsDetailView.h"
#import "Mydefine.h"
#import "MessageFormat.h"
#import "LL_GoodsDetail.h"

@interface LLGoodsDetailController ()<UIAlertViewDelegate>
{
    LL_GoodsDetailView *_detailview;
    LL_GoodsDetail *_detail;
    UIScrollView *_scrollview;
}
@end

@implementation LLGoodsDetailController

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
    
    
    
    [MessageFormat POST:SingleNeighborShop parameters:@{@"UserId":self.userID,@"NeighborId":self.shopID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _detail=[LL_GoodsDetail detailWithDict:responseObject[@"data"]];
            [self createSubviews];
        
            _detailview.centerLab.text=[NSString stringWithFormat:@"发布人：%@ %@",_detail.username,_detail.userPhoneNum];
            [_detailview setimages:_detail.bannerImages];
            _detailview.titleLab.text=_detail.name;
            _detailview.priceLab.text=_detail.price;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
        
    } incontroller:self view:self.view];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"商品详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
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

-(void)createSubviews
{
    CGFloat phoneBtnHeight=TOOLBAR_HEIGHT;
    
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat screenheight=self.view.frame.size.height;
    
    _scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0,64, screenwidth, screenheight-STATUSBAR_HEIGHT-TOOLBAR_HEIGHT-phoneBtnHeight)];
    _scrollview.backgroundColor=self.view.backgroundColor;
    _scrollview.bounces=NO;
    _scrollview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_scrollview];
    
    _detailview=[[UINib nibWithNibName:@"LL_GoodsDetailView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _detailview.frame=CGRectMake(0, 0,screenwidth,(screenwidth-16)/1.4+167);
    _detailview.centerLab.text=[NSString stringWithFormat:@"发布人：%@ %@",_detail.username,_detail.userPhoneNum];
   
//    [_detailview setimages:_detail.bannerImages];
//    _detailview.titleLab.text=_detail.name;
//    _detailview.priceLab.text=_detail.price;
    [_scrollview addSubview:_detailview];
    
    UITextView *textview=[[UITextView alloc] initWithFrame:CGRectMake(0, _detailview.frame.size.height, screenwidth, 0)];
    textview.text=_detail.content;
    textview.font=[UIFont systemFontOfSize:15.0];
    [textview sizeToFit];
    textview.scrollEnabled=NO;
    textview.selectable=NO;
    textview.editable=NO;
    [_scrollview addSubview:textview];
    
    
    _scrollview.contentSize=CGSizeMake(screenwidth, textview.frame.origin.y+textview.frame.size.height+10);
    
    
    UIButton *phoneBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenwidth, phoneBtnHeight)];
    phoneBtn.center=CGPointMake(screenwidth/2, self.view.bounds.size.height-phoneBtnHeight/2);
    phoneBtn.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    [phoneBtn setTitle:@"联系卖家购买" forState:UIControlStateNormal];
    [phoneBtn setImage:[UIImage imageNamed:@"call_lxmj.png"] forState:UIControlStateNormal];
    phoneBtn.imageEdgeInsets=UIEdgeInsetsMake(10, 0, 10, 30);
    phoneBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [phoneBtn addTarget:self action:@selector(phonecall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneBtn];
    
}
-(void)phonecall
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否拨打卖家电话"delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
}

-(void)goback
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_detail.userPhoneNum]];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    [alertView removeFromSuperview];
    alertView=nil;
}
@end
