//
//  AirvalueController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/6/11.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AirvalueController.h"
#import "HMSegmentedControl.h"
#import "Mydefine.h"
#import "UIButton+Rectbutton.h"
#import "CircleProgressView.h"
#import "MyAirvalueTabbar.h"
#import "SmartControlCollectionViewController.h"
#import "AirvaluePageItem.h"
#import "AppDelegate.h"
#import "MessageFormat.h"


#define PM25_BEST_COLOR MAIN_COLOR_VALUE
#define PM25_MILD_POLLUTION_COLOR 0xfff799
#define PM25_MODERATE_POLLUTION_COLOR 0xf8b551
#define PM25_SEVERE_POLLUTION_COLOR 0xe60012
#define PM25_SERIOUS_POLLUTION_COLOR 0xa40000

@interface AirvalueController()<UIScrollViewDelegate,NSXMLParserDelegate>
{
    NSTimer *_timer;
    NSString *_currentXMLtag;
    NSString *_currentXMLtagAttr;
    NSString *_XMLAction;
    AppDelegate *_myapp;
}

@property(retain,nonatomic)MyAirvalueTabbar *tabbar;
@property(retain,nonatomic)UIScrollView *scrollview;

@property(retain,nonatomic)AirvaluePageItem *pm25view;
@property(retain,nonatomic)AirvaluePageItem *jiaquanview;
@property(retain,nonatomic)AirvaluePageItem *wenduview;
@property(retain,nonatomic)AirvaluePageItem *shiduview;

@end


@implementation AirvalueController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addsubviews];
    self.view.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    
    _myapp=[UIApplication sharedApplication].delegate;
    
    [self.tabbar setSelectedItemindex:self.pageindex];
    self.scrollview.contentOffset=CGPointMake(self.view.frame.size.width*self.pageindex, 0);
    
    switch (_pageindex) {
        case 0:
        {
            [self updatepm25Withstring:_defaultpagescore];
            break;
        }
        case 1:
        {
            [self updatejiaquanWithstring:_defaultpagescore];
            break;
        }
        case 2:
        {
            [self updatewenduWithstring:_defaultpagescore];
            break;
        }
        case 3:
        {
            [self updateshiduWithstring:_defaultpagescore];
            break;
        }
        default:
            break;
    }
}
-(void)addsubviews
{
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat screenheight=self.view.frame.size.height;
    
    UIView *titlebar=[[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, screenwidth, TOOLBAR_HEIGHT)];
    titlebar.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    [self.view addSubview:titlebar];
    
    UILabel *titleLab=[[UILabel alloc] initWithFrame:titlebar.bounds];
    titleLab.text=self.boxname;
    titleLab.textColor=[UIColor whiteColor];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.lineBreakMode=NSLineBreakByCharWrapping;
    titleLab.font=[UIFont systemFontOfSize:TITLEBAR_FONT_SIZE];
    [titlebar addSubview:titleLab];
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(8, 10.5, 60, 23)];
    backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -45, 0, 0);
    backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [backBtn setImage:[UIImage imageNamed:@"navback_white.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [titlebar addSubview:backBtn];
    
    
    _tabbar=[[MyAirvalueTabbar alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+TOOLBAR_HEIGHT, screenwidth, TABBAR_HEIGHT+20)];
    [self.view addSubview:_tabbar];
    
    
    CGFloat bottomviewheight=62;
    CGFloat scrollviewY=STATUSBAR_HEIGHT+TOOLBAR_HEIGHT+_tabbar.frame.size.height;
    CGFloat scrollheight=screenheight-scrollviewY-bottomviewheight;
    _scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollviewY, screenwidth, scrollheight)];
    _scrollview.backgroundColor=UIColorFromRGB(0xefefef);
    _scrollview.pagingEnabled=YES;
    _scrollview.delegate=self;
    _scrollview.showsHorizontalScrollIndicator=NO;
    _scrollview.contentSize=CGSizeMake(screenwidth*4, scrollheight);
    _scrollview.bounces=NO;
    [self.view addSubview:_scrollview];
    
    __block AirvalueController *controller=self;
    [_tabbar setSelectedChangedblock:^(int index) {
        [UIView animateWithDuration:0.3 animations:^{
            controller.scrollview.contentOffset=CGPointMake(screenwidth*index, 0);
        } completion:nil];
    }];
    
    //pm25页面
    _pm25view=[[AirvaluePageItem alloc] initWithFrame:_scrollview.bounds string:@"最佳系数：0-75" maxNumber:200.0 isJiaquan:NO];
    _pm25view.backgroundColor=_scrollview.backgroundColor;

    [_pm25view setScore:200.0];
    [_scrollview addSubview:_pm25view];
    
    
    //甲醛页面
    _jiaquanview=[[AirvaluePageItem alloc] initWithFrame:CGRectMake(screenwidth, 0, screenwidth, scrollheight) string:@"标准值≤0.08" maxNumber:0.2 isJiaquan:YES];
    _jiaquanview.backgroundColor=_scrollview.backgroundColor;

    [_jiaquanview setScore:0.2];
    [_scrollview addSubview:_jiaquanview];
    
    //温度页面
    _wenduview=[[AirvaluePageItem alloc] initWithFrame:CGRectMake(screenwidth*2, 0, screenwidth, scrollheight) string:@"舒适温度：16-26°C" maxNumber:50.0 isJiaquan:NO];
    _wenduview.backgroundColor=_scrollview.backgroundColor;

    [_wenduview setScore:50.0];
    [_scrollview addSubview:_wenduview];
    
    //湿度页面
    _shiduview=[[AirvaluePageItem alloc] initWithFrame:CGRectMake(screenwidth*3, 0, screenwidth, scrollheight) string:@"舒适系数：45-75" maxNumber:100.0 isJiaquan:NO];
    _shiduview.backgroundColor=_scrollview.backgroundColor;

    [_shiduview setScore:100.0];
    [_scrollview addSubview:_shiduview];
    
    //底部
    UIView *bottomview=[[UIView alloc] initWithFrame:CGRectMake(0, screenheight-bottomviewheight, screenwidth, bottomviewheight)];
    bottomview.backgroundColor=_scrollview.backgroundColor;
    [self.view addSubview:bottomview];
    
//    UIImageView *bottomfenge=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, 2)];
//    bottomfenge.backgroundColor=[UIColor blackColor];
//    [bottomview addSubview:bottomfenge];
    
    UIButton *smartcontrolBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenwidth/2, 40)];
    smartcontrolBtn.backgroundColor=titlebar.backgroundColor;
    [smartcontrolBtn setTitle:@"智能控制" forState:UIControlStateNormal];
    [smartcontrolBtn setcornerRadius:20];
    smartcontrolBtn.center=CGPointMake(screenwidth/2, bottomviewheight/2);
    [bottomview addSubview:smartcontrolBtn];
    [smartcontrolBtn addTarget:self action:@selector(gotoSmartcontrol:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_timer==nil) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:AIRVALUE_REFRESH_TIME target:self selector:@selector(getairvalue) userInfo:nil repeats:YES];
    }
    [_timer fire];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer=nil;
}


-(void)getairvalue
{
    if (_myapp.currentbox) {
        NSString *airvalue=[MessageFormat airvalueWithboxID:_myapp.currentbox.ID];
        [MessageFormat sendMessage:airvalue socketDelegate:self tag:2];
    }
}


-(void)goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gotoSmartcontrol:(id)sender {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
    UINavigationController *smartcontrol= [mainStoryboard instantiateViewControllerWithIdentifier:@"smartcontrolviewcontroller"];
    [smartcontrol setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:smartcontrol animated:YES completion:nil];
}

#pragma mark UIScrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    if ((int)scrollView.contentOffset.x%(int)self.view.frame.size.width==0) {
        [_tabbar setSelectedItemindex:(int)scrollView.contentOffset.x/(int)self.view.frame.size.width];
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
   NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}

#pragma mark XML解析代理方法

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentXMLtag=elementName;
    if ([elementName isEqualToString:@"para"]) {
        _XMLAction=attributeDict[@"action"];
    }
    if ([_XMLAction isEqualToString:@"allbox"]&&[elementName isEqualToString:@"boxid"]) {
        _currentXMLtagAttr=attributeDict[@"name"];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
        if ([_currentXMLtag isEqualToString:@"temp"]) {
            [self updatewenduWithstring:string];
        }
        if ([_currentXMLtag isEqualToString:@"humidity"]) {
            [self updateshiduWithstring:string];
        }
        if ([_currentXMLtag isEqualToString:@"pm25"]) {
            [self updatepm25Withstring:string];
        }
        if ([_currentXMLtag isEqualToString:@"hcho"]) {
            [self updatejiaquanWithstring:string];
        }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    _XMLAction=nil;
}

#pragma mark -
-(void)updatepm25Withstring:(NSString *)string
{
    float score=[string floatValue];
    [self.pm25view setScore:score];
    if (score<=75) {
        [self.pm25view updatelevelWithLevelstring:@"优" image:[UIImage imageNamed:@"xiaolian_grey.png"] color:UIColorFromRGB(PM25_BEST_COLOR)];
        [self.pm25view setHintString:@"哈哈，空气好就是任性！" colorRange:NSMakeRange(0, 0)];
    }else if (score<=115){
        [self.pm25view updatelevelWithLevelstring:@"良" image:[UIImage imageNamed:@"xiaolian_grey.png"] color:UIColorFromRGB(PM25_MILD_POLLUTION_COLOR)];
        [self.pm25view setHintString:@"报告首长，暂时不用为人民服雾（霾）。" colorRange:NSMakeRange(0, 0)];
    }else if (score<=150){
        [self.pm25view updatelevelWithLevelstring:@"轻度" image:[UIImage imageNamed:@"xiaolian_grey.png"] color:UIColorFromRGB(PM25_MODERATE_POLLUTION_COLOR)];
        [self.pm25view setHintString:@"空气太槽，该收拾收拾pm2.5这坏小子了！" colorRange:NSMakeRange(0, 0)];
    }else if (score<=250){
        [self.pm25view updatelevelWithLevelstring:@"中度" image:[UIImage imageNamed:@"kulian_grey.png"] color:UIColorFromRGB(PM25_SEVERE_POLLUTION_COLOR)];
        [self.pm25view setHintString:@"空气太槽，该收拾收拾pm2.5这坏小子了！" colorRange:NSMakeRange(0, 0)];
    }else if (score<500){
        [self.pm25view updatelevelWithLevelstring:@"重度" image:[UIImage imageNamed:@"kulian_grey.png"] color:UIColorFromRGB(PM25_SERIOUS_POLLUTION_COLOR)];
        [self.pm25view setHintString:@"空气太槽，该收拾收拾pm2.5这坏小子了！" colorRange:NSMakeRange(0, 0)];
    }else{
        [self.pm25view updatelevelWithLevelstring:@"严重" image:[UIImage imageNamed:@"kulian_grey.png"] color:UIColorFromRGB(PM25_SERIOUS_POLLUTION_COLOR)];
        [self.pm25view setHintString:@"空气太槽，该收拾收拾pm2.5这坏小子了！" colorRange:NSMakeRange(0, 0)];
    }
}
-(void)updatejiaquanWithstring:(NSString *)string
{
    float score=[string floatValue];
    [self.jiaquanview setScore:score];
    if (score<0.08) {
        [self.jiaquanview updatelevelWithLevelstring:@"优" image:[UIImage imageNamed:@"xiaolian_grey.png"] color:UIColorFromRGB(PM25_BEST_COLOR)];
        [self.jiaquanview setHintString:@"空气不错，一起做个森呼吸吧！" colorRange:NSMakeRange(0, 0)];
    }else{
        [self.jiaquanview updatelevelWithLevelstring:@"差" image:[UIImage imageNamed:@"kulian_grey.png"] color:UIColorFromRGB(PM25_SERIOUS_POLLUTION_COLOR)];
        [self.jiaquanview setHintString:@"OMG，我不要这样的醛世界！" colorRange:NSMakeRange(0, 0)];
    }
}
-(void)updatewenduWithstring:(NSString *)string
{
    float score=[string floatValue];
    [self.wenduview setScore:score];
    if (score<=0) {
        [self.wenduview updatelevelWithLevelstring:@"冷" image:[UIImage imageNamed:@"kulian_grey.png"] color:UIColorFromRGB(PM25_MODERATE_POLLUTION_COLOR)];
        [self.wenduview setHintString:@"好冷呀~~求温暖！求拥抱！" colorRange:NSMakeRange(0, 0)];
    }else if (score<16){
        [self.wenduview updatelevelWithLevelstring:@"凉" image:[UIImage imageNamed:@"xiaolian_grey.png"] color:UIColorFromRGB(PM25_MODERATE_POLLUTION_COLOR)];
        [self.wenduview setHintString:@"好冷呀~~求温暖！求拥抱！" colorRange:NSMakeRange(0, 0)];
    }else if (score<=26){
        [self.wenduview updatelevelWithLevelstring:@"舒适" image:[UIImage imageNamed:@"xiaolian_grey.png"] color:UIColorFromRGB(PM25_BEST_COLOR)];
        [self.wenduview setHintString:@"嗯哼~舒适的温度心情美美哒！" colorRange:NSMakeRange(0, 0)];
    }else if (score<=35){
        [self.wenduview updatelevelWithLevelstring:@"热" image:[UIImage imageNamed:@"kulian_grey.png"] color:UIColorFromRGB(PM25_MODERATE_POLLUTION_COLOR)];
        [self.wenduview setHintString:@"热得心跳加速了，降温让自己冷静一下吧！" colorRange:NSMakeRange(0, 0)];
    }else if (score<=40){
        [self.wenduview updatelevelWithLevelstring:@"很热" image:[UIImage imageNamed:@"kulian_grey.png"] color:UIColorFromRGB(PM25_SEVERE_POLLUTION_COLOR)];
        [self.wenduview setHintString:@"热得心跳加速了，降温让自己冷静一下吧！" colorRange:NSMakeRange(0, 0)];
    }else if (score<=50){
        [self.wenduview updatelevelWithLevelstring:@"太热了" image:[UIImage imageNamed:@"kulian_grey.png"] color:UIColorFromRGB(PM25_SERIOUS_POLLUTION_COLOR)];
        [self.wenduview setHintString:@"热得心跳加速了，降温让自己冷静一下吧！" colorRange:NSMakeRange(0, 0)];
    }else {
        [self.wenduview updatelevelWithLevelstring:@"热疯了" image:[UIImage imageNamed:@"kulian_grey.png"] color:UIColorFromRGB(PM25_SERIOUS_POLLUTION_COLOR)];
        [self.wenduview setHintString:@"热得心跳加速了，降温让自己冷静一下吧！" colorRange:NSMakeRange(0, 0)];
    }
}

-(void)updateshiduWithstring:(NSString *)string
{
    float score=[string floatValue];
    [self.shiduview setScore:score];
    if (score<45) {
        [self.shiduview updatelevelWithLevelstring:@"干燥" image:[UIImage imageNamed:@"kulian_grey.png"] color:UIColorFromRGB(PM25_MODERATE_POLLUTION_COLOR)];
        [self.shiduview setHintString:@"悄悄告诉你，太干燥，病菌会长很快哦~。" colorRange:NSMakeRange(0, 0)];
    }else if (score<=75){
        [self.shiduview updatelevelWithLevelstring:@"舒适" image:[UIImage imageNamed:@"xiaolian_grey.png"] color:UIColorFromRGB(PM25_BEST_COLOR)];
        [self.shiduview setHintString:@"嗨，家里湿度还不错哦~" colorRange:NSMakeRange(0, 0)];
    }else {
        [self.shiduview updatelevelWithLevelstring:@"潮湿" image:[UIImage imageNamed:@"kulian_grey.png"] color:UIColorFromRGB(PM25_MODERATE_POLLUTION_COLOR)];
        [self.shiduview setHintString:@"啊哦~真的要变湿人了…" colorRange:NSMakeRange(0, 0)];
    }
}
@end
