//
//  GerenController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/2.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "GerenController.h"
#import "VSTabBar.h"
#import "Mydefine.h"
#import "GerenEditController.h"
#import "AppDelegate.h"
#import "FamilyController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AlipayDebindHintView.h"
#import "AlipaybindController.h"
#import "UIWindow+YUBottomPoper.h"
#import "MessageFormat.h"
#import "WKAlertView.h"
#import "AboutusController.h"
#import "DES3Util.h"
#import "UITableViewCell+SelectionBackgroundColor.h"

#define GEREN_TAG 1
#define SHANGCHENG_TAG 2
#define SHEZHI_TAG 3

#define MUST_TAG 11
#define NORMAL_TAG 10

@interface GerenController ()<UITableViewDataSource,UITableViewDelegate,VSTabBarDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    NSArray *_cellreuseIdentifiers;
    
    UITableView *_gerenxinxitable;
    NSArray *_gerendatas;
    NSMutableArray *_gerenxinxi;
    
    UITableView *_shangchengtable;
    NSArray *_shangchengdatas;
    
    UITableView *_shezhitable;
    NSArray *_shezhidatas;
    
    BOOL _tuisong;
    
    NSInteger _currentPage;
    UIWindow *_warningWindow;
}
@end

@implementation GerenController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self relayoutsubviews];
    
    self.view.backgroundColor=UIColorFromRGB(0xe7e7e7);
    
    self.menuBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    self.editBtn.layer.masksToBounds=YES;
    self.editBtn.layer.cornerRadius=self.editBtn.frame.size.height/2;
    
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [self.touxiangImg setImageWithURL:[NSURL URLWithString:myapp.user.logoURLString]];
    self.touxiangImg.layer.masksToBounds=YES;
    self.touxiangImg.layer.cornerRadius=self.touxiangImg.frame.size.height/2;
    self.touxiangImg.layer.borderColor=[UIColor whiteColor].CGColor;
    self.touxiangImg.layer.borderWidth=2.0;
    
    VSTabBarItem *item1=[[VSTabBarItem alloc] initWithImage:[UIImage imageNamed:@"gerenxinxi.png"] andTitle:@"个人信息"];
    VSTabBarItem *item2=[[VSTabBarItem alloc] initWithImage:[UIImage imageNamed:@"shangchengguanli"] andTitle:@"商城管理"];
//    VSTabBarItem *item2=[[VSTabBarItem alloc] initWithImage:[UIImage imageNamed:@" "] andTitle:@" "];
    VSTabBarItem *item3=[[VSTabBarItem alloc] initWithImage:[UIImage imageNamed:@"shezhi"] andTitle:@"设置"];
    [self.tabbar setItems:@[item1,item2,item3]];
    self.tabbar.backgroundColor=self.topview.backgroundColor;
    self.tabbar.delegate=self;
    
    CGRect scrollbounds=self.scrollview.bounds;
    
    _cellreuseIdentifiers=@[@"genrencell",@"shangchengcell",@"shezhicell"];
    
    
    
//    _gerendatas=@[@"姓名/昵称",@"性别",@"电话",@"房间号",@"身份证",@"兴趣爱好",@"家庭信息",@"健康数据",@"我的支付宝"];
    _gerendatas=@[@"姓名/昵称",@"性别",@"电话",@"房间号",@"身份证",@"兴趣爱好",@"我的支付宝"];
    _gerenxinxitable=[[UITableView alloc] initWithFrame:scrollbounds];
    _gerenxinxitable.dataSource=self;
    _gerenxinxitable.delegate=self;
    _gerenxinxitable.tag=GEREN_TAG;
    _gerenxinxitable.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15);
    _gerenxinxitable.backgroundColor=self.view.backgroundColor;
//    _gerenxinxitable.bounces=NO;
    _gerenxinxitable.showsVerticalScrollIndicator=NO;
    _gerenxinxitable.separatorColor=self.view.backgroundColor;
    _gerenxinxitable.contentInset=UIEdgeInsetsMake(0, 0, 20, 0);
    [self.scrollview addSubview:_gerenxinxitable];
    [self setExtraCellLineHidden:_gerenxinxitable];
    
    _shangchengdatas=@[@[@"我的订单",@"常用地址管理",@"我发布的商品"]];
    _shangchengtable=[[UITableView alloc] initWithFrame:CGRectMake(scrollbounds.size.width,scrollbounds.origin.y , scrollbounds.size.width, scrollbounds.size.height)];
    _shangchengtable.dataSource=self;
    _shangchengtable.delegate=self;
    _shangchengtable.tag=SHANGCHENG_TAG;
    _shangchengtable.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15);
    _shangchengtable.backgroundColor=self.view.backgroundColor;
    _shangchengtable.bounces=NO;
    _shangchengtable.showsVerticalScrollIndicator=NO;
    _shangchengtable.separatorColor=self.view.backgroundColor;
    [self.scrollview addSubview:_shangchengtable];
    [self setExtraCellLineHidden:_shangchengtable];
    
    _shezhidatas=@[@[@"检查更新",@"关于我们",@"技术支持"],@[@"退出登录"]];
    _shezhitable=[[UITableView alloc] initWithFrame:CGRectMake(scrollbounds.size.width*2,scrollbounds.origin.y , scrollbounds.size.width, scrollbounds.size.height)];
    _shezhitable.dataSource=self;
    _shezhitable.delegate=self;
    _shezhitable.tag=SHEZHI_TAG;
    _shezhitable.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15);
    _shezhitable.backgroundColor=self.view.backgroundColor;
    _shezhitable.bounces=NO;
    _shezhitable.showsVerticalScrollIndicator=NO;
    _shezhitable.separatorColor=self.view.backgroundColor;
    [self.scrollview addSubview:_shezhitable];
    [self setExtraCellLineHidden:_shezhitable];
    
    _currentPage=0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    _gerenxinxi=[NSMutableArray arrayWithArray:[myapp.user toArray]];
    [_gerenxinxi addObject:@""];
//    [_gerenxinxi addObject:@""];
//    [_gerenxinxi addObject:@""];

    [_gerenxinxitable reloadData];
    [self.touxiangImg setImageWithURL:[NSURL URLWithString:myapp.user.logoURLString]];
    
    self.scrollview.contentOffset=CGPointMake(_currentPage*self.scrollview.frame.size.width, 0);
}
-(void)relayoutsubviews
{
    CGFloat screenwidth=self.view.frame.size.width;
    CGFloat screenheight=self.view.frame.size.height;
    self.topview.frame=CGRectMake(0, 64, screenwidth, 136);
    
    self.tabbar.frame=CGRectMake(0, self.topview.frame.size.height+64, screenwidth, 56);
    
    CGFloat scrolly=self.tabbar.frame.origin.y+self.tabbar.frame.size.height+8;
    self.scrollview.frame=CGRectMake(0,scrolly, screenwidth, screenheight-scrolly);

}


- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}

-(void)tuisongChange:(UISwitch *)swh
{
    _tuisong=swh.on;
}

- (IBAction)edit:(UIButton *)sender {
    UIStoryboard *YSYstoryboard=[UIStoryboard storyboardWithName:@"YSY" bundle:nil];
    UINavigationController *nav=[YSYstoryboard instantiateViewControllerWithIdentifier:@"gereneditnavcontroller"];
    nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)showmenu:(UIButton *)sender {
    [self.frostedViewController presentMenuViewController];
}

#pragma mark - UITableview数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (tableView.tag) {
        case GEREN_TAG:
        {
            return 1;
        }
        case SHANGCHENG_TAG:
        {
            return _shangchengdatas.count;
        }
        case SHEZHI_TAG:
        {
            return _shezhidatas.count;
        }
        default:
            break;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case GEREN_TAG:
        {
            return _gerendatas.count;
        }
        case SHANGCHENG_TAG:
        {
            NSArray *array=_shangchengdatas[section];
            return array.count;
        }
        case SHEZHI_TAG:
        {
            NSArray *array=_shezhidatas[section];
            return array.count;
        }
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 40.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:_cellreuseIdentifiers[tableView.tag-1]];

    switch (tableView.tag) {
        case GEREN_TAG:
        {
            if (cell==nil) {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_cellreuseIdentifiers[GEREN_TAG-1]];
            }
            
            cell.textLabel.text=_gerendatas[indexPath.row];
            cell.textLabel.textColor=UIColorFromRGB(FONT_COLOR_VALUE);
            if (![_gerenxinxi[indexPath.row] isEqual:[NSNull null]]) {
                cell.detailTextLabel.text=_gerenxinxi[indexPath.row];
            }else
            {
                cell.detailTextLabel.text=@"";
            }
            if (/*indexPath.row==6||*/indexPath.row==_gerendatas.count-1) {
                
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle=UITableViewCellSelectionStyleDefault;
                if (indexPath.row==_gerendatas.count-1) {
                    AppDelegate *_myapp=[UIApplication sharedApplication].delegate;
                    cell.detailTextLabel.text=_myapp.alipayaccount==nil?@"未绑定":_myapp.alipayaccount.account;
                }
            }else{
                cell.accessoryType=UITableViewCellAccessoryNone;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
//            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            break;
        }
        case SHANGCHENG_TAG:
        {
            if (cell==nil) {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellreuseIdentifiers[SHANGCHENG_TAG-1]];
            }
            NSArray *array=_shangchengdatas[indexPath.section];
            cell.textLabel.text=array[indexPath.row];
            cell.textLabel.textColor=UIColorFromRGB(FONT_COLOR_VALUE);
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle=UITableViewCellSelectionStyleDefault;
            break;
        }
        case SHEZHI_TAG:
        {
            if (cell==nil) {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellreuseIdentifiers[SHEZHI_TAG-1]];
            }
            
            
            NSArray *array=_shezhidatas[indexPath.section];
            cell.textLabel.text=array[indexPath.row];
            if (indexPath.section==0) {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle=UITableViewCellSelectionStyleDefault;
                cell.textLabel.textColor=UIColorFromRGB(FONT_COLOR_VALUE);
            }
            if (indexPath.section==1) {
                cell.textLabel.textColor=[UIColor redColor];
                cell.textLabel.textAlignment=NSTextAlignmentCenter;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            break;
        }
        default:
            break;
    }
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag!=GEREN_TAG&&section!=1) {
        return 20.0;
    }
    return 0.0;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = tableView.backgroundColor;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cell.selectionStyle==UITableViewCellSelectionStyleNone) {
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        [cell setSelectionBackgoundColorClear];
    }
}
#pragma mark - UITableview代理方法


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"------");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (tableView.tag) {
        case GEREN_TAG:
        {
            if (indexPath.row==_gerendatas.count-3) {//家庭信息
//                UINavigationController *family=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"familyNavcontroller"];
//                family.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//                [self presentViewController:family animated:YES completion:nil];
            } else if(indexPath.row==_gerendatas.count-2){//健康数据
                
            }else if(indexPath.row==_gerendatas.count-1){//支付宝
                AppDelegate *_myapp=[UIApplication sharedApplication].delegate;
                if (_myapp.alipayaccount==nil) {//绑定支付宝账号
                    
                    UINavigationController *nav=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"bindalipaynavcontroller"];
//                    AlipaybindController *bindcontroller=(AlipaybindController *)nav.topViewController;
                    nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:nav animated:YES completion:nil];
                } else {//解绑支付宝账号
                    
                    NSArray *titles=[NSArray arrayWithObjects:@"解绑支付宝", nil];
                    NSArray *styles=[NSArray arrayWithObjects:YUDefaultStyle, nil];

                    [self.view.window showPopWithButtonTitles:titles styles:styles whenButtonTouchUpInSideCallBack:^(int a) {
                        switch (a) {
                            case 0:
                            {
                                __block UIView *view=[[UIView alloc] initWithFrame:self.view.bounds];
                                view.alpha=0.8;
                                view.backgroundColor=[UIColor darkGrayColor];
                                [self.view addSubview:view];
                                
                                
                                AlipayDebindHintView *debindview=[[UINib nibWithNibName:@"AlipayDebindHintView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
                                debindview.PSDTxt.delegate=self;
                                [debindview setOkBlock:^(NSString *password) {
                                    [MessageFormat POST:DeleteAlipay parameters:@{@"AlipayId":_myapp.alipayaccount.alipayID,@"PassWord":[DES3Util encrypt:password],@"UserId":_myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
                                        NSNumber *statuscode=responseObject[@"code"];
                                        if (statuscode.intValue==0) {
                                            _myapp.alipayaccount=nil;
                                            [MessageFormat hintWithMessage:@"解绑成功" inview:self.view completion:^{
                                                [_gerenxinxitable reloadData];
                                            }];
                                        }
                                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        NSLog(@"%@",error.debugDescription);
                                    } incontroller:self view:self.view];
                                    
                                }];
                                [debindview setCancelBlock:^{
                                    [view removeFromSuperview];
                                    view=nil;
                                }];
                                debindview.center=self.view.center;
                                [self.view addSubview:debindview];
                                break;
                            }
                            default:
                                break;
                        }
                    }];

                }
            }
            break ;
        }
        case SHANGCHENG_TAG:
        {
            if (indexPath.row==0) {//我的订单
                UINavigationController *nav=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"mydingdannavcontroller"];
                nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nav animated:YES completion:nil];
            }
            if (indexPath.row==1) {
                UINavigationController *nav=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"addressmanagecontroller"];
                nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nav animated:YES completion:nil];
            }
            if (indexPath.row==2) {//我发布的商品
                UINavigationController *nav=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"myshopsnavcontroller"];
                nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nav animated:YES completion:nil];
            }
            break ;
        }
        case SHEZHI_TAG:
        {
            if (indexPath.section==1) {//退出登录
                
                _warningWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleWaring title:@"退出登录" detail:nil canleButtonTitle:@"否" okButtonTitle:@"是" callBlock:^(MyWindowClick buttonIndex) {
                    
                    //Window隐藏，并置为nil，释放内存 不能少
                    _warningWindow.hidden = YES;
                    _warningWindow = nil;
                    
                    if (buttonIndex==MyWindowClickForOK) {
                        AppDelegate *myapp=[UIApplication sharedApplication].delegate;
                        [myapp logout];
                        //                [self.frostedViewController dismissViewControllerAnimated:NO completion:nil];
                        [self.frostedViewController presentViewController:[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"login"] animated:NO completion:nil];
                    }
                    
                }];
                
            }
            else if (indexPath.row==0){//检查更新
                [MessageFormat POST:CheckVersion parameters:@{@"AppId":@"2",@"Version":[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]} success:^(NSURLSessionDataTask *task, id responseObject) {
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
                    }else{
                        [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                } incontroller:self view:self.view];
            }else if (indexPath.row==1){
                UINavigationController *nav=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"aboutuscontroller"];
                nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                AboutusController *aboutus=(AboutusController *)nav.topViewController;
                aboutus.urlstring=@"http://www.freezeholdings.com";
                aboutus.navigationItem.title=@"关于我们";
                [self presentViewController:nav animated:YES completion:nil];
            }else if (indexPath.row==2){
                UINavigationController *nav=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"aboutuscontroller"];
                nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                AboutusController *aboutus=(AboutusController *)nav.topViewController;
                aboutus.urlstring=@"http://www.xtoucher.com";
                aboutus.navigationItem.title=@"技术支持";
                [self presentViewController:nav animated:YES completion:nil];            }
            break ;
        }
        default:
            break;
    }

}

#pragma mark - VSTabbar代理方法

-(void) tabBar:(VSTabBar*)tabBar selectedItemWithIndex:(NSInteger)index
{
    _currentPage=index;
    self.scrollview.contentOffset=CGPointMake(_currentPage*self.scrollview.frame.size.width, 0);
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

#pragma mark - UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==MUST_TAG || (alertView.tag==NORMAL_TAG && buttonIndex==1)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
        assert(alertView.tag!=MUST_TAG);
    }
    [alertView removeFromSuperview];
    alertView=nil;
}

#pragma mark -
#pragma mark -------------------------------
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _gerenxinxitable.bounces=NO;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _gerenxinxitable.bounces=YES;
}


@end
