//
//  QuanziController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/25.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "QuanziController.h"
#import "UIView+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "Mydefine.h"
#import "UIView+RoundRectView.h"
#import "MessageFormat.h"
#import "CircleLikeCell.h"
#import "NSDictionary+GetObjectBykey.h"
#import "LikeListController.h"
#import "AddCircleMessageController.h"
#import "MJRefresh.h"
#import "CircleListView.h"
#import "LikeListCell.h"
#import "CircleDetailController.h"
#import "CircleMyReleaseController.h"

@interface QuanziController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *_likeList;
    NSInteger _currentItemIndex;
    CircleListView *_listView;
    
    NSMutableArray *_workList;
    NSMutableArray *_businessList;
    
    CGPoint _workOffset;
    CGPoint _businessOffset;
    
    UIView *_searchzhedang;
}
@property(nonatomic,retain)UICollectionView *collectionView;
@end

@implementation QuanziController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.view.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.titleView.backgroundColor=self.view.backgroundColor;
    
    self.myreleaseBtn.backgroundColor=[UIColor whiteColor];
    [self.myreleaseBtn setTitleColor:UIColorFromRGB(MAIN_COLOR_VALUE) forState:UIControlStateNormal];
    [self.myreleaseBtn setCircleCorner];
    
    [self.myreleaseBtn setcornerRadius:10.0];
    
    UITapGestureRecognizer *xingquTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemBeClicked:)];
    self.xingquView.userInteractionEnabled=YES;
    [self.xingquView addGestureRecognizer:xingquTap];
    
    UITapGestureRecognizer *gongzuoTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemBeClicked:)];
    self.gongzuoView.userInteractionEnabled=YES;
    [self.gongzuoView addGestureRecognizer:gongzuoTap];
    
    UITapGestureRecognizer *shangwuTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemBeClicked:)];
    self.shangwuView.userInteractionEnabled=YES;
    [self.shangwuView addGestureRecognizer:shangwuTap];
    
    
    [self createBottomListView];
    
    _workList=[NSMutableArray array];
    _businessList=[NSMutableArray array];
    
    _currentItemIndex=0;
    self.xingquBottomImg.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.gongzuoBottomImg.backgroundColor=self.xingquBottomImg.backgroundColor;
    self.shangwuBottomImg.backgroundColor=self.xingquBottomImg.backgroundColor;
    [self changeItemWithIndex:_currentItemIndex];
    
    [self setbeginRefreshing];
}
#pragma mark -

#pragma mark -------------------------------

- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor
{
    UIView *searchTextField = nil;
    
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    _listView.searchBar.barTintColor = [UIColor whiteColor];
    searchTextField = [[[_listView.searchBar.subviews firstObject] subviews] lastObject];
    
    
    searchTextField.backgroundColor = backgroundColor;
}

-(void)createBottomListView
{
    CGFloat bottomWidth=[UIScreen mainScreen].bounds.size.width;
    CGFloat bottomHeight=[UIScreen mainScreen].bounds.size.height-64-bottomWidth*3/8;
    
    _listView=[[UINib nibWithNibName:NSStringFromClass([CircleListView class]) bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _listView.frame=CGRectMake(0, 0, bottomWidth, bottomHeight);
    _listView.backgroundColor=UIColorFromRGB(0xf0f0f0);
    _listView.searchBar.backgroundColor=_listView.backgroundColor;
    _listView.searchBar.delegate=self;
    [self.bottomView addSubview:_listView];
    
    _listView.searchBar.backgroundImage=[UIImage imageNamed:@"circleSearchBackground.png"];
//    [self setSearchTextFieldBackgroundColor:UIColorFromRGB(0xececec)];
    
    [_listView.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LikeListCell class]) bundle:nil] forCellReuseIdentifier:@"likelistcell"];
    _listView.tableView.dataSource=self;
    _listView.tableView.delegate=self;
    
    CGFloat itemjiange=10.0f;
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    CGFloat cellwidth=(self.view.frame.size.width-itemjiange*3)/2;
    CGFloat cellheight=cellwidth*9/16;
    layout.itemSize=CGSizeMake(cellwidth,cellheight);
    layout.sectionInset=UIEdgeInsetsMake(itemjiange, itemjiange,itemjiange,itemjiange);
    layout.minimumInteritemSpacing=itemjiange;
    layout.minimumLineSpacing=itemjiange;
//    self.collectionView.collectionViewLayout=layout;
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, bottomWidth, bottomHeight) collectionViewLayout:layout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor=[UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CircleLikeCell class]) bundle:nil] forCellWithReuseIdentifier:@"circlelikecell"];
    
    [self.bottomView addSubview:self.collectionView];
}

-(void)changeItemWithIndex:(NSInteger)index
{
    _listView.searchBar.text=nil;
    switch (_currentItemIndex) {
        case 1:
        {
            _workOffset=_listView.tableView.contentOffset;
            break;
        }
        case 2:
        {
            _businessOffset=_listView.tableView.contentOffset;
            break;
        }
            
        default:
            break;
    }
    
    _currentItemIndex=index;
    switch (_currentItemIndex) {
        case 0:
        {
            self.xingquImg.image=[UIImage imageNamed:@"xingqu_press.png"];
            self.xingquLab.textColor=UIColorFromRGB(MAIN_COLOR_VALUE);
            
            self.gongzuoImg.image=[UIImage imageNamed:@"gongzuo_normal.png"];
            self.gongzuoLab.textColor=UIColorFromRGB(0xd5d5d5);
            
            self.shangwuImg.image=[UIImage imageNamed:@"shangwu_normal.png"];
            self.shangwuLab.textColor=UIColorFromRGB(0xd5d5d5);
            
            self.xingquBottomImg.hidden=NO;
            self.gongzuoBottomImg.hidden=YES;
            self.shangwuBottomImg.hidden=YES;
            
            self.collectionView.hidden=NO;
            _listView.hidden=YES;
            [self.bottomView bringSubviewToFront:self.collectionView];
            
            break;
        }
        case 1:
        {
            self.xingquImg.image=[UIImage imageNamed:@"xingqu_normal.png"];
            self.xingquLab.textColor=UIColorFromRGB(0xd5d5d5);
            
            self.gongzuoImg.image=[UIImage imageNamed:@"gongzuo_press.png"];
            self.gongzuoLab.textColor=UIColorFromRGB(MAIN_COLOR_VALUE);
            
            self.shangwuImg.image=[UIImage imageNamed:@"shangwu_normal.png"];
            self.shangwuLab.textColor=UIColorFromRGB(0xd5d5d5);
            
            self.xingquBottomImg.hidden=YES;
            self.gongzuoBottomImg.hidden=NO;
            self.shangwuBottomImg.hidden=YES;
            
            self.collectionView.hidden=YES;
            _listView.hidden=NO;
            [self.bottomView bringSubviewToFront:_listView];
            
            if (_workList.count<1) {
                [_listView.tableView.header beginRefreshing];
                [self refreshTableViewData];
            }else{
                [_listView.tableView reloadData];
                _listView.tableView.contentOffset=_workOffset;
            }
            
            break;
        }
        case 2:
        {
            self.xingquImg.image=[UIImage imageNamed:@"xingqu_normal.png"];
            self.xingquLab.textColor=UIColorFromRGB(0xd5d5d5);
            
            self.gongzuoImg.image=[UIImage imageNamed:@"gongzuo_normal.png"];
            self.gongzuoLab.textColor=UIColorFromRGB(0xd5d5d5);
            
            self.shangwuImg.image=[UIImage imageNamed:@"shangwu_press.png"];
            self.shangwuLab.textColor=UIColorFromRGB(MAIN_COLOR_VALUE);
            
            self.xingquBottomImg.hidden=YES;
            self.gongzuoBottomImg.hidden=YES;
            self.shangwuBottomImg.hidden=NO;
            
            self.collectionView.hidden=YES;
            _listView.hidden=NO;
            [self.bottomView bringSubviewToFront:_listView];
            
            
            if (_businessList.count<1) {
                [_listView.tableView.header beginRefreshing];
                [self refreshTableViewData];
            }else{
                [_listView.tableView reloadData];
                _listView.tableView.contentOffset=_businessOffset;
            }
            
            break;
        }
        default:
            break;
    }
}
#pragma mark -------------------------------


#pragma mark - 响应方法
- (IBAction)showmenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)addMessage:(UIButton *)sender {
    UINavigationController *nav=[[UIStoryboard storyboardWithName:@"Quanzi" bundle:nil] instantiateViewControllerWithIdentifier:@"addcirclrmessagenavcontroller"];
    nav.navigationBar.barTintColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    AddCircleMessageController *addcirclecontroller=(AddCircleMessageController *)nav.topViewController;
    addcirclecontroller.typeList=[NSArray arrayWithArray:_likeList];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)myReleaseList:(UIButton *)sender {
    UINavigationController *nav=[[UIStoryboard storyboardWithName:@"Quanzi" bundle:nil] instantiateViewControllerWithIdentifier:@"circleMyReleaseNavController"];
    nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)itemBeClicked:(UITapGestureRecognizer *)gesture
{
    if (gesture.view.tag==_currentItemIndex) {
        return;
    }
    [self changeItemWithIndex:gesture.view.tag];
}
#pragma mark - UICollectionView数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _likeList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleLikeCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"circlelikecell" forIndexPath:indexPath];
    
    NSDictionary *dict=_likeList[indexPath.item];
    
    cell.nameLab.textColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    cell.nameLab.text=[dict getObjectByKey:@"InterestName"];
    [cell.iconView setImageWithURL:[NSURL URLWithString:[dict getObjectByKey:@"img"]] placeholderImage:[UIImage imageNamed:@""]];
    
    cell.backgroundColor=[UIColor whiteColor];
    [cell setcornerRadius:5.0];
    return cell;
}


#pragma mark - UICollectionView代理方法


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
     NSDictionary *dict=_likeList[indexPath.item];
    UINavigationController *nav=[[UIStoryboard storyboardWithName:@"Quanzi" bundle:nil] instantiateViewControllerWithIdentifier:@"likelistnavcontroller"];
    nav.navigationBar.barTintColor=UIColorFromRGB(MAIN_COLOR_VALUE);
//    nav.navigationBar.translucent=NO;
//    [nav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    nav.navigationBar.shadowImage=[[UIImage alloc] init];
    LikeListController *likecontroller=(LikeListController *)nav.topViewController;
    likecontroller.interestID=[dict getObjectByKey:@"id"];
    likecontroller.navigationItem.title=[dict getObjectByKey:@"InterestName"];
    [self presentViewController:nav animated:YES completion:nil];
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
    self.collectionView.header = header;
    
    MJRefreshNormalHeader *tableViewheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableViewData)];
    [tableViewheader setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [tableViewheader setTitle:@"松开马上刷新" forState:MJRefreshStatePulling];
    [tableViewheader setTitle:@"刷新中 ..." forState:MJRefreshStateRefreshing];
    _listView.tableView.header = tableViewheader;
    
}


-(void)refreshData
{
    [[AFAppDotNetAPIClient sharedClient] POST:interes.URLEncodedString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.collectionView.header endRefreshing];
        _likeList=[NSMutableArray array];
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            [_likeList addObjectsFromArray:responseObject[@"data"]];
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.header endRefreshing];
        NSLog(@"%@",error.debugDescription);
    }];
}

-(void)refreshTableViewData
{
    if (_currentItemIndex==1) {
        [[AFAppDotNetAPIClient sharedClient] POST:wblist parameters:@{@"Type":@"2",@"Start":@"0",@"Name":_listView.searchBar.text} success:^(NSURLSessionDataTask *task, id responseObject) {
            [_listView.tableView.header endRefreshing];
            [_workList removeAllObjects];
            NSNumber *statusCode=responseObject[@"code"];
            if (statusCode.intValue==0) {
                for (NSDictionary *dict in responseObject[@"data"]) {
                    [_workList addObject:dict];
                }
            } else {
                [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
            }
            [_listView.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_listView.tableView.header endRefreshing];
        }];
    } else if(_currentItemIndex==2){
        [[AFAppDotNetAPIClient sharedClient] POST:wblist parameters:@{@"Type":@"3",@"Start":@"0",@"Name":_listView.searchBar.text} success:^(NSURLSessionDataTask *task, id responseObject) {
            [_listView.tableView.header endRefreshing];
            [_businessList removeAllObjects];
            NSNumber *statusCode=responseObject[@"code"];
            if (statusCode.intValue==0) {
                for (NSDictionary *dict in responseObject[@"data"]) {
                    [_businessList addObject:dict];
                }
            } else {
                [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
            }
            [_listView.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_listView.tableView.header endRefreshing];
        }];
    }
}

#pragma mark - UITableView数据源方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentItemIndex==1?_workList.count:_businessList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LikeListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"likelistcell" forIndexPath:indexPath];
    
    NSDictionary *dict=_currentItemIndex==1?_workList[indexPath.row]:_businessList[indexPath.row];
    
    cell.timeLab.text=[NSString stringWithFormat:@"发布时间：%@",[dict getObjectByKey:@"CreateTime"]];
    cell.themeLab.text=[NSString stringWithFormat:@"主题：%@",[dict getObjectByKey:@"Title"]];
    cell.descLab.text=[NSString stringWithFormat:@"简介：%@",[dict getObjectByKey:@"Introduction"]];
    [cell.iconImg setImageWithURL:[NSURL URLWithString:[dict getObjectByKey:@"LogoUrl"]] placeholderImage:[UIImage imageNamed:@""]];
    return cell;
}
#pragma mark - UITableView代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict=_currentItemIndex==1?_workList[indexPath.row]:_businessList[indexPath.row];
    
    UINavigationController *nav=[[UIStoryboard storyboardWithName:@"Quanzi" bundle:nil] instantiateViewControllerWithIdentifier:@"circeldetailnavcontroller"];
    nav.navigationBar.barTintColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    
    CircleDetailController *detaicontroller=(CircleDetailController *)nav.topViewController;
    detaicontroller.circleID=[dict getObjectByKey:@"InId"];
    detaicontroller.type=_currentItemIndex==1?@"2":@"3";;
    detaicontroller.navigationItem.title=_currentItemIndex==1?@"工作详情":@"商务详情";
    [self presentViewController:nav animated:YES completion:nil];
    
}
#pragma mark - UISearchBar代理方法

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (_searchzhedang==nil) {
        _searchzhedang=[[UIView alloc] initWithFrame:_listView.tableView.frame];
        _searchzhedang.backgroundColor=[UIColor blackColor];
        _searchzhedang.alpha=0.7;
        _searchzhedang.userInteractionEnabled=YES;
        [_listView addSubview:_searchzhedang];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endsearch)];
        [_searchzhedang addGestureRecognizer:tap];
    }
    return YES;
}

-(void)endsearch
{
    if (_searchzhedang) {
        [_searchzhedang removeFromSuperview];
        _searchzhedang=nil;
    }
    [_listView.searchBar endEditing:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length<1) {
        [self refreshTableViewData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self endsearch];
    
    if (_currentItemIndex==1) {
        [MessageFormat POST:wblist parameters:@{@"Type":@"2",@"Start":@"0",@"Name":_listView.searchBar.text} success:^(NSURLSessionDataTask *task, id responseObject) {
            [_listView.tableView.header endRefreshing];
            [_workList removeAllObjects];
            NSNumber *statusCode=responseObject[@"code"];
            if (statusCode.intValue==0) {
                for (NSDictionary *dict in responseObject[@"data"]) {
                    [_workList addObject:dict];
                }
            } else {
                [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
            }
            [_listView.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_listView.tableView.header endRefreshing];
        } incontroller:self view:_listView.tableView];
    } else if(_currentItemIndex==2){
        [MessageFormat POST:wblist parameters:@{@"Type":@"3",@"Start":@"0",@"Name":_listView.searchBar.text} success:^(NSURLSessionDataTask *task, id responseObject) {
            [_listView.tableView.header endRefreshing];
            [_businessList removeAllObjects];
            NSNumber *statusCode=responseObject[@"code"];
            if (statusCode.intValue==0) {
                for (NSDictionary *dict in responseObject[@"data"]) {
                    [_businessList addObject:dict];
                }
            } else {
                [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:nil];
            }
            [_listView.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_listView.tableView.header endRefreshing];
        } incontroller:self view:_listView.tableView];
    }

    [searchBar endEditing:YES];
}


@end
