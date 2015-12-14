
//
//  LikeListController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/9/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "LikeListController.h"
#import "LikeListCell.h"
#import "MessageFormat.h"
#import "Mydefine.h"
#import "NSDictionary+GetObjectBykey.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"
#import "CircleDetailController.h"

@interface LikeListController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_intList;
}
@end

@implementation LikeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.tableView.backgroundColor=UIColorFromRGB(0xf0f0f0);
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LikeListCell class]) bundle:nil] forCellReuseIdentifier:@"likelistcell"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _intList=[NSMutableArray array];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setbeginRefreshing];
}

#pragma mark - 响应方法
- (IBAction)goback:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView数据源方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _intList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LikeListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"likelistcell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict=_intList[indexPath.row];
    cell.nameLab.text=[dict getObjectByKey:@"UserName"];
    cell.timeLab.text=[NSString stringWithFormat:@"发布时间：%@",[dict getObjectByKey:@"CreateTime"]];
    cell.themeLab.text=[NSString stringWithFormat:@"主题：%@",[dict getObjectByKey:@"Title"]];
    cell.descLab.text=[NSString stringWithFormat:@"简介：%@",[dict getObjectByKey:@"Introduction"]];
    [cell.iconImg setImageWithURL:[NSURL URLWithString:[dict getObjectByKey:@"LogoUrl"]] placeholderImage:[UIImage imageNamed:@""]];
    return cell;
}
#pragma mark - UITableView代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"--------");
    
    NSDictionary *dict=_intList[indexPath.row];
    
    CircleDetailController *detaicontroller=[[UIStoryboard storyboardWithName:@"Quanzi" bundle:nil] instantiateViewControllerWithIdentifier:@"circledetailcontroller"];
    detaicontroller.circleID=[dict getObjectByKey:@"InId"];
    detaicontroller.type=@"1";
    detaicontroller.navigationItem.title=[NSString stringWithFormat:@"%@详情",self.navigationItem.title];
    [self.navigationController pushViewController:detaicontroller animated:YES];
}



#pragma mark - 开始刷新函数
- (void)setbeginRefreshing
{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开马上刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中 ..." forState:MJRefreshStateRefreshing];
    
    
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置刷新控件
    self.tableView.header = header;
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadMoreData
{
    [[AFAppDotNetAPIClient sharedClient] POST:intereslist.URLEncodedString parameters:@{@"IntId":self.interestID,@"Start":[NSString stringWithFormat:@"%lu",(unsigned long)_intList.count]} success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.footer endRefreshing];
        
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSArray *array=responseObject[@"data"];
            for (NSDictionary *dict in array) {
                [_intList addObject:dict];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
    
}

-(void)refreshData
{
    [[AFAppDotNetAPIClient sharedClient] POST:intereslist.URLEncodedString parameters:@{@"IntId":self.interestID,@"Start":@"0"} success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.header endRefreshing];
        _intList=[NSMutableArray array];
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSArray *temarr=responseObject[@"data"];
            for (NSDictionary *dict in temarr) {
                [_intList addObject:dict];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.header endRefreshing];
        NSLog(@"%@",error.debugDescription);
    }];
}

@end
