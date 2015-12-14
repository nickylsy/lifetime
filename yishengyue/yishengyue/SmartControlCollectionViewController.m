//
//  SmartControlCollectionViewController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "SmartControlCollectionViewController.h"

#import "SmarcontrolCollectionViewCell.h"
#import "TVControlViewController.h"
#import "KTControlViewController.h"
#import "AircleanerControlViewController.h"
#import "OtherControlViewController.h"
#import "HintView.h"
#import "AddDeviceView.h"
#import "Airbox.h"
#import "Device.h"
#import "MessageFormat.h"
#import "AsyncUdpSocket.h"
#import "BDKNotifyHUD.h"
#import "UIWindow+YUBottomPoper.h"
#import "MyInputView.h"
#import "AppDelegate.h"

@interface SmartControlCollectionViewController ()
{
    NSString *_currentXMLtag;
    NSString *_currentXMLtagAttr;
    NSString *_XMLAction;
    Device *_tempdev;
    UIView *_temview;
    AppDelegate *_myapp;
}

@end

@implementation SmartControlCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    _myapp=[UIApplication sharedApplication].delegate;
    _tempdev=[Device deviceWithName:nil ID:nil];
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.collectionView registerClass:[SmarcontrolCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake(self.collectionView.frame.size.width/3.0, self.collectionView.frame.size.width/3.0);
    layout.sectionInset=UIEdgeInsetsMake(0.0f, 0.0f,0.0f,0.0f);
    layout.minimumInteritemSpacing=0.0f;
    layout.minimumLineSpacing=0.0f;
    self.collectionView.collectionViewLayout=layout;
    
    // Do any additional setup after loading the view.
    
    NSString *helpstr=@"点击\"+\"添加电器，点击电器图标进入对应的遥控器，长按电器图标选择删除电器";
    _helphint=[[HintView alloc] initWithFrame:CGRectMake(0, 0, 150, 250) string:helpstr];
    _helphint.center=CGPointMake(self.view.frame.size.width-75, 125+64);
    [self.view addSubview:_helphint];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adddevice:) name:MSG_ADDDEVICE object:nil];
    
    
    [self refreshdevs];
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _myapp.currentbox.devices.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SmarcontrolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    if (indexPath.item==_myapp.currentbox.devices.count) {
        cell.logoImg.center=CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);
        cell.logoImg.image=[UIImage imageNamed:@"add.png"];
        cell.nameLab.text=nil;
    } else {
        cell.logoImg.center=CGPointMake(cell.frame.size.width/2, cell.frame.size.height*5/12);
        Device *dev=_myapp.currentbox.devices[indexPath.item];
        cell.nameLab.text=dev.name;
        cell.tag=dev.ID.intValue;
        UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpress:)];
        longpress.minimumPressDuration=0.8;
        [cell addGestureRecognizer:longpress];
        
        int leibie=[dev.ID substringToIndex:1].intValue;
        switch (leibie) {
            case 1:
            {
                cell.logoImg.image=[UIImage imageNamed:@"tv.png"];
                break;
            }
            case 2:
            {
                cell.logoImg.image=[UIImage imageNamed:@"kongtiao.png"];
                break;
            }
            case 3:
            {
                cell.logoImg.image=[UIImage imageNamed:@"aircleaner.png"];
                break;
            }
            case 4:
            {
                cell.logoImg.image=[UIImage imageNamed:@"other.png"];
                break;
            }
            default:
                break;
        }
    }
    
    cell.layer.borderWidth=0.42;
    cell.layer.borderColor=[UIColor colorWithRed:238 green:238 blue:238 alpha:1].CGColor;
    return cell;
}

#pragma mark <UICollectionViewDelegate>


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _helphint.hidden=YES;
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Autolayout" bundle:nil];
    if (indexPath.item>=_myapp.currentbox.devices.count) {

        self.collectionView.userInteractionEnabled=NO;
        self.helpBtn.enabled=NO;
        self.backBtn.enabled=NO;
        
        AddDeviceView *addview=[[UINib nibWithNibName:@"AddDeviceView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
        [addview setborder];

        addview.layer.borderWidth=1;
        [addview setDismissBlock:^{
            self.collectionView.alpha=1;
            self.collectionView.userInteractionEnabled=YES;
            self.helpBtn.enabled=YES;
            self.backBtn.enabled=YES;
        }];
        addview.center=self.collectionView.center;
        addview.devicenameTxt.delegate=self;
        [self.view addSubview:addview];
        self.collectionView.alpha=0.8;
    }else
    {
        Device *dev=_myapp.currentbox.devices[indexPath.item];
        int c=[dev.ID substringToIndex:1].intValue;
        switch (c) {
            case 1:
            {
                TVControlViewController *tv= [mainStoryboard instantiateViewControllerWithIdentifier:@"tvcontrolviewcontroller"];
                tv.currentdevice=dev;

                [self presentViewController:tv animated:YES completion:nil];
                break;
            }
            case 2:
            {
                KTControlViewController *kt= [mainStoryboard instantiateViewControllerWithIdentifier:@"ktcontrolviewcontroller"];

                kt.currentdevice=dev;
                [self presentViewController:kt animated:YES completion:nil];
                break;
            }
            case 3:
            {
                AircleanerControlViewController *aircleaner=[mainStoryboard instantiateViewControllerWithIdentifier:@"aircleanerviewcontroller"];
                aircleaner.currentdevice=dev;

                [self presentViewController:aircleaner animated:YES completion:nil];
            }
            case 4:
            {
                OtherControlViewController *other=[mainStoryboard instantiateViewControllerWithIdentifier:@"otherviewcontroller"];

                other.currentdevice=dev;
                [self presentViewController:other animated:YES completion:nil];
            }
            default:
                break;
        }
    }
    
}

- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showHelpMsg:(id)sender {
    
    
    if (_helphint.hidden) {
        _temview=[[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_temview];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHelpMsg:)];
        [_temview addGestureRecognizer:tap];
        [self.view bringSubviewToFront:_helphint];
    }else{
        [_temview removeFromSuperview];
        _temview=nil;
    }
    _helphint.hidden=!_helphint.hidden;
}


/****UITextField的代理方法****/

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
    textField.superview.center=self.collectionView.center;
}

-(void)adddevice:(NSNotification *)notification
{
    NSNumber *c=notification.userInfo[KEY_CATEGORY];
    _tempdev.name=notification.userInfo[KEY_NAME];
    _tempdev.ID=[NSString stringWithFormat:@"%i",c.intValue];
    [self newdeviceidWithtype:[NSString stringWithFormat:@"%i",c.intValue]];
}

-(void)newdeviceidWithtype:(NSString *)type
{
    NSString *maxdeviceidstr=[MessageFormat maxdeviceIDWithboxID:_myapp.currentbox.ID deviceType:type];
    [MessageFormat sendMessage:maxdeviceidstr socketDelegate:self tag:1];
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
    _currentXMLtag=elementName;
    if ([elementName isEqualToString:@"para"]) {
        _XMLAction=attributeDict[@"action"];
        if ([_XMLAction isEqualToString:@"alldevice"]) {
            [_myapp.currentbox.devices removeAllObjects];
        }
    }
    if ([_XMLAction isEqualToString:@"alldevice"]&&[elementName isEqualToString:@"deviceid"]) {
        _currentXMLtagAttr=attributeDict[@"name"];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if ([_XMLAction isEqualToString:@"alldevice"]) {
        if ([_currentXMLtag isEqualToString:@"deviceid"]) {
            Device *dev=[Device deviceWithName:_currentXMLtagAttr ID:string];
            [_myapp.currentbox.devices addObject:dev];
        }
    }
    if ([_XMLAction isEqualToString:@"maxdeviceid"]) {
        if ([_currentXMLtag isEqualToString:@"deviceid"]) {
            if (string.intValue<1) {
                _tempdev.ID=[NSString stringWithFormat:@"%@0001",_tempdev.ID];
            } else {
                _tempdev.ID=[NSString stringWithFormat:@"%05i",string.intValue+1];
            }
            
            NSString *adddevstr=[MessageFormat adddeviceWithboxID:_myapp.currentbox.ID deviceID:_tempdev.ID deviceName:_tempdev.name];
           
                [MessageFormat sendMessage:adddevstr socketDelegate:self tag:1];
          
            
        }
    }
    if ([_XMLAction isEqualToString:@"adddevice"]) {
        if ([_currentXMLtag isEqualToString:@"ret"]) {
            if ([string isEqualToString:@"0"]) {
                [_myapp.currentbox.devices addObject:[Device deviceWithName:_tempdev.name ID:_tempdev.ID]];
                [self.collectionView reloadData];
            }else
            {
                BDKNotifyHUD *hud=[BDKNotifyHUD notifyHUDWithImage:nil text:@"添加失败"];
                hud.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
                [self.view addSubview:hud];
                [hud presentWithDuration:0.5 speed:0.3 inView:self.view completion:^{
                    [hud removeFromSuperview];
                }];
                return;
            }
        }
    }
    
    if ([_XMLAction isEqualToString:@"deldevice"]) {
        if ([_currentXMLtag isEqualToString:@"ret"]) {
            if ([string isEqualToString:@"0"]) {
                [self refreshdevs];
            }
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([_XMLAction isEqualToString:@"alldevice"]) {
        [self.collectionView reloadData];
    }
}

-(void)longpress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateBegan) {
        
        NSArray *titles=[NSArray arrayWithObjects:@"删除", nil];
        NSArray *styles=[NSArray arrayWithObjects:YUDangerStyle, nil];
        
        [self.view.window showPopWithButtonTitles:titles styles:styles whenButtonTouchUpInSideCallBack:^(int a) {
            switch (a) {
//                case 0:
//                {
//                    MyInputView *inputnameview=[[UINib nibWithNibName:@"MyInputView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
//                    inputnameview.center=self.view.center;
//                    inputnameview.nameTxt.delegate=self;
//                    [inputnameview setDismisscallback:^(NSString *name) {
////                        NSString *setnamestr=[Mes];
////                        [MessageFormat sendMessage:setnamestr socketDelegate:self tag:1];
//                        self.view.alpha=1;
//                    }];
//                    [self.view addSubview:inputnameview];
//                    self.view.alpha=0.8;
//                    break;
//                }
                case 0:
                {
                    [MessageFormat sendMessage:[MessageFormat deletedeviceWithboxID:_myapp.currentbox.ID deviceID:[NSString stringWithFormat:@"%li",gesture.view.tag]] socketDelegate:self tag:1];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}


-(void)refreshdevs
{
    NSString *alldevicestr=[MessageFormat alldeviceWithboxID:_myapp.currentbox.ID];
    [MessageFormat sendMessage:alldevicestr socketDelegate:self tag:1];
}
@end
