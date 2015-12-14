//
//  BoxhomepageController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/6/11.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "BoxhomepageController.h"
#import "Mydefine.h"
#import "AirvalueController.h"
#import "ChooseboxView.h"
#import "AirboxConfigStep1ViewController.h"
#import "AppDelegate.h"
#import "WKAlertView.h"
#import "MessageFormat.h"
#import "UIWindow+YUBottomPoper.h"
#import "MyInputView.h"
#import "AirboxConfigErrorViewController.h"
#import "AirboxConfigStep4ViewController.h"
#import "JGProgressHUD.h"
#import "UIViewController+ActivityHUD.h"

@interface BoxhomepageController()<NSXMLParserDelegate,ChooseboxViewDelegate,NSURLConnectionDataDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    NSString *_currentXMLtag;
    NSString *_currentXMLtagAttr;
    NSString *_XMLAction;
//    UIWindow *_warningWin;
    
    NSTimer *_timer;
    NSMutableData  *_shiwaiairvalue;
    NSMutableData  *_pm25data;
    
    NSURLConnection *_temperature;
    NSURLConnection *_pm25;
    
    UIWindow *_warningWin;
    AppDelegate *_myapp;
    
    NSString *_temboxid;
//    JGProgressHUD *_activityHUD;
}

@property (retain, nonatomic)  ChooseboxView               * boxlistview;
@end

@implementation BoxhomepageController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _myapp=[UIApplication sharedApplication].delegate;
    self.view.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.titleBar.backgroundColor=self.view.backgroundColor;
    self.outsideAirvalueView.backgroundColor=self.view.backgroundColor;
    self.outsideTianqiView.backgroundColor=self.view.backgroundColor;
    self.homeBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;

    
    self.boxlistview=[[ChooseboxView alloc] initWithFrame:CGRectMake(0,0,150.0,200.0) items:_myapp.boxes];
    self.boxlistview.center=CGPointMake(self.view.frame.size.width/2, STATUSBAR_HEIGHT+TOOLBAR_HEIGHT+100);
    [self.view addSubview:self.boxlistview];
    [self.view bringSubviewToFront:self.boxlistview];
    
    __block BoxhomepageController *controller = self;
    [self.boxlistview setChooseboxblock:^(int boxindex) {
        [controller changebox:boxindex];
        [controller choosebox];
    }];
    self.boxlistview.hidden=YES;
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideList)];
    [self.view addGestureRecognizer:tapgesture];
    tapgesture.delegate=self;
    
    UITapGestureRecognizer *titleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosebox)];
    self.titleLab.userInteractionEnabled=YES;
    [self.titleLab addGestureRecognizer:titleTap];
    
    UITapGestureRecognizer *chooseboxTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosebox)];
    self.chooseboxImg.userInteractionEnabled=YES;
    [self.chooseboxImg addGestureRecognizer:chooseboxTap];
    
    [self requestOutsideAirvalue];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshbox];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.pm25Lab.font=[UIFont systemFontOfSize:self.pm25Lab.frame.size.height/21*12];
    self.pm25NumLab.font=[UIFont systemFontOfSize:self.pm25NumLab.frame.size.height/26*30];
    
    self.jiaquanLab.font=self.pm25Lab.font;
    self.jiaquanNumLab.font=self.pm25NumLab.font;
    
    self.shiduLab.font=self.pm25Lab.font;
    self.shiduNumLab.font=self.pm25NumLab.font;
    
    self.wenduLab.font=self.pm25Lab.font;
    self.wenduNumLab.font=self.pm25NumLab.font;
    
    [self addgestures];
    [self.view bringSubviewToFront:self.boxlistview];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer=nil;
}


#pragma mark -

-(void)addgestures
{
    for (UIView *view in self.circleview.subviews) {
        if (view.tag!=0) {
            UITapGestureRecognizer *pm25NumLabTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoairvaluepage:)];
            view.userInteractionEnabled=YES;
            [view addGestureRecognizer:pm25NumLabTap];
        }
    }
    
}

-(void)gotoairvaluepage:(UITapGestureRecognizer *)gesture
{
    if (_titleLab.text.length<1) {
        return;
    }
    NSLog(@"%ld",(long)gesture.view.tag);
    AirvalueController *airvaluecontroller=[[AirvalueController alloc] init];
    airvaluecontroller.pageindex=(int)gesture.view.tag-1;
    airvaluecontroller.boxname=self.titleLab.text;
    switch (gesture.view.tag) {
        case 1:
        {
            airvaluecontroller.defaultpagescore=self.pm25NumLab.text;
            break;
        }
        case 2:
        {
            airvaluecontroller.defaultpagescore=self.jiaquanNumLab.text;
            break;
        }
        case 3:
        {
            airvaluecontroller.defaultpagescore=self.wenduNumLab.text;
            break;
        }
        case 4:
        {
            airvaluecontroller.defaultpagescore=self.shiduNumLab.text;
            break;
        }
        default:
            break;
    }
    [airvaluecontroller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:airvaluecontroller animated:YES completion:nil];
}

- (void)configbox{
    self.boxlistview.hidden=YES;
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"YSY" bundle:nil];
    UINavigationController *config= [mainStoryboard instantiateViewControllerWithIdentifier:@"airboxconfig"];
    [config setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:config animated:YES completion:nil];
}


-(void)getairvalue
{
    if (_myapp.currentbox) {
        NSString *airvalue=[MessageFormat airvalueWithboxID:_myapp.currentbox.ID];
        [MessageFormat sendMessage:airvalue socketDelegate:self tag:2];
    }else
    {
        self.pm25NumLab.text=NO_DATA_STRING;
        self.wenduNumLab.text=NO_DATA_STRING;
        self.shiduNumLab.text=NO_DATA_STRING;
        self.jiaquanNumLab.text=NO_DATA_STRING;
        self.wenduColorImg.image=[UIImage imageNamed:@"WENDU_G.png"];
        self.wenduNumImg.image=[UIImage imageNamed:@"xiaolian.png"];
        self.shiduColorImg.image=[UIImage imageNamed:@"SHIDU_G.png"];
        self.shiduNumImg.image=[UIImage imageNamed:@"xiaolian.png"];
        self.pm25ColorImg.image=[UIImage imageNamed:@"PM25_G.png"];
        self.pm25NumImg.image=[UIImage imageNamed:@"xiaolian.png"];
        self.jiaquanColorImg.image=[UIImage imageNamed:@"JIAQUAN_G.png"];
        self.jiaquanNumImg.image=[UIImage imageNamed:@"xiaolian.png"];
    }
}

- (void)choosebox {
    self.boxlistview.hidden=!self.boxlistview.hidden;
}

- (IBAction)debindbox:(id)sender {
    _warningWin = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleWaring title:@"解除绑定" detail:@"是否解除绑定当前的盒子" canleButtonTitle:@"取消" okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
        
        //Window隐藏，并置为nil，释放内存 不能少
        _warningWin.hidden = YES;
        _warningWin = nil;
        
        if (buttonIndex==MyWindowClickForOK) {
            [MessageFormat sendMessage:[MessageFormat debindboxID:_myapp.currentbox.ID username:_myapp.user.ID] socketDelegate:self tag:1];
        }
        
    }];
}

-(void)changebox:(int)boxindex
{

    if (_myapp.boxes.count>0) {
        _myapp.currentbox=_myapp.boxes[boxindex];
        self.titleLab.text=_myapp.currentbox.name;
        [self getairvalue];
    }else{
        self.pm25NumLab.text=NO_DATA_STRING;
        self.wenduNumLab.text=NO_DATA_STRING;
        self.shiduNumLab.text=NO_DATA_STRING;
        self.jiaquanNumLab.text=NO_DATA_STRING;
        self.wenduColorImg.image=[UIImage imageNamed:@"WENDU_G.png"];
        self.wenduNumImg.image=[UIImage imageNamed:@"xiaolian.png"];
        self.shiduColorImg.image=[UIImage imageNamed:@"SHIDU_G.png"];
        self.shiduNumImg.image=[UIImage imageNamed:@"xiaolian.png"];
        self.pm25ColorImg.image=[UIImage imageNamed:@"PM25_G.png"];
        self.pm25NumImg.image=[UIImage imageNamed:@"xiaolian.png"];
        self.jiaquanColorImg.image=[UIImage imageNamed:@"JIAQUAN_G.png"];
        self.jiaquanNumImg.image=[UIImage imageNamed:@"xiaolian.png"];
        _myapp.currentbox=nil;
        self.titleLab.text=nil;
    }
}

-(void)getallboxes
{
    self.titleLab.text=nil;
    NSString *myboxesstr=[MessageFormat allboxWithusername:_myapp.user.ID];
    [MessageFormat sendMessage:myboxesstr socketDelegate:self tag:1];
}

-(void)requestOutsideAirvalue
{
    NSString *airstr=[NSString stringWithFormat:@"http://apis.haoservice.com/weather?cityname=遂宁&key=e0a65cb74ae242abae5e435581452e95"];
    airstr=[airstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *airurl=[NSURL URLWithString:airstr];
    NSURLRequest *request=[NSURLRequest requestWithURL:airurl];
    _temperature=[NSURLConnection connectionWithRequest:request delegate:self];
    if (_temperature) {
        _shiwaiairvalue=[NSMutableData data];
    }
    
    NSString *pm25str=[NSString stringWithFormat:@"http://apis.haoservice.com/air/cityair?city=遂宁&key=57c50880fb8a436187a578661cd88ae2"];
    pm25str=[pm25str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *pm25url=[NSURL URLWithString:pm25str];
    NSURLRequest *pm25request=[NSURLRequest requestWithURL:pm25url];
    _pm25=[NSURLConnection connectionWithRequest:pm25request delegate:self];
    if (_pm25) {
        _pm25data=[NSMutableData data];
    }
}



-(void)hideList
{
    self.boxlistview.hidden=YES;
}

- (IBAction)gotoHomepage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)refreshbox
{
    if (_myapp.currentbox==nil&&_myapp.boxes.count>0) {
        _myapp.currentbox=_myapp.boxes[0];
    }
    self.titleLab.text=[_myapp.currentbox.name isEqualToString:@"null"]?@"未命名":_myapp.currentbox.name;
    [self.boxlistview.tv reloadData];
    [_timer invalidate];
    _timer=nil;
    _timer=[NSTimer scheduledTimerWithTimeInterval:AIRVALUE_REFRESH_TIME target:self selector:@selector(getairvalue) userInfo:nil repeats:YES];
    
    [_timer fire];
}
- (IBAction)showMenu:(id)sender {
    [self hideList];
        NSArray *titles,*styles;

    if (_myapp.currentbox) {
        titles=[NSArray arrayWithObjects:@"配置盒子",@"绑定盒子",@"解绑盒子", nil];
        styles=[NSArray arrayWithObjects:YUDefaultStyle,YUDefaultStyle,YUDangerStyle, nil];
    }else{
        titles=[NSArray arrayWithObjects:@"配置盒子",@"绑定盒子", nil];
        styles=[NSArray arrayWithObjects:YUDefaultStyle,YUDefaultStyle, nil];
    }
    
        [self.view.window showPopWithButtonTitles:titles styles:styles whenButtonTouchUpInSideCallBack:^(int a) {
            switch (a) {
                case 0:
                {
                    [self configbox];
                    break;
                }
                case 1:
                {
                    __block UIView *view=[[UIView alloc] initWithFrame:self.view.bounds];
                    view.alpha=0.5;
                    view.backgroundColor=[UIColor darkGrayColor];
                    [self.view addSubview:view];
                    
                    
                    MyInputView *inputnameview=[[UINib nibWithNibName:@"MyInputView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
                    inputnameview.center=self.view.center;
                    inputnameview.nameTxt.delegate=self;
                    inputnameview.hintLab.text=@"请输入盒子ID";
                    [inputnameview.nameTxt becomeFirstResponder];
                    [inputnameview setDismisscallback:^(NSString *boxid) {
                        if (boxid.length>0) {
                            _temboxid=boxid;
                            NSString *bindboxstr=[MessageFormat bindToboxwithuserID:_myapp.user.ID boxID:boxid];
                            [MessageFormat sendMessage:bindboxstr socketDelegate:self tag:1];
                            [self pleaseWaitInView:self.view];
                        }
                        [view removeFromSuperview];
                        view=nil;
                    }];
                    [self.view addSubview:inputnameview];
                    
                    break;
                }
                case 2:
                {
                    if (_myapp.currentbox) {
                        [self debindbox:nil];
                    }
                    break;
                }

                default:
                    break;
            }
        }];
    
}

#pragma mark -
#pragma mark UIGestureRecognizer代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark -
#pragma mark XML解析代理方法

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

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([_XMLAction isEqualToString:@"request"]) {
        if ([_currentXMLtag isEqualToString:@"temp"]) {
            self.wenduNumLab.text=[NSString stringWithFormat:@"%@",string];
            if (string.floatValue<=26 && string.floatValue>=16) {
                self.wenduColorImg.image=[UIImage imageNamed:@"WENDU_G.png"];
                self.wenduNumImg.image=[UIImage imageNamed:@"xiaolian.png"];
            }else if (string.floatValue<16 || (string.floatValue>26 && string.floatValue<=35)) {
                self.wenduColorImg.image=[UIImage imageNamed:@"WENDU_O.png"];
                self.wenduNumImg.image=[UIImage imageNamed:@"kulian.png"];
            }else{
                self.wenduColorImg.image=[UIImage imageNamed:@"WENDU_R.png"];
                self.wenduNumImg.image=[UIImage imageNamed:@"kulian.png"];
            }
        }
        if ([_currentXMLtag isEqualToString:@"humidity"]) {
            self.shiduNumLab.text=[NSString stringWithFormat:@"%@",string];
            if (string.floatValue<45 || string.floatValue>75) {
                self.shiduColorImg.image=[UIImage imageNamed:@"SHIDU_O.png"];
                self.shiduNumImg.image=[UIImage imageNamed:@"kulian.png"];
            }else  {
                self.shiduColorImg.image=[UIImage imageNamed:@"SHIDU_G.png"];
                self.shiduNumImg.image=[UIImage imageNamed:@"xiaolian.png"];
            }
        }
        if ([_currentXMLtag isEqualToString:@"pm25"]) {
            self.pm25NumLab.text=[NSString stringWithFormat:@"%@",string];
            
            if (string.floatValue<=75) {
                self.pm25ColorImg.image=[UIImage imageNamed:@"PM25_G.png"];
                self.pm25NumImg.image=[UIImage imageNamed:@"xiaolian.png"];
            }else if (string.floatValue<=150) {
                self.pm25ColorImg.image=[UIImage imageNamed:@"PM25_O.png"];
                self.pm25NumImg.image=[UIImage imageNamed:@"kulian.png"];
            }else{
                self.pm25ColorImg.image=[UIImage imageNamed:@"PM25_R.png"];
                self.pm25NumImg.image=[UIImage imageNamed:@"kulian.png"];
            }
        }
        if ([_currentXMLtag isEqualToString:@"hcho"]) {
            self.jiaquanNumLab.text=[NSString stringWithFormat:@"%@",string];
            if (string.floatValue<0.08) {
                self.jiaquanColorImg.image=[UIImage imageNamed:@"JIAQUAN_G.png"];
                self.jiaquanNumImg.image=[UIImage imageNamed:@"xiaolian.png"];
            }else  {
                self.jiaquanColorImg.image=[UIImage imageNamed:@"JIAQUAN_R.png"];
                self.jiaquanNumImg.image=[UIImage imageNamed:@"kulian.png"];
            }
        }
    }
    
    if ([_XMLAction isEqualToString:@"allbox"]) {
        if ([_currentXMLtag isEqualToString:@"boxid"]&&![string isEqualToString:@"NULL"]) {
            Airbox *box=[Airbox boxWithName:[_currentXMLtagAttr isEqualToString:@"null"]?@"未命名":_currentXMLtagAttr ID:string];
            [_myapp.boxes addObject:box];
        }
    }
    
    if ([_XMLAction isEqualToString:@"delbind"]) {
        if ([_currentXMLtag isEqualToString:@"ret"]) {
            NSString *retstring;
            if ([string isEqualToString:@"0"]) {
                retstring=@"解绑成功";
            }else
            {
                retstring=@"解绑失败";
            }
            [MessageFormat hintWithMessage:retstring inview:self.view completion:^{
                [self getallboxes];
            }];
        }
    }
    
    if ([_XMLAction isEqualToString:@"bind"]) {
        if ([_currentXMLtag isEqualToString:@"ret"]) {
            [self endWaiting];
            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"YSY" bundle:nil];
            if ([string isEqualToString:@"0"]) {
                
                __block UIView *view=[[UIView alloc] initWithFrame:self.view.bounds];
                view.alpha=0.5;
                view.backgroundColor=[UIColor darkGrayColor];
                [self.view addSubview:view];
                
                Airbox *box=[Airbox boxWithName:@"未命名" ID:_temboxid];
                AppDelegate *myapp=[UIApplication sharedApplication].delegate;
                [myapp.boxes addObject:box];
                [self refreshbox];
                
                MyInputView *inputnameview=[[UINib nibWithNibName:@"MyInputView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
                inputnameview.center=self.view.center;
                inputnameview.nameTxt.delegate=self;
                inputnameview.hintLab.text=@"请给盒子取一个名字";
                [inputnameview.nameTxt becomeFirstResponder];
                [inputnameview setDismisscallback:^(NSString *boxname) {
                    if (boxname.length>0) {
                        box.name=boxname;
                        
                        NSString *setboxnamestr=[MessageFormat setboxnameWithboxID:box.ID boxname:box.name];
                        [MessageFormat sendMessage:setboxnamestr socketDelegate:self tag:1];
                        [self pleaseWaitInView:self.view];
                    }
                    [view removeFromSuperview];
                    view=nil;
                }];
                [self.view addSubview:inputnameview];
            }else{
                [MessageFormat hintWithMessage:@"绑定失败" inview:self.view completion:nil];
            }
        }
    }
    
    if ([_XMLAction isEqualToString:@"setboxname"]) {
        if ([_currentXMLtag isEqualToString:@"ret"]) {
            [self endWaiting];
            NSString *hintstr;
            if ([string isEqualToString:@"0"]) {
                hintstr=@"设置名字成功";
                [self getallboxes];
            }else{
                hintstr=@"设置名字失败";
            }
            [MessageFormat hintWithMessage:hintstr inview:self.view completion:nil];
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([_XMLAction isEqualToString:@"allbox"]) {
        [self.boxlistview.tv reloadData];
        [self changebox:0];
    }
    _XMLAction=nil;
}

#pragma mark -
#pragma mark NSURLConnection代理方法

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection==_temperature) {
        [_shiwaiairvalue setLength:0];
    }
    if (connection==_pm25) {
        [_pm25data setLength:0];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    if (connection==_temperature) {
        if (_shiwaiairvalue&&data) {
            [_shiwaiairvalue appendData:data];
        }
    }
    if (connection==_pm25) {
        if (_pm25data&&data) {
            [_pm25data appendData:data];
        }
    }
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.debugDescription);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==_temperature) {
        NSDictionary *airvalueDic=(NSDictionary *)[NSJSONSerialization JSONObjectWithData:_shiwaiairvalue options:NSJSONReadingAllowFragments error:nil];
        if ([(NSString *)airvalueDic[@"reason"] isEqualToString:@"成功"]) {
            NSDictionary *airvaluenow=(NSDictionary *)airvalueDic[@"result"][@"sk"];
            
            self.outsideWenduNumLab.text=[NSString stringWithFormat:@"%@",airvaluenow[@"temp"]];
            self.outsideShiduNumLab.text=[NSString stringWithFormat:@"%@",airvaluenow[@"humidity"]];
            NSString *weather=airvalueDic[@"result"][@"today"][@"weather"];
            self.tianqiLab.text=weather;
            if ([weather containsString:@"阴"]) {
                self.tianqiLogoImg.image=[UIImage imageNamed:@"ic_no_sun.png"];
            } else if ([weather containsString:@"晴"]) {
                self.tianqiLogoImg.image=[UIImage imageNamed:@"ic_sun.png"];
            } else if ([weather containsString:@"多云"]) {
                self.tianqiLogoImg.image=[UIImage imageNamed:@"ic_more_cloud.png"];
            } else if ([weather containsString:@"雨"] && ![weather containsString:@"雷"]) {
                self.tianqiLogoImg.image=[UIImage imageNamed:@"ic_no_sun_rain.png"];
            } else if ([weather containsString:@"雨"] && [weather containsString:@"雷"]) {
                self.tianqiLogoImg.image=[UIImage imageNamed:@"ic_thunder_rain.png"];
            } else if ([weather containsString:@"雪"]) {
                self.tianqiLogoImg.image=[UIImage imageNamed:@"ic_snow.png"];
            }
        }
    }
    if (connection==_pm25) {
        NSDictionary *pm25Dic=(NSDictionary *)[NSJSONSerialization JSONObjectWithData:_pm25data options:NSJSONReadingAllowFragments error:nil];
        
        if ([(NSString *)pm25Dic[@"reason"] isEqualToString:@"成功"]) {
            NSString *pm25s=pm25Dic[@"result"][@"PM25"];
            
            self.outsidePM25NumLab.text=[NSString stringWithFormat:@"%@",[pm25s substringToIndex:[pm25s rangeOfString:@"μg"].location]];
        }
    }
}

#pragma mark -
#pragma mark UITextField代理方法

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.superview.frame;
    CGFloat offset=self.view.frame.size.height-frame.size.height-frame.origin.y-50;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset <216.0)
        textField.superview.frame = CGRectMake(frame.origin.x,frame.origin.y+offset-216.0, textField.superview.frame.size.width, textField.superview.frame.size.height);
    
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
    textField.superview.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
}

@end
