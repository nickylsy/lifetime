//
//  ShangchengShouyiController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ShangchengShouyiController.h"
#import "MessageFormat.h"
#import "AppDelegate.h"
#import "NSDictionary+GetObjectBykey.h"
#import "Mydefine.h"

#define SHANGCHENGSHOUYICELL @"shangchengshouyicell"

@interface ShangchengShouyiController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_shouyiList;
}
@end

@implementation ShangchengShouyiController

#pragma mark - 重载父类方法

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    self.tableView.separatorColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    [self setExtraCellLineHidden:self.tableView];
    
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    
    [[AFAppDotNetAPIClient sharedClient] POST:MallProfit parameters:@{@"UserId":myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        _shouyiList=nil;
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _shouyiList=responseObject[@"data"];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -------------------------------

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}

#pragma mark -------------------------------

#pragma mark - TableView数据源方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shouyiList.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SHANGCHENGSHOUYICELL];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SHANGCHENGSHOUYICELL];
        
    }
    NSDictionary *dict=_shouyiList[indexPath.row];
    
    
    cell.textLabel.textColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    cell.detailTextLabel.textColor=cell.textLabel.textColor;

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text=[dict getObjectByKey:@"PayTime"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"￥%@",[dict getObjectByKey:@"Money"]];
    
    return cell;
}

#pragma makr - TableView代理方法
@end
