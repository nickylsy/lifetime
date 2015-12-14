//
//  KTControlViewController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/22.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "KTControlViewController.h"
#import "Mydefine.h"
#import "RemotecontrolCollectionViewCell.h"
#import "UIWindow+YUBottomPoper.h"
#import "LearnViewController.h"
#import "MessageFormat.h"
#import "AsyncUdpSocket.h"
#import "Device.h"
#import "Airbox.h"
#import "ControlButton.h"
#import "MyInputView.h"
#import "AppDelegate.h"

#define TVINITBUTTONNUMBER_TOP 4
#define TVINITBUTTONNUMBER_BOTTOM 5

#define KTINITBUTTONNUMBER_TOP 3
#define KTINITBUTTONNUMBER_BOTTOM 5
#define KTCELLREUSEIDENTIFIER @"ktbtncell"

@interface KTControlViewController ()
{
    NSString       * _currentXMLtag;
    NSString       * _currentXMLtagAttr;
    NSString       * _XMLAction;
    ControlButton  * _tempbtn;
    NSMutableArray * _qianarr;//默认可以滑动的
    NSMutableArray * _zhongarr;//添加的按钮
    NSMutableArray * _houarr;//下面五个按钮
    NSMutableArray * _collectionviewarr;
    AppDelegate *_myapp;
}

@end

@implementation KTControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myapp=[UIApplication sharedApplication].delegate;
    _tempbtn=[ControlButton buttonWithName:nil ID:nil];
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.navBar.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.collectionView.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    
    CGFloat screenwidth=self.view.frame.size.width;
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake(screenwidth/2-COLLECTIONVIEW_CONTENTINEST_TOP*2, COLLECTIONVIEW_CONTENTINEST_TOP*2);
    layout.sectionInset=UIEdgeInsetsMake(0.0f, COLLECTIONVIEW_CONTENTINEST_TOP,0.0f,COLLECTIONVIEW_CONTENTINEST_TOP);
    layout.minimumInteritemSpacing=COLLECTIONVIEW_CONTENTINEST_TOP;
    layout.minimumLineSpacing=COLLECTIONVIEW_CONTENTINEST_TOP;
    self.collectionView.collectionViewLayout=layout;
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(COLLECTIONVIEW_CONTENTINEST_TOP, 0, COLLECTIONVIEW_CONTENTINEST_TOP, 0)];
    
    [self.collectionView registerClass:[RemotecontrolCollectionViewCell class] forCellWithReuseIdentifier:KTCELLREUSEIDENTIFIER];
    for (UIView *view in self.view.subviews) {
        if (view.class==[UIButton class]) {
            UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(menu:)];
            [view addGestureRecognizer:longpress];
        }
        if (view.class==[UILabel class]) {
            [(UILabel *)view setTextColor:UIColorFromRGB(MAIN_COLOR_VALUE)];
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *allbtnstr=[MessageFormat allbuttonWithboxID:_myapp.currentbox.ID deviceID:_currentdevice.ID];
    [MessageFormat sendMessage:allbtnstr socketDelegate:self tag:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)menu:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateBegan) {
        NSArray *titles,*styles;
        if (gesture.view.tag<=(KTINITBUTTONNUMBER_BOTTOM+KTINITBUTTONNUMBER_TOP)) {
            titles=[NSArray arrayWithObject:@"学习"];
            styles=[NSArray arrayWithObject:YUDefaultStyle];
        } else {
            titles=[NSArray arrayWithObjects:@"学习",@"重命名",@"删除", nil];
            styles=[NSArray arrayWithObjects:YUDefaultStyle,YUDefaultStyle,YUDangerStyle, nil];
        }
        [self.view.window showPopWithButtonTitles:titles styles:styles whenButtonTouchUpInSideCallBack:^(int a) {
            switch (a) {
                case 0:
                {
                    UIStoryboard *mainstoryboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
                    LearnViewController *learnc=[mainstoryboard instantiateViewControllerWithIdentifier:@"learnviewcontroller"];
                    learnc.boxID=_myapp.currentbox.ID;
                    learnc.btnID=[NSString stringWithFormat:@"%@%05li",_currentdevice.ID,gesture.view.tag];
                    learnc.needinputname=NO;
                    [self presentViewController:learnc animated:YES completion:nil];
                    NSLog(@"%@",[NSString stringWithFormat:@"%@%05li",_currentdevice.ID,gesture.view.tag]);
                    break;
                }
                case 1:
                {
                    if (titles.count<3) {
                        break;
                    }
                    MyInputView *inputnameview=[[UINib nibWithNibName:@"MyInputView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
                    inputnameview.center=self.view.center;
                    inputnameview.nameTxt.delegate=self;
                    [inputnameview.nameTxt becomeFirstResponder];
                    [inputnameview setDismisscallback:^(NSString *name) {
                        NSString *setnamestr=[MessageFormat setbuttonnameWithboxID:_myapp.currentbox.ID btnID:[NSString stringWithFormat:@"%@%05li",_currentdevice.ID,gesture.view.tag] btnname:name];
                        [MessageFormat sendMessage:setnamestr socketDelegate:self tag:1];
                        self.view.alpha=1;
                    }];
                    [self.view addSubview:inputnameview];
                    self.view.alpha=0.8;
                    
                    break;
                }
                case 2:
                {
                    [MessageFormat sendMessage:[MessageFormat deletebuttonWithboxID:_myapp.currentbox.ID btnID:[NSString stringWithFormat:@"%@%05li",_currentdevice.ID,gesture.view.tag]] socketDelegate:self tag:1];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _collectionviewarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RemotecontrolCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:KTCELLREUSEIDENTIFIER forIndexPath:indexPath];
    if (cell) {
        switch (indexPath.item) {
            case 0:
            {
                cell.contentImg.image=[UIImage imageNamed:@"close.png"];
                cell.contentLab.text=nil;
                break;
            }
            case 1:
                
            {
                cell.contentImg.image=nil;
                cell.contentLab.text=@"冷/热";
                break;
            }
            case 2:
            {
                cell.contentImg.image=nil;
                cell.contentLab.text=@"风速";
                break;
            }
                
            default:
            {
                cell.contentLab.text=nil;
                cell.contentImg.image=nil;
                break;
            }
        }
        ControlButton *btn=_collectionviewarr[indexPath.item];
        cell.tag=[btn.ID substringFromIndex:5].intValue;
        UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(menu:)];
        [cell addGestureRecognizer:longpress];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ControlButton *btn=_collectionviewarr[indexPath.item];
    NSString *controlstr=[MessageFormat controlWithboxID:_myapp.currentbox.ID btnID:btn.ID];
    [MessageFormat sendMessage:controlstr socketDelegate:self tag:1];
}

- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButton:(id)sender {
    NSString *maxbtnidstr=[MessageFormat maxbtnIDWithboxID:_myapp.currentbox.ID];
    [MessageFormat sendMessage:maxbtnidstr socketDelegate:self tag:1];
}

-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"收到udp数据---%@----host:%@----port:%i----tag:%ld",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],host,port,tag);
    
    [sock close];
    NSXMLParser *parser=[[NSXMLParser alloc] initWithData:data];
    parser.delegate=self;
    [parser parse];
    
    return YES;
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    [sock close];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //    NSLog(@"elementName:%@-----namespaceURI:%@------qualifiedName:%@-------attributes:%@",elementName,namespaceURI,qName,attributeDict);
    _currentXMLtag=elementName;
    if ([elementName isEqualToString:@"para"]) {
        _XMLAction=attributeDict[@"action"];
        if ([_XMLAction isEqualToString:@"allbutton"]) {
            [self.currentdevice.btns removeAllObjects];
            _qianarr=[NSMutableArray array];
            _zhongarr=[NSMutableArray array];
            _houarr=[NSMutableArray array];
            _collectionviewarr=[NSMutableArray array];
        }
    }
    if ([_XMLAction isEqualToString:@"allbutton"]&&[elementName isEqualToString:@"btnid"]) {
        _currentXMLtagAttr=attributeDict[@"name"];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if ([_XMLAction isEqualToString:@"allbutton"]) {
        if ([_currentXMLtag isEqualToString:@"btnid"]) {
            ControlButton *btn=[ControlButton buttonWithName:_currentXMLtagAttr ID:string];
            if ([string substringFromIndex:5].intValue>(KTINITBUTTONNUMBER_TOP+KTINITBUTTONNUMBER_BOTTOM)) {
                [_zhongarr addObject:btn];
            }else if ([string substringFromIndex:5].intValue>KTINITBUTTONNUMBER_TOP)
            {
                [_houarr addObject:btn];
            }else{
                [_qianarr addObject:btn];
            }
        }
    }
    if ([_XMLAction isEqualToString:@"maxid"]) {
        if ([_currentXMLtag isEqualToString:@"btnid"]) {
            if ([string substringFromIndex:5].intValue>=10) {
                _tempbtn.ID=[NSString stringWithFormat:@"%@%05i",_currentdevice.ID,[string substringFromIndex:5].intValue+1];
            } else {
                _tempbtn.ID=[NSString stringWithFormat:@"%@%05i",_currentdevice.ID,TVINITBUTTONNUMBER_TOP+TVINITBUTTONNUMBER_BOTTOM+1];
            }
            
            UIStoryboard *mainstoryboard=[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
            LearnViewController *learnc=[mainstoryboard instantiateViewControllerWithIdentifier:@"learnviewcontroller"];
            learnc.boxID=_myapp.currentbox.ID;
            learnc.btnID=_tempbtn.ID;
            learnc.needinputname=YES;
            [self presentViewController:learnc animated:YES completion:nil];
            
            NSLog(@"%@",_tempbtn.ID);
        }
    }
    
    if ([_XMLAction isEqualToString:@"delbutton"]) {
        if ([_currentXMLtag isEqualToString:@"ret"]) {
            if ([string isEqualToString:@"0"]) {
                [self viewWillAppear:YES];
            }
        }
    }
    
    if ([_XMLAction isEqualToString:@"setbtnname"]) {
        if ([_currentXMLtag isEqualToString:@"ret"]) {
            if ([string isEqualToString:@"0"]) {
                [self viewWillAppear:YES];
            }
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //    NSLog(@"elementName:%@-----namespaceURI:%@------qualifiedName:%@",elementName,namespaceURI,qName);
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([_XMLAction isEqualToString:@"allbutton"]) {
        [self.currentdevice.btns addObjectsFromArray:_qianarr];
        [self.currentdevice.btns addObjectsFromArray:_zhongarr];
        [self.currentdevice.btns addObjectsFromArray:_houarr];
        
        ControlButton *btnclose=[ControlButton buttonWithName:@"close" ID:[NSString stringWithFormat:@"%@00001",_currentdevice.ID]];
        ControlButton *btnlengre=[ControlButton buttonWithName:@"leng/re" ID:[NSString stringWithFormat:@"%@00002",_currentdevice.ID]];
        ControlButton *btnspeed=[ControlButton buttonWithName:@"speed" ID:[NSString stringWithFormat:@"%@00003",_currentdevice.ID]];
        [_collectionviewarr addObject:btnclose];
        [_collectionviewarr addObject:btnlengre];
        [_collectionviewarr addObject:btnspeed];
        
        [_collectionviewarr addObjectsFromArray:_zhongarr];
        
        
        [self.collectionView reloadData];
    }
    
    parser=nil;
}
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
