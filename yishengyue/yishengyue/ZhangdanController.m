//
//  ZhangdanController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ZhangdanController.h"
#import "MessageFormat.h"
#import "AppDelegate.h"
#import "Mydefine.h"
//#import "MJRefresh.h"
#import "MJRefresh.h"

@interface ZhangdanController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_zhangdanlist;
}
@end

@implementation ZhangdanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setExtraCellLineHidden:self.tableView];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=UIColorFromRGB(0xf6f6f6);
    
    
    [self setbeginRefreshing];
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

#pragma mark - UITableview数据源方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _zhangdanlist.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"zhangdancell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"zhangdancell"];
    }
    
    NSDictionary *dict=_zhangdanlist[indexPath.row];
    
    cell.textLabel.numberOfLines=0;
    NSString *methodstring=@"提现-快速提现";
    NSString *timestring=dict[@"CreateTime"];
    NSString *textstring=[NSString stringWithFormat:@"%@\n%@",methodstring,timestring];
    NSMutableAttributedString *atttextstring=[[NSMutableAttributedString alloc] initWithString:textstring];
    
    [atttextstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xadadad) range:[textstring rangeOfString:timestring]];
    [atttextstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:[textstring rangeOfString:methodstring]];
    [atttextstring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:[textstring rangeOfString:timestring]];
    [cell.textLabel setAttributedText:atttextstring];
    
    
    
    cell.detailTextLabel.numberOfLines=0;
    NSString *statusstring=dict[@"Status"];
    NSString *moneystring=[NSString stringWithFormat:@"￥%@",dict[@"Money"]];
    NSString *detailstring=[NSString stringWithFormat:@"%@\n%@",moneystring,statusstring];
    NSMutableAttributedString *attdetailstring=[[NSMutableAttributedString alloc] initWithString:detailstring];
    
    [attdetailstring addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:[detailstring rangeOfString:moneystring]];
    [attdetailstring addAttribute:NSForegroundColorAttributeName value:[statusstring isEqualToString:@"处理中"]?[UIColor redColor]:UIColorFromRGB(0xadadad) range:[detailstring rangeOfString:statusstring]];
    [attdetailstring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:[detailstring rangeOfString:statusstring]];
    [cell.detailTextLabel setAttributedText:attdetailstring];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat leftmargin=indexPath.row==_zhangdanlist.count-1?0:15;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(leftmargin, cell.frame.size.height-1, cell.frame.size.width-2*leftmargin, 1)];
    view.backgroundColor=UIColorFromRGB(0xf2f2f2);
    [cell addSubview:view];
}
#pragma mark - UITableview代理方法


#pragma mark - 隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
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
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    
    [[AFAppDotNetAPIClient sharedClient] POST:MyBill.URLEncodedString parameters:@{@"UserId":myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.header endRefreshing];
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _zhangdanlist=[NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"data"])
            {
                [_zhangdanlist addObject:dict];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.header endRefreshing];
         NSLog(@"%@",error.debugDescription);
    }];
}

@end
