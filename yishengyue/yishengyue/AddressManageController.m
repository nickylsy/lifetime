//
//  AddressManageController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/17.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AddressManageController.h"
#import "AppDelegate.h"
#import "Mydefine.h"
#import "AddressCell.h"
#import "AddressInfo.h"
#import "AddaddressController.h"
#import "MJRefresh.h"
#import "AFAppDotNetAPIClient.h"
#import "MessageFormat.h"
#import "UITableViewCell+SelectionBackgroundColor.h"

#define ADDADDRESSREUSEIDENTIFIER @"addaddresscell"
#define ADDRESSREUSEIDENTIFIER @"addresscell"


@interface AddressManageController ()<UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *_myapp;
    
}
@end

@implementation AddressManageController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _myapp=[UIApplication sharedApplication].delegate;
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=UIColorFromRGB(0xf6f6f6);
    [self setbeginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refershData) name:REFRESH_ADDRESSLIST object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goback:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return 1;
    }else{
        return _myapp.addresses.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ADDADDRESSREUSEIDENTIFIER];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ADDADDRESSREUSEIDENTIFIER];
        }
        cell.textLabel.text=@"添加新地址";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1)];
        imageview.backgroundColor=UIColorFromRGB(0xededed);
        [cell.contentView addSubview:imageview];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        AddressInfo *add=_myapp.addresses[indexPath.row];
        AddressCell *cell=[tableView dequeueReusableCellWithIdentifier:ADDRESSREUSEIDENTIFIER];
        if (cell==nil) {
            cell=[[UINib nibWithNibName:@"AddressCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
        }
        
        cell.nameLab.text=add.name;
        cell.phoneNumLab.text=add.phoneNum;
        cell.addressLab.text=add.address;
        cell.selectedImg.hidden=[_myapp.defaultaddress.ID isEqualToString:add.ID]?NO:YES;
        
        cell.addressImg.hidden=YES;
        cell.selectedImg.hidden=YES;
        
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1)];
        imageview.backgroundColor=UIColorFromRGB(0xededed);
        [cell.contentView addSubview:imageview];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44;
    }else{
        return 100;
    }
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section==0) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,10)];
        
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 9, view.frame.size.width, 1)];
        imageview.backgroundColor=UIColorFromRGB(0xededed);
        [view addSubview:imageview];
        return view;;
    }
    return nil;
}

#pragma mark - tableview代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        AddaddressController *addaddresscontroller=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"addaddresscontroller"];
        [self.navigationController pushViewController:addaddresscontroller animated:YES];
    }else{
        AddressInfo *add=_myapp.addresses[indexPath.row];
        AddaddressController *addaddresscontroller=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"addaddresscontroller"];
        addaddresscontroller.type=AddressManageTypeEdit;
        addaddresscontroller.addressID=add.ID;
        [self.navigationController pushViewController:addaddresscontroller animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return;
    }
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        AddressInfo *add=_myapp.addresses[indexPath.row];
        [MessageFormat POST:DeleteAddress parameters:@{@"AddressId":add.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
            NSNumber *statuscode=responseObject[@"code"];
            if (statuscode.intValue==0) {
                [_myapp.addresses removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.debugDescription);
        } incontroller:self view:self.tableView];
    }
}

#pragma mark - 开始刷新函数
- (void)setbeginRefreshing
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refershData)];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开马上刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中 ..." forState:MJRefreshStateRefreshing];
    
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置刷新控件
    self.tableView.header = header;
}

-(void)refershData
{
    [[AFAppDotNetAPIClient sharedClient] POST:AddressList.URLEncodedString parameters:@{@"UserId":_myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.header endRefreshing];
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _myapp.addresses=[NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                AddressInfo *add=[AddressInfo addressinfoWithDict:dict];
                [_myapp.addresses addObject:add];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}



@end
