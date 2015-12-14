//
//  CircleMyReleaseController.m
//  yishengyue
//
//  Created by 华为-xtoucher on 15/9/23.
//  Copyright © 2015年 Xtoucher08. All rights reserved.
//

#import "CircleMyReleaseController.h"
#import "Mydefine.h"
#import "LikeListCell.h"
#import "MessageFormat.h"
#import "NSDictionary+GetObjectBykey.h"
#import "MJRefresh.h"
#import "CircleMyReleaseDetailController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"

@interface CircleMyReleaseController ()
{
    NSMutableArray *_InfoList;
    AppDelegate *_myapp;
    
}
@end

@implementation CircleMyReleaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _myapp=[UIApplication sharedApplication].delegate;
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.tableView.backgroundColor=UIColorFromRGB(0xf0f0f0);
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LikeListCell class]) bundle:nil] forCellReuseIdentifier:@"likelistcell"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _InfoList=[NSMutableArray array];
    
    [self setbeginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:MSG_REFRESH_CIRCLE_MYRELEASE_LIST object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _InfoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LikeListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"likelistcell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict=_InfoList[indexPath.row];
    cell.nameLab.text=[dict getObjectByKey:@"UserName"];
    cell.timeLab.text=[NSString stringWithFormat:@"发布时间：%@",[dict getObjectByKey:@"CreateTime"]];
    cell.themeLab.text=[NSString stringWithFormat:@"主题：%@",[dict getObjectByKey:@"Title"]];
    cell.descLab.text=[NSString stringWithFormat:@"简介：%@",[dict getObjectByKey:@"Introduction"]];
    [cell.iconImg setImageWithURL:[NSURL URLWithString:[dict getObjectByKey:@"LogoUrl"]] placeholderImage:[UIImage imageNamed:@""]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"--------");
    
    NSDictionary *dict=_InfoList[indexPath.row];
//    
    CircleMyReleaseDetailController *detaicontroller=[[CircleMyReleaseDetailController alloc] init];
    detaicontroller.type=[dict getObjectByKey:@"Type"];
    detaicontroller.circleInfo=dict;
    [self.navigationController pushViewController:detaicontroller animated:YES];
}


#pragma mark - 响应方法
- (IBAction)goback:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    [[AFAppDotNetAPIClient sharedClient] POST:perlist.URLEncodedString parameters:@{@"UserId":_myapp.user.ID,@"Start":[NSString stringWithFormat:@"%lu",(unsigned long)_InfoList.count]} success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.footer endRefreshing];
        
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSArray *array=responseObject[@"data"];
            for (NSDictionary *dict in array) {
                [_InfoList addObject:dict];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
    
}

-(void)refreshData
{
    [[AFAppDotNetAPIClient sharedClient] POST:perlist.URLEncodedString parameters:@{@"UserId":_myapp.user.ID,@"Start":@"0"} success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.header endRefreshing];
        _InfoList=[NSMutableArray array];
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            NSArray *temarr=responseObject[@"data"];
            for (NSDictionary *dict in temarr) {
                [_InfoList addObject:dict];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.header endRefreshing];
        NSLog(@"%@",error.debugDescription);
    }];
}
@end
