//
//  MyshopsController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/14.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MyshopsController.h"
#import "Mydefine.h"
#import "MyshopsCell.h"
#import "MessageFormat.h"
#import "AppDelegate.h"
#import "LL_Goods.h"
#import "AFAppDotNetAPIClient.h"
#import "UIViewController+ActivityHUD.h"
#import "UIImageView+AFNetworking.h"
#import "WKAlertView.h"
#import "MJRefresh.h"
#import "EditShopController.h"
#import "AddShopController.h"
#import "XiajiaHintView.h"
#import "UndercarriageDetailController.h"

#define MYSHOPSREUSEIDENTIFIER @"myshopscell"

@interface MyshopsController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    CGPoint _sellingOffset;
    CGPoint _undercarriageOffset;
    
    NSMutableArray *_sellingShops;
    NSMutableArray *_undercarriageShops;
    
    UIWindow *_warningWindow;
    AppDelegate *_myapp;
}
@end

@implementation MyshopsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.addBtn.imageView.contentMode=self.backBtn.imageView.contentMode;
    
    self.shopsSgm.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.shopsSgm.layer.masksToBounds=YES;
    self.shopsSgm.layer.borderColor=[UIColor whiteColor].CGColor;
    self.shopsSgm.layer.cornerRadius=self.shopsSgm.frame.size.height/2;
    self.shopsSgm.layer.borderWidth=1.0;
    
    
    _sellingOffset=CGPointZero;
    _undercarriageOffset=CGPointZero;
    
    
    _myapp=[UIApplication sharedApplication].delegate;
    
//    [MessageFormat POST:NeighborShopListByUserId parameters:@{@"UserId":_myapp.user.ID,@"Type":@"1"} success:^(NSURLSessionDataTask *task, id responseObject) {
//        _sellingRequestOK=YES;
//        NSNumber *statuscode=responseObject[@"code"];
//        if (statuscode.intValue==0) {
//            _sellingShops=[NSMutableArray array];
//            for (NSDictionary *dict in responseObject[@"data"]) {
//                LL_Goods *g=[LL_Goods goodsWithDict:dict];
//                [_sellingShops addObject:g];
//            }
//            
//            if (_sellingRequestOK&&_undercarriageRequestOK) {
//                [self.tableView reloadData];
//            }
//        }
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error.debugDescription);
//    } incontroller:self view:self.tableView];
//    
//
//    [[AFAppDotNetAPIClient sharedClient] POST:NeighborShopListByUserId.URLEncodedString parameters:@{@"UserId":_myapp.user.ID,@"Type":@"2"} success:^(NSURLSessionDataTask *task, id responseObject) {
//        _undercarriageRequestOK=YES;
//        NSNumber *statuscode=responseObject[@"code"];
//        if (statuscode.intValue==0) {
//            _undercarriageShops=[NSMutableArray array];
//            for (NSDictionary *dict in responseObject[@"data"]) {
//                LL_Goods *g=[LL_Goods goodsWithDict:dict];
//                [_undercarriageShops addObject:g];
//            }
//            
//            if (_sellingRequestOK&&_undercarriageRequestOK) {
//                [self.tableView reloadData];
//            }
//        }
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error.debugDescription);
//    }];
    

    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyshopsCell" bundle:nil] forCellReuseIdentifier:MYSHOPSREUSEIDENTIFIER];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:REFRESH_SHOPLIST object:nil];
    
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

-(void)loadMoreData
{
    switch (self.shopsSgm.selectedSegmentIndex) {
        case 0:
        {
            [[AFAppDotNetAPIClient sharedClient] POST:NeighborShopListByUserId.URLEncodedString parameters:@{@"UserId":_myapp.user.ID,@"Type":@"1",@"Start":[NSString stringWithFormat:@"%lu",(unsigned long)_sellingShops.count]} success:^(NSURLSessionDataTask *task, id responseObject) {
                [self.tableView.footer endRefreshing];
                NSNumber *statuscode=responseObject[@"code"];
                if (statuscode.intValue==0) {
                    for (NSDictionary *dict in responseObject[@"data"]) {
                        LL_Goods *g=[LL_Goods goodsWithDict:dict];
                        [_sellingShops addObject:g];
                    }
                    [self.tableView reloadData];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self.tableView.footer endRefreshing];
                NSLog(@"%@",error.debugDescription);
            }];
            break;
        }
        case 1:
        {
            [[AFAppDotNetAPIClient sharedClient] POST:NeighborShopListByUserId.URLEncodedString parameters:@{@"UserId":_myapp.user.ID,@"Type":@"2",@"Start":[NSString stringWithFormat:@"%lu",(unsigned long)_undercarriageShops.count]} success:^(NSURLSessionDataTask *task, id responseObject) {
                [self.tableView.footer endRefreshing];
                NSNumber *statuscode=responseObject[@"code"];
                if (statuscode.intValue==0) {
                    for (NSDictionary *dict in responseObject[@"data"]) {
                        LL_Goods *g=[LL_Goods goodsWithDict:dict];
                        [_undercarriageShops addObject:g];
                    }
                    [self.tableView reloadData];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self.tableView.footer endRefreshing];
                NSLog(@"%@",error.debugDescription);
            }];
            
            break;
        }
        default:
            break;
    }
}

- (IBAction)changePage:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            _undercarriageOffset=self.tableView.contentOffset;
            
            if (_sellingShops==nil) {
                [self.tableView.header beginRefreshing];
                [self refreshData];
            }else{
                [self.tableView reloadData];
                self.tableView.contentOffset=_sellingOffset;
            }
            
            break;
        }
        case 1:
        {
            _sellingOffset=self.tableView.contentOffset;
            
            if (_undercarriageShops==nil) {
                [self.tableView.header beginRefreshing];
                [self refreshData];
            }else{
                [self.tableView reloadData];
                self.tableView.contentOffset=_undercarriageOffset;
            }
            
            break;
        }
        default:
            break;
    }
    
//    [self.tableView reloadData];
//    
//    self.tableView.contentOffset=sender.selectedSegmentIndex==0?_sellingOffset:_undercarriageOffset;
    
}

- (IBAction)goback:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addShop:(UIButton *)sender {
    AddShopController *a=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"addshopcontroller"];
    a.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    [self.parentViewController presentViewController:a animated:YES completion:nil];
}

#pragma mark - UITableView数据源方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView.frame.size.width-30.0)/1.4+90.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shopsSgm.selectedSegmentIndex==0?_sellingShops.count:_undercarriageShops.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LL_Goods *g=self.shopsSgm.selectedSegmentIndex==0?_sellingShops[indexPath.row]:_undercarriageShops[indexPath.row];
    
    MyshopsCell *cell=[tableView dequeueReusableCellWithIdentifier:MYSHOPSREUSEIDENTIFIER];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    MyshopState state=self.shopsSgm.selectedSegmentIndex==0?MyshopStateSelling:MyshopStateUndercarriage;
    [cell setState:state];
    [cell.picImg setImageWithURL:[NSURL URLWithString:g.pic] placeholderImage:[UIImage imageNamed:@"picture_default_LL.jpg"]];
    cell.titleLab.text=g.name;
    cell.priceLab.text=g.price;
    cell.timeLab.text=[NSString stringWithFormat:@"发布于:%@",g.createTime];
    cell.xiajiaBtn.tag=indexPath.row;
    [cell.xiajiaBtn addTarget:self action:@selector(undercarriageShop:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.editBtn.tag=indexPath.row;
    [cell.editBtn addTarget:self action:@selector(editShop:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.xiangqingBtn.tag=indexPath.row;
    [cell.xiangqingBtn addTarget:self action:@selector(shopdetail:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


#pragma mark - UITableView代理方法

#pragma mark -

-(void)undercarriageShop:(UIButton *)sender
{
    LL_Goods *g=_sellingShops[sender.tag];
    
    __block UIView *view=[[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor=[UIColor blackColor];
    view.alpha=0.8;
    [self.view addSubview:view];
    
    __block XiajiaHintView *xiajiahint=[[UINib nibWithNibName:@"XiajiaHintView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    xiajiahint.titleLab.text=g.name;
    xiajiahint.BeizhuTxt.delegate=self;
    [xiajiahint setCancelBlock:^{
        [xiajiahint removeFromSuperview];
        xiajiahint=nil;
        [view removeFromSuperview];
        view=nil;
    }];
    [xiajiahint setOKBlock:^(NSString *remark){
        [MessageFormat POST:DeleteNeighborShop parameters:@{@"NeighborId":g.ID,@"Remark":remark} success:^(NSURLSessionDataTask *task, id responseObject) {
            NSNumber *statuscode=responseObject[@"code"];
            if (statuscode.intValue==0) {
                
                [_undercarriageShops addObject:[_sellingShops objectAtIndex:sender.tag]];
                [_sellingShops removeObjectAtIndex:sender.tag];
                
//                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView reloadData];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.debugDescription);
        } incontroller:self view:self.view];
    }];
    
    xiajiahint.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:xiajiahint];
}

-(void)editShop:(UIButton *)sender
{
    LL_Goods *g=_sellingShops[sender.tag];
    
    EditShopController *edit=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"editshopcontroller"];
    edit.shopID=g.ID;
    edit.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:edit animated:YES completion:nil];
}

-(void)shopdetail:(UIButton *)sender
{
    LL_Goods *g=_undercarriageShops[sender.tag];
    
    UndercarriageDetailController *detail=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"undercarriagedetailcontroller"];
    detail.shopID=g.ID;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark - UITextView的代理方法

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect frame =CGRectMake(textView.superview.frame.origin.x+textView.frame.origin.x, textView.superview.frame.origin.y+textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height);
    CGFloat offset=self.view.frame.size.height-frame.size.height-frame.origin.y-80;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset <216.0)
        self.view.frame = CGRectMake(0.0f, offset-216.0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - 开始刷新函数
- (void)setbeginRefreshing
{
    self.tableView.header=nil;
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
}


-(void)refreshData
{
    switch (self.shopsSgm.selectedSegmentIndex) {
        case 0:
        {
            [[AFAppDotNetAPIClient sharedClient] POST:NeighborShopListByUserId.URLEncodedString parameters:@{@"UserId":_myapp.user.ID,@"Type":@"1"} success:^(NSURLSessionDataTask *task, id responseObject) {
                [self.tableView.header endRefreshing];
                _sellingShops=[NSMutableArray array];
                NSNumber *statuscode=responseObject[@"code"];
                if (statuscode.intValue==0) {
                    for (NSDictionary *dict in responseObject[@"data"]) {
                        LL_Goods *g=[LL_Goods goodsWithDict:dict];
                        [_sellingShops addObject:g];
                    }
                    
                }
                [self.tableView reloadData];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self.tableView.header endRefreshing];
                 NSLog(@"%@",error.debugDescription);
            }];
            break;
        }
        case 1:
        {
            [[AFAppDotNetAPIClient sharedClient] POST:NeighborShopListByUserId.URLEncodedString parameters:@{@"UserId":_myapp.user.ID,@"Type":@"2"} success:^(NSURLSessionDataTask *task, id responseObject) {
                [self.tableView.header endRefreshing];
                _undercarriageShops=[NSMutableArray array];
                NSNumber *statuscode=responseObject[@"code"];
                if (statuscode.intValue==0) {
                    for (NSDictionary *dict in responseObject[@"data"]) {
                        LL_Goods *g=[LL_Goods goodsWithDict:dict];
                        [_undercarriageShops addObject:g];
                    }
                    
                }
                [self.tableView reloadData];

            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self.tableView.header endRefreshing];
                NSLog(@"%@",error.debugDescription);
            }];
            
            break;
        }
        default:
            break;
    }
}

@end
