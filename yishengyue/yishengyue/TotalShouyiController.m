//
//  TotalShouyiController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "TotalShouyiController.h"
#import "AFAppDotNetAPIClient.h"
#import "AppDelegate.h"
#import "Mydefine.h"

#define HUOLICELL @"huolicell"

@interface TotalShouyiController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_youhuiList;
    NSMutableArray *_chayueList;
    
    CGPoint _youhuigOffset;
    CGPoint _chayueOffset;
    
    BOOL _youhuiRequestOK;
    BOOL _chayueRequestOK;
    
    AppDelegate *_myapp;
}
@end

@implementation TotalShouyiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _chayueOffset=CGPointZero;
    _youhuigOffset=CGPointZero;
    
    _chayueRequestOK=NO;
    _youhuiRequestOK=NO;
    
    _myapp=[UIApplication sharedApplication].delegate;
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    self.tableView.separatorColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    [self setExtraCellLineHidden:self.tableView];
    
    [[AFAppDotNetAPIClient sharedClient] POST:DiscountList.URLEncodedString parameters:@{@"UserId":_myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _youhuiList=[NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                [_youhuiList addObject:dict];
            }
        }
        _youhuiRequestOK=YES;
        if (_youhuiRequestOK&&_chayueRequestOK) {
            [self.tableView reloadData];
            //                [self endWaiting];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    }];
    
    [[AFAppDotNetAPIClient sharedClient] POST:EstateList.URLEncodedString parameters:@{@"UserId":_myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _chayueList=[NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"]) {
                [_chayueList addObject:dict];
            }
            
        }
        _chayueRequestOK=YES;
        if (_youhuiRequestOK&&_chayueRequestOK) {
            [self.tableView reloadData];
            //                [self endWaiting];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    }];

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
- (IBAction)changeFenlei:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            _youhuigOffset=self.tableView.contentOffset;
            break;
        }
        case 1:
        {
            _chayueOffset=self.tableView.contentOffset;
            break;
        }
        default:
            break;
    }
    
    [self.tableView reloadData];
    
    self.tableView.contentOffset=sender.selectedSegmentIndex==0?_chayueOffset:_youhuigOffset;
}

#pragma mark - UITableView数据源方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.huiliSmt.selectedSegmentIndex==0?_chayueList.count:_youhuiList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:HUOLICELL];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HUOLICELL];
    }

     NSDictionary *dict=self.huiliSmt.selectedSegmentIndex==0?_chayueList[indexPath.row]:_youhuiList[indexPath.row];
    
    cell.textLabel.textColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    cell.detailTextLabel.textColor=cell.textLabel.textColor;
    
    cell.textLabel.text=dict[@"CreateTime"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"￥%@",dict[@"Money"]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView代理方法

#pragma mark - 隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}

@end
