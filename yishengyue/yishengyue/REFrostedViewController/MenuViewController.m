//
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "Mydefine.h"
#import "ChuangyeController.h"
#import "MycontainerController.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

#define SEPARATOR_HEIGHT 0.5

@interface MenuViewController()
{
    NSArray *_menuItems;
    NSArray *_menuImageStrings;
    UIImageView *_touxiangimageview;
    UILabel *_nameLab;
}

@end

@implementation MenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    
    _menuItems = @[@"智慧家", @"一键创业",@"生态商城",@"邻里圈子"];
    _menuImageStrings=@[@"menu_home.png",@"menu_start.png",@"menu_shop.png",@"menu_circle.png"];
    
//    _menuItems = @[@"智慧家",@"生态商城",@"邻里圈子"];
//    _menuImageStrings=@[@"menu_home.png",@"menu_shop.png",@"menu_circle.png"];
    
    [self setExtraCellLineHidden:self.tableView];
    self.tableView.separatorColor = UIColorFromRGB(0x878381);
    self.tableView.bounces=NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.92];
//    self.tableView.alpha=0.8;
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        _touxiangimageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        _touxiangimageview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [_touxiangimageview setImageWithURL:[NSURL URLWithString:myapp.user.logoURLString]];
        _touxiangimageview.layer.masksToBounds = YES;
        _touxiangimageview.layer.cornerRadius = 50.0;
        _touxiangimageview.layer.borderColor = [UIColor whiteColor].CGColor;
        _touxiangimageview.layer.borderWidth = 3.0f;
        _touxiangimageview.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _touxiangimageview.layer.shouldRasterize = YES;
        _touxiangimageview.clipsToBounds = YES;
        _touxiangimageview.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gerenzhongxin)];
        [_touxiangimageview addGestureRecognizer:tap];
        
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        _nameLab.text =myapp.user.username;
        _nameLab.font = [UIFont systemFontOfSize:21];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = [UIColor whiteColor];
        [_nameLab sizeToFit];
        _nameLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:_touxiangimageview];
        [view addSubview:_nameLab];
        view;
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [_touxiangimageview setImageWithURL:[NSURL URLWithString:myapp.user.logoURLString]];
    _nameLab.text=myapp.user.username;
    [_nameLab sizeToFit];
    _nameLab.center=CGPointMake(self.tableView.frame.size.width/2, _nameLab.center.y);
}
-(void)gerenzhongxin
{
    MycontainerController *navigationController = (MycontainerController *)self.frostedViewController.contentViewController;
    [navigationController changeViewcontrollerWithIndex:(int)_menuItems.count];
    
    [self.frostedViewController hideMenuViewController];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.font = [UIFont fontWithName:myapp.user.username size:17];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,SEPARATOR_HEIGHT)];
    view.backgroundColor = tableView.separatorColor;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return SEPARATOR_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row%2!=1) {
        MycontainerController *navigationController = (MycontainerController *)self.frostedViewController.contentViewController;
        [navigationController changeViewcontrollerWithIndex:(int)indexPath.row];
        
        [self.frostedViewController hideMenuViewController];
//    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    

    
    cell.textLabel.text = _menuItems[indexPath.row];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.imageView.image=[UIImage imageNamed:_menuImageStrings[indexPath.row]];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//if (indexPath.row%2!=1) {
        UIView *view=[[UIView alloc] initWithFrame:cell.bounds];
        view.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
        [cell setSelectedBackgroundView:view];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
//    }
    
    return cell;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}
@end
