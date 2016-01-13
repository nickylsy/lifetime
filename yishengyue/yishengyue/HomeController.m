//
//  HomeController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "HomeController.h"
#import "HomeAirvalueView.h"
#import "Mydefine.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "HomeFuncView.h"
#import "IntroduceController.h"
#import "KanfangController.h"
#import "MessageCenterController.h"
#import "NSString+URLEncoding.h"
#import "BoxhomepageController.h"
#import "PlayerController.h"
#import "AppDelegate.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "MessageFormat.h"
#import "AFAppDotNetAPIClient.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HomeFuncItem.h"
#import "MapviewController.h"
#import "LoginDialog.h"
#import "FamilyMember.h"
#import "UIViewController+ActivityHUD.h"
#import "JMHoledView.h"
#import "WKAlertView.h"
#import "DES3Util.h"
#import "UIView+RoundRectView.h"

#import <ShareSDK/ShareSDK.h>
#define ARC4RANDOM_MAX  0x100000000
#define SHUSHI_IMAGE [UIImage imageNamed:@"home_shushi.png"]
#define CHAOBIAO_IMAGE [UIImage imageNamed:@"home_chaobiao.png"]
#define WEIXIAN_IMAGE [UIImage imageNamed:@"home_weixian.png"]
#define SHUSHI_STRING @"舒适"
#define CHAOBIAO_STRING @"超标"
#define WEIXIAN_STRING @"危险"


#define MUST_TAG 11
#define NORMAL_TAG 10


@interface HomeController ()<NSXMLParserDelegate,UITextFieldDelegate,JMHoledViewDelegate,UIAlertViewDelegate>
{
    NSString *_currentXMLtag;
    NSString *_currentXMLtagAttr;
    NSString *_XMLAction;
    NSArray *_poststrings;
    AppDelegate *_myapp;
    HomeAirvalueView *_airvalueview;
    HomeFuncView *_funcView;
    NSTimer *_timer;
    NSTimer * _changeTimer;
    JMHoledView *_holedview;
    UIWindow *_warningWindow;
    UIView * playerview;
}
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _poststrings=[NSArray arrayWithObjects:@"/Api/WisdomFamily/BrandIntroduction",
                  @"/Api/WisdomFamily/VtourUrl",
                  @"http://api.map.baidu.com/marker?location=30.525946,105.600379&title=遂宁尚城澜庭&output=html",
                  @"/Api/WisdomFamily/Panoramic",
                  @"/Api/WisdomFamily/Apartment",
                  @"/Api/WisdomFamily/MessageCenter",
                  @"/Api/WisdomFamily/AudioUrl",
                  nil];
    
    [self createsubviews];
    _myapp=[UIApplication sharedApplication].delegate;
    [self getallboxes];
    [self checkUpdate];
    [self getHomeValue];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (_myapp.user) {
    [[AFAppDotNetAPIClient sharedClient]
     POST:MessageCenter.URLEncodedString
     parameters:_myapp.user == nil?nil:@{@"UserId":_myapp.user.ID}
     success:^(NSURLSessionDataTask *task, id responseObject) {
            NSNumber *statuscode=responseObject[@"code"];
            if (statuscode.intValue==0) {
                NSArray *array=responseObject[@"data"];
                [_myapp.messages removeAllObjects];
                for (NSDictionary *dict in array) {
                    MessageOfMessageCenter *message=[MessageOfMessageCenter messageWihtDictionary:dict];
                    [_myapp.messages addObject:message];
                }
                int weiduNum=0;
                for (MessageOfMessageCenter *msg in _myapp.messages) {
                    if (msg.isRead==NO) {
                        weiduNum++;
                    }
                }
                for (HomeFuncItem *item in _funcView.subviews) {
                    if (item.tag==6) {
                        [item showMessagenumberWihtNumber:weiduNum];
                    }
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.debugDescription);
        }];
//    }
    
}

-(void)getallboxes
{
    NSString *myboxesstr=[MessageFormat allboxWithusername:_myapp.user.ID];
    [MessageFormat sendMessage:myboxesstr socketDelegate:self tag:1];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    [_changeTimer invalidate];
    _changeTimer = nil;
    _timer=nil;
}

-(void)getairvalue
{
    if (_myapp.boxes.count>0) {
        Airbox *box=_myapp.currentbox?_myapp.currentbox:_myapp.boxes[0];
        NSString *airvalue=[MessageFormat airvalueWithboxID:box.ID];
        [MessageFormat sendMessage:airvalue socketDelegate:self tag:2];
    }else
    {
        
    }
}
/**
 *  请求气象数据
 */
-(void)getHomeValue{
    NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
    NSString *httpArg = @"city=chengdu";
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
        [request setHTTPMethod: @"GET"];
        [request addValue: @"18b27bebfa12d8e2da7cee5cde1772ae" forHTTPHeaderField: @"apikey"];
        [NSURLConnection sendAsynchronousRequest: request
                                           queue: [NSOperationQueue mainQueue]
                               completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
//                                       NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                                   } else {
                                       NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                       NSLog(@"%@",responseString);
                                       NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
                                       NSArray * arr = dict[@"HeWeather data service 3.0"];
                                       for (NSDictionary * tempD in arr) {
                                           NSDictionary * tempDict = tempD[@"aqi"];
                                           NSDictionary * pmD = tempDict[@"city"];
                                           NSString * pmStr = pmD[@"pm25"];
                                           NSLog(@"%@",pmStr);
                                           _airvalueview.pmValueLabel.text = pmStr;
                                           
                                           NSArray * tempArr = tempD[@"hourly_forecast"];
                                           NSLog(@"%@",tempArr);
                                           for (NSDictionary * dic in tempArr) {
                                               NSString * humStr = dic[@"hum"];
                                               NSLog(@"hum=%@",humStr);
                                               _airvalueview.humidityValueLabel.text = humStr;
                                               NSString * temStr = dic[@"tmp"];
                                               NSLog(@"tem=%@",temStr);
                                               _airvalueview.tempertureValueLabel.text = temStr;
                                           }
                                           
                                       }
                                   }
                               }];
}

-(void)createsubviews
{
    self.view.backgroundColor=UIColorFromRGB(0xef2f2f);
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat screenheight=self.view.frame.size.height;
    CGFloat customheight=screenheight-STATUSBAR_HEIGHT-TOOLBAR_HEIGHT;
    
    //标题栏
    UIView *titlebar=[[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, screenwidth, 48.0)];
    UIImageView * navBgImv = [[UIImageView alloc]initWithFrame:titlebar.bounds];
    navBgImv.image = [UIImage imageNamed:@"newyear_nav_bj"];
    [self.view addSubview:titlebar];
    [titlebar addSubview:navBgImv];

    UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,200, titlebar.frame.size.height)];
    titleLab.center=CGPointMake(screenwidth/2, titlebar.frame.size.height/2);
    titleLab.text=@"一生约";
    titleLab.textAlignment= NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont boldSystemFontOfSize:22];
    [titlebar addSubview:titleLab];
    CGFloat menuButtonWidth=50.0;
    CGFloat menuButtonHeight=30.0;
    
    UIButton *menuBtn=[[UIButton alloc] initWithFrame:CGRectMake(10,(TOOLBAR_HEIGHT-menuButtonHeight)/2, menuButtonWidth,menuButtonHeight)];
    menuBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    menuBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    [menuBtn setImage:[UIImage imageNamed:@"home_menu.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(showmenu) forControlEvents:UIControlEventTouchUpInside];
    [titlebar addSubview:menuBtn];
    
    CGFloat smartButtonWidth = 70.0;
    CGFloat smartButtonHeight = 25.0;
    UIButton *smartcontrolBtn=[[UIButton alloc] initWithFrame:CGRectMake(screenwidth-10-smartButtonWidth,(TOOLBAR_HEIGHT-smartButtonHeight)/2, smartButtonWidth,smartButtonHeight)];
    [smartcontrolBtn setTitle:@"智能控制" forState:UIControlStateNormal];
    [smartcontrolBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [smartcontrolBtn addTarget:self action:@selector(gotosmartcontrol) forControlEvents:UIControlEventTouchUpInside];
    smartcontrolBtn.backgroundColor=[UIColor whiteColor];
    smartcontrolBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [smartcontrolBtn setCircleCorner];
    [titlebar addSubview:smartcontrolBtn];
    
    //空气质量显示
    _changeTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changeFormaldehydeValue) userInfo:nil repeats:YES];
    _airvalueview=[[UINib nibWithNibName:@"HomeAirvalueView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _airvalueview.frame=CGRectMake(0,STATUSBAR_HEIGHT+TOOLBAR_HEIGHT,screenwidth, customheight*0.3);
    [self.view addSubview:_airvalueview];
    
    //视频播放
    playerview=[[UIView alloc] initWithFrame:CGRectMake(0, _airvalueview.frame.size.height+_airvalueview.frame.origin.y, screenwidth, screenwidth * 296/640)];
    [self.view addSubview:playerview];
    
    UIImageView *playerbackground=[[UIImageView alloc] initWithFrame:playerview.bounds];
    playerbackground.image=[UIImage imageNamed:@"home_playVideo_background"];
    [playerview addSubview:playerbackground];
    
    CGFloat playBtnWidth = 50.0;
    CGFloat playBtnHeight = 50.0;
    UIButton *playBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0,playBtnWidth , playBtnHeight)];
    playBtn.center=CGPointMake(playerview.frame.size.width/2, playerview.frame.size.height/2);
    [playBtn setImage:[UIImage imageNamed:@"home_playbutton"] forState:UIControlStateNormal];
    playBtn.tag=7;
    [playBtn addTarget:self action:@selector(playvideo:) forControlEvents:UIControlEventTouchUpInside];
    [playerview addSubview:playBtn];
    
    CGFloat playLabheight=20;
    UILabel *playLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenwidth, playLabheight)];
    playLab.center=CGPointMake(screenwidth/2, playBtn.center.y+playBtnWidth/2+playLabheight/2);
    playLab.textAlignment=NSTextAlignmentCenter;
    playLab.textColor=UIColorFromRGB(0xf7f7f7);
    playLab.text=@"您的未来生活";
    playLab.font=[UIFont systemFontOfSize:13];
    [playerview addSubview:playLab];
    //6个功能按钮
    _funcView=[[HomeFuncView alloc] initWithFrame:CGRectMake(0, playerview.frame.origin.y+playerview.frame.size.height, screenwidth, screenheight-(playerview.frame.origin.y+playerview.frame.size.height))];
    [self.view addSubview:_funcView];
    
    //6个按钮的响应
    __block NSArray *poststrings = _poststrings;
    __block HomeController *controller=self;
    [_funcView setIntroduceblock:^(int tag){
        UIStoryboard *autolaytoustorboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
        IntroduceController *intro=[autolaytoustorboard instantiateViewControllerWithIdentifier:@"introducecontroller"];
        long index=tag-1;
        intro.poststring=poststrings[index];
        [intro initcontent];
        intro.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [controller presentViewController:intro animated:YES completion:nil];
    }];
    
    [_funcView setMapblock:^(int tag){
//        NSString *url= [NSString stringWithFormat:@"%@",poststrings[tag-1]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url URLEncodedString]]];
        MapviewController *map=[[MapviewController alloc] init];
        map.urlstring=[NSString stringWithFormat:@"%@",poststrings[tag-1]];
        map.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [controller presentViewController:map animated:YES completion:nil];
    }];
    
    [_funcView setKanfangblock:^(int tag){
        UIStoryboard *autolaytoustorboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
        KanfangController *kanfang=[autolaytoustorboard instantiateViewControllerWithIdentifier:@"kanfangcontroller"];
        kanfang.postURL=poststrings[tag-1];
        kanfang.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [controller presentViewController:kanfang animated:YES completion:nil];
    }];
    
    [_funcView setMessagecenterblock:^(int tag){
        UIStoryboard *autolaytoustorboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
        
        UINavigationController *nav=[autolaytoustorboard instantiateViewControllerWithIdentifier:@"messagecenternavcontroller"];
        MessageCenterController *messagecenter=(MessageCenterController *)nav.topViewController;
        messagecenter.postURL=poststrings[tag-1];
        nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [controller presentViewController:nav animated:YES completion:nil];
    }];
    
    //电话按钮
    CGFloat phonecallBtnWidth=screenwidth/5;
    CGFloat phoneCallBtnHeight = phonecallBtnWidth * (14/9);
    UIButton *phonecallBtn=[[UIButton alloc] initWithFrame:CGRectMake(screenwidth*4/5, playerview.frame.origin.y, phonecallBtnWidth, phoneCallBtnHeight)];
    [phonecallBtn setImage:[UIImage imageNamed:@"home_btn_phone.png"] forState:UIControlStateNormal];
    phonecallBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [phonecallBtn addTarget:self action:@selector(phonecall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phonecallBtn];
    
}



-(void)showmenu
{
    if (![self isuser]) {
        return;
    }
    [self.frostedViewController presentMenuViewController];
}

-(void)gotosmartcontrol
{
    if (![self isuser]) {
        
        return;
    }
    BoxhomepageController *boxhomepage=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"boxhomepagecontroller"];
    [self.frostedViewController presentViewController:boxhomepage animated:YES completion:nil];
}

-(BOOL)isuser{
    if (_myapp.user) {
        return YES;
    }
    
    __block UIView *view=[[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor=[UIColor darkGrayColor];
    view.alpha=0.8;
    [self.view addSubview:view];
    
    LoginDialog *logindlg=[[UINib nibWithNibName:@"LoginDialog" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    logindlg.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:logindlg];
    
    logindlg.phoneNumTxt.delegate=self;
    logindlg.passwordTxt.delegate=self;
    [logindlg setDismissblock:^{
        [view removeFromSuperview];
        view=nil;
    }];
    [logindlg setRegisterblock:^{
        UIStoryboard *mainstoryboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
        UINavigationController *registerview=[mainstoryboard instantiateViewControllerWithIdentifier:@"registernavcontroller"];
        [registerview setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self.frostedViewController presentViewController:registerview animated:YES completion:nil];

    }];
    [logindlg setLoginblock:^(NSString *username, NSString *password) {
        [self pleaseWaitInView:self.view];
        
        [[AFAppDotNetAPIClient sharedClient] POST:Login.URLEncodedString parameters:@{@"Tel":username,@"PassWord":[DES3Util encrypt:password]} success:^(NSURLSessionDataTask *task, id responseObject) {
            [self endWaiting];
            NSNumber *statuscode=responseObject[@"code"];
            
            if (statuscode.intValue==0) {
                _myapp.user=[YSYUser userWihtDict:responseObject[@"data"]];
                [self buquanuserinfo];
            } else {
                [MessageFormat hintWithMessage:(NSString *)responseObject[@"message"] inview:self.view completion:nil];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self endWaiting];
            NSLog(@"%@",error.debugDescription);
        }];
        
    }];
    
    return NO;
}

-(void)buquanuserinfo
{
    
    [self viewWillAppear:YES];
    [self getallboxes];

    _myapp.familymembers=[NSMutableArray array];
    _myapp.boxes=[NSMutableArray array];
    _myapp.messages=[NSMutableArray array];
    
    if (_myapp.user) {
        [[AFAppDotNetAPIClient sharedClient] POST:FamilyList.URLEncodedString parameters:@{@"UserId":_myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
            NSNumber *statuscode=responseObject[@"code"];
            if (statuscode.intValue==0) {
                NSArray *array=responseObject[@"data"];
                for (NSDictionary *dict in array) {
                    FamilyMember *member=[FamilyMember memberWithDict:dict];
                    [_myapp.familymembers addObject:member];
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.debugDescription);
        }];
    }
}

-(void)phonecall
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否拨打售房中心电话"delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
}

-(void)playvideo:(UIButton *)sender
{
    PlayerController *player=[[PlayerController alloc] init];
    player.postURL=_poststrings[sender.tag-1];
    [self presentViewController:player animated:YES completion:^{
        
    }];
}

-(void)checkUpdate
{
    [[AFAppDotNetAPIClient sharedClient] POST:CheckVersion parameters:@{@"AppId":@"2",@"Version":[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSDictionary *d=responseObject[@"data"];
            NSNumber *type=d[@"Type"];
            if (type.intValue==1) {//强制更新
                UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"发现新版本" message:@"马上更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alertview.tag=MUST_TAG;
                [alertview show];
            } else {//不强制更新
                UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"发现新版本" message:@"是否更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alertview.tag=NORMAL_TAG;
                [alertview show];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark - XML解析代理方法
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentXMLtag=elementName;
    if ([elementName isEqualToString:@"para"]) {
        _XMLAction=attributeDict[@"action"];
        if ([_XMLAction isEqualToString:@"allbox"]) {
            [_myapp.boxes removeAllObjects];
        }
    }
    if ([_XMLAction isEqualToString:@"allbox"]&&[elementName isEqualToString:@"boxid"]) {
        _currentXMLtagAttr=attributeDict[@"name"];
    }
}

//-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
//{
//    if ([_XMLAction isEqualToString:@"request"]) {
//        if ([_currentXMLtag isEqualToString:@"temp"]) {
//            _airvalueview.wenduNum.text=string;
//            if (string.floatValue<16 || (string.floatValue>=27 && string.floatValue<=35)) {
//                _airvalueview.wenduImg.image=CHAOBIAO_IMAGE;
//                _airvalueview.wenduState.text=CHAOBIAO_STRING;
//            }else if (string.floatValue>=16 && string.floatValue<27) {
//                _airvalueview.wenduImg.image=SHUSHI_IMAGE;
//                _airvalueview.wenduState.text=SHUSHI_STRING;
//            }else{
//                _airvalueview.wenduImg.image=WEIXIAN_IMAGE;
//                _airvalueview.wenduState.text=WEIXIAN_STRING;
//            }
//        }
//        if ([_currentXMLtag isEqualToString:@"humidity"]) {
//            _airvalueview.shiduNum.text=string;
//            if (string.floatValue>75 || string.floatValue<45) {
//                _airvalueview.shiduImg.image=WEIXIAN_IMAGE;
//                _airvalueview.shiduState.text=WEIXIAN_STRING;
//            }else {
//                _airvalueview.shiduImg.image=SHUSHI_IMAGE;
//                _airvalueview.shiduState.text=SHUSHI_STRING;
//            }
//        }
//        if ([_currentXMLtag isEqualToString:@"pm25"]) {
//            _airvalueview.pm25Num.text=string;
//            if (string.floatValue<=75) {
//                _airvalueview.pm25Img.image=SHUSHI_IMAGE;
//                _airvalueview.pm25State.text=SHUSHI_STRING;
//            }else if (string.floatValue<=150) {
//                _airvalueview.pm25Img.image=CHAOBIAO_IMAGE;
//                _airvalueview.pm25State.text=CHAOBIAO_STRING;
//            }else{
//                _airvalueview.pm25Img.image=WEIXIAN_IMAGE;
//                _airvalueview.pm25State.text=WEIXIAN_STRING;
//            }        }
//        if ([_currentXMLtag isEqualToString:@"hcho"]) {
//            _airvalueview.jiaquanNum.text=string;
//            if (string.floatValue<0.08) {
//                _airvalueview.jiaquanImg.image=SHUSHI_IMAGE;
//                _airvalueview.jiaquanState.text=SHUSHI_STRING;
//            }else {
//                _airvalueview.jiaquanImg.image=WEIXIAN_IMAGE;
//                _airvalueview.jiaquanState.text=WEIXIAN_STRING;
//            }
//        }
//    }
//    
//    if ([_XMLAction isEqualToString:@"allbox"]) {
//        if ([_currentXMLtag isEqualToString:@"boxid"]&&![string isEqualToString:@"NULL"]) {
//            Airbox *box=[Airbox boxWithName:[_currentXMLtagAttr isEqualToString:@"null"]?@"未命名":_currentXMLtagAttr ID:string];
//            [_myapp.boxes addObject:box];
//        }
//    }
//}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([_XMLAction isEqualToString:@"allbox"]) {
        if (_myapp.boxes.count<1) {
            _myapp.currentbox=nil;
        }else{
            _myapp.currentbox=_myapp.boxes[0];
            
            if (_timer==nil) {
                _timer=[NSTimer scheduledTimerWithTimeInterval:AIRVALUE_REFRESH_TIME target:self selector:@selector(getairvalue) userInfo:nil repeats:YES];
            }
            [_timer fire];
        }
    }

    _XMLAction=nil;
}


#pragma mark - UITextField的代理方法

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame =CGRectMake(textField.superview.frame.origin.x+textField.frame.origin.x, textField.superview.frame.origin.y+textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height);
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

#pragma mark - JMHoledView代理方法
-(void)holedView:(JMHoledView *)holedView didSelectHoleAtIndex:(NSUInteger)index
{
    NSLog(@"%lu",index);
    [holedView removeFromSuperview];
    _holedview=nil;
}

#pragma mark - UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==MUST_TAG || (alertView.tag==NORMAL_TAG && buttonIndex==1)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
        assert(alertView.tag!=MUST_TAG);
    }else if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PHONECALL_SALEHOUSE]];
    }
    
    [alertView removeFromSuperview];
    alertView=nil;
}
/**
 * 变更甲醛
 */
- (void)changeFormaldehydeValue{
    double random = [self getRandomNumber:1 to:12] * 100 / 100.0;
//    NSLog(@"random %f",random);
    NSString * str = [NSString stringWithFormat:@"%.2f",random / 100.0];
    _airvalueview.formaldehydeValueLabel.text = str;
//    NSLog(@"str %@",str);
}

-(int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}
@end
