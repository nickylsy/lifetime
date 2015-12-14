//
//  UserLoginViewController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/20.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "UserLoginViewController.h"
#import "Mydefine.h"
#import "RegisterPhoneController.h"
#import "AsyncUdpSocket.h"
#import "BDKNotifyHUD.h"
#import "MessageFormat.h"
#import "AFNetworking/AFAppDotNetAPIClient.h"
#import "NSString+URLEncoding.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "REFrostedViewController.h"
#import "MycontainerController.h"
#import "UIButton+Rectbutton.h"
#import "UIViewController+ActivityHUD.h"
#import "DES3Util.h"

@interface UserLoginViewController ()<NSXMLParserDelegate,AsyncUdpSocketDelegate,UITextFieldDelegate,UITabBarControllerDelegate,UIScrollViewDelegate>
{
    NSString *_currentXMLtag;
    UIScrollView *_yindaoPage;
    UIPageControl *_yindaoPageControl;
}
@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.phoneTxt.delegate=self;
    self.passwordTxt.delegate=self;
    
    self.phoneTxt.text=[[NSUserDefaults standardUserDefaults] objectForKey:TEL_KEY];
    self.passwordTxt.text=[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD_KEY];

    
    //设置电话号码输入框的边框和圆角
    self.phoneItem.layer.masksToBounds=YES;
    self.phoneItem.layer.cornerRadius=self.phoneItem.layer.frame.size.height/2;
    self.phoneItem.layer.borderWidth=1;
    self.phoneItem.layer.borderColor=UIColorFromRGB(MAIN_COLOR_VALUE).CGColor;
    
    //设置密码输入框的边框和圆角
    self.passwordItem.layer.masksToBounds=YES;
    self.passwordItem.layer.cornerRadius=self.passwordItem.layer.frame.size.height/2;
    self.passwordItem.layer.borderWidth=1;
    self.passwordItem.layer.borderColor=UIColorFromRGB(MAIN_COLOR_VALUE).CGColor;
    
    self.view.backgroundColor=UIColorFromRGB(0xeeeeee);
    
    //设置登陆按钮的圆角
    [self.loginBtn setcornerRadius:self.loginBtn.frame.size.height/2];
    self.loginBtn.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    
    UITapGestureRecognizer *forgetrecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updatePassword)];
    self.forgetpsdLab.userInteractionEnabled=YES;
    [self.forgetpsdLab addGestureRecognizer:forgetrecognizer];
    
    UITapGestureRecognizer *registerrecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerNewuser)];
    self.registerLab.userInteractionEnabled=YES;
    [self.registerLab addGestureRecognizer:registerrecognizer];
    
    UITapGestureRecognizer *youketap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(youkemode)];
    self.youkeLab.userInteractionEnabled=YES;
    [self.youkeLab addGestureRecognizer:youketap];
    
    UITapGestureRecognizer *singletap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopkeyboard)];
    self.view.userInteractionEnabled=YES;
    [self.view addGestureRecognizer:singletap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //Calling this methods builds the intro and adds it to the screen. See below.
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"needyindaopage"]) {
        // 这里判断是否第一次
        [self buildIntro];
    }

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"needyindaopage"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)buildIntro{

    UIImage *image1=[UIImage imageNamed:@"yindaopage2.png"];
    UIImage *image2=[UIImage imageNamed:@"yindaopage3.png"];
    UIImage *image3=[UIImage imageNamed:@"yindaopage1.png"];
    NSArray *array=@[image1,image2,image3];
    
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat screenheight=self.view.frame.size.height;
    
    _yindaoPage=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    _yindaoPage.delegate=self;
    _yindaoPage.bounces=NO;
    _yindaoPage.pagingEnabled=YES;
    _yindaoPage.userInteractionEnabled=YES;
    _yindaoPage.showsHorizontalScrollIndicator=NO;
    _yindaoPage.showsVerticalScrollIndicator=NO;
    _yindaoPage.contentSize=CGSizeMake(screenwidth*3, screenheight);
    [self.view addSubview:_yindaoPage];
    
    UIImageView *page1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
    page1.image=array[0];
    [_yindaoPage addSubview:page1];
    
    UIImageView *page2=[[UIImageView alloc] initWithFrame:CGRectMake(screenwidth, 0, screenwidth, screenheight)];
    page2.image=array[1];
    [_yindaoPage addSubview:page2];
    
    UIView *page3=[[UIImageView alloc] initWithFrame:CGRectMake(screenwidth*2,0, screenwidth, screenheight)];
    page3.userInteractionEnabled=YES;
    [_yindaoPage addSubview:page3];
    
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:page3.bounds];
    imageview.image=array[2];
    [page3 addSubview:imageview];
    
    CGFloat skipBtnWidth=200.0;
    CGFloat skipBtnHeight=40.0;
    UIButton *skipButton=[UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.userInteractionEnabled=YES;
    skipButton.frame=CGRectMake(0, 0,skipBtnWidth,skipBtnHeight);
    skipButton.center=CGPointMake(screenwidth/2, screenheight-80);
    [skipButton setTitle:@"开启一生约全新体验之旅" forState:UIControlStateNormal];
    skipButton.titleLabel.font=[UIFont systemFontOfSize:15.0];
    skipButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    skipButton.layer.masksToBounds=YES;
    skipButton.layer.cornerRadius=skipBtnHeight/2;
    skipButton.layer.borderColor=[UIColor whiteColor].CGColor;
    skipButton.layer.borderWidth=1.0;
    [page3 addSubview:skipButton];
    [skipButton addTarget:self action:@selector(finishYindaopage) forControlEvents:UIControlEventTouchUpInside];
    
    _yindaoPageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    _yindaoPageControl.center=CGPointMake(screenwidth/2, screenheight-40);
    _yindaoPageControl.numberOfPages=array.count;
    [self.view addSubview:_yindaoPageControl];
}

-(void)finishYindaopage
{
    [UIView animateWithDuration:0.5 animations:^{
        _yindaoPage.alpha=0;
        _yindaoPageControl.alpha=0;
    } completion:^(BOOL finished) {
        [_yindaoPage removeFromSuperview];
        _yindaoPage=nil;
        [_yindaoPageControl removeFromSuperview];
        _yindaoPageControl=nil;
    }];
}
- (IBAction)login:(id)sender
{
    if (self.phoneTxt.text.length<1) {
        [MessageFormat hintWithMessage:@"请输入手机号码" inview:self.view completion:^{
            [self.phoneTxt becomeFirstResponder];
        }];
        return;
    }
    if (self.passwordTxt.text.length<1) {
        [MessageFormat hintWithMessage:@"请输入密码" inview:self.view completion:^{
            [self.passwordTxt becomeFirstResponder];
        }];
        return;
    }
    if (self.phoneTxt.text.length<11) {
        [MessageFormat hintWithMessage:@"请输入正确的手机号码" inview:self.view completion:^{
            [self.phoneTxt becomeFirstResponder];
        }];
        return;
    }
    
    [MessageFormat POST:Login parameters:@{@"Tel":self.phoneTxt.text,@"PassWord":[DES3Util encrypt:self.passwordTxt.text]} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneTxt.text forKey:TEL_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:self.passwordTxt.text forKey:PASSWORD_KEY];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autologin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            AppDelegate *myapp=[UIApplication sharedApplication].delegate;
            myapp.user=[YSYUser userWihtDict:responseObject[@"data"]];
            
            // Create content and menu controllers
            MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
            MycontainerController *container=[[MycontainerController alloc] init];
            // Create frosted view controller
            REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:container menuViewController:menuController];
            frostedViewController.direction = REFrostedViewControllerDirectionLeft;
            // Make it a root controller
            [self presentViewController:frostedViewController animated:YES completion:nil];
        } else {
            [MessageFormat hintWithMessage:(NSString *)responseObject[@"message"] inview:self.view completion:nil];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } incontroller:self view:self.view];
}


-(void)updatePassword
{
    UIStoryboard *mainstoryboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
    UINavigationController *registerview=[mainstoryboard instantiateViewControllerWithIdentifier:@"forgotpasswordnavcontrtoller"];
    [registerview setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:registerview animated:YES completion:nil];
}

-(void)youkemode
{
    // Create content and menu controllers
    MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
    MycontainerController *container=[[MycontainerController alloc] init];
    // Create frosted view controller
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:container menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    // Make it a root controller
    [self presentViewController:frostedViewController animated:YES completion:nil];
}

-(void)registerNewuser
{
    UIStoryboard *mainstoryboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
    UINavigationController *registerview=[mainstoryboard instantiateViewControllerWithIdentifier:@"registernavcontroller"];
    [registerview setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:registerview animated:YES completion:nil];
}

-(void)stopkeyboard
{
    [self.phoneTxt endEditing:YES];
    [self.passwordTxt endEditing:YES];
}

#pragma mark - AsyncUdpSocket代理方法

-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"收到udp数据---%@----host:%@----port:%i----tag:%ld",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],host,port,tag);
    [sock close];
    
    NSXMLParser *paser=[[NSXMLParser alloc] initWithData:data];
    paser.delegate=self;
    [paser parse];
    
    return YES;
}

#pragma mark - NSXMLParser代理方法

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentXMLtag=elementName;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([_currentXMLtag isEqualToString:@"ret"]) {
        if (string.intValue==0) {
            UIStoryboard *mainstoryboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
//            MyTabBarController *homepage=[mainstoryboard instantiateViewControllerWithIdentifier:@"mytabbarcontroller"];
//            homepage.username=self.phoneTxt.text;
//            [self presentViewController:homepage animated:YES completion:nil];
        }
        else
        {
            BDKNotifyHUD *hud=[BDKNotifyHUD notifyHUDWithImage:nil text:@"登陆失败"];
            hud.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
            [self.view addSubview:hud];
            [hud presentWithDuration:0.5 speed:0.3 inView:self.view completion:^{
                [hud removeFromSuperview];
            }];
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


#pragma mark - UITextField的代理方法


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    CGFloat offset=self.view.frame.size.height-frame.size.height-frame.origin.y-50;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset <216.0)
        self.view.frame = CGRectMake(0.0f, offset-216.0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - UIScrollView代理方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _yindaoPageControl.currentPage=(int)(scrollView.contentOffset.x/self.view.frame.size.width);
}

@end
