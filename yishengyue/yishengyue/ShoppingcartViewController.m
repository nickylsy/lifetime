//
//  ShoppingcartViewController.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/23.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ShoppingcartViewController.h"
#import "ShoppingcartTableViewCell.h"
#import "Mydefine.h"
#import "QuerenDingdanController.h"
#import "CartShop.h"
#import "MessageFormat.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"

@interface ShoppingcartViewController ()
{
    NSMutableArray *_goods;
}
@end

@implementation ShoppingcartViewController

static NSString * const tableviewreuseIdentifier=@"shoppingcartcell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor=UIColorFromRGB(0xf6f6f6);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.deleteBtn.imageView.contentMode=self.backBtn.imageView.contentMode;
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [MessageFormat POST:ShoppingCartList parameters:@{@"UserId":myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        if (statuscode.intValue==0) {
            _goods=[NSMutableArray array];
            
            for (NSDictionary *dict in responseObject[@"data"][@"list"]) {
                CartShop *shop=[CartShop cartshopWithDict:dict];
                [_goods addObject:shop];
            }
            [self.tableview reloadData];
        }
    } failure:nil incontroller:self view:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTotalPrice
{
    float total=0.0;
    for (CartShop *c in _goods) {
        if (c.selected) {
            total+=[c.price substringFromIndex:1].floatValue*c.shopNum.intValue;
        }
    }
    self.totalLab.text=[NSString stringWithFormat:@"合计:￥%.2f",total];
}
#pragma mark - tableview数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _goods.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingcartTableViewCell *cell=(ShoppingcartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableviewreuseIdentifier];
    if (cell==nil) {
        NSArray *arr=[[UINib nibWithNibName:@"ShoppingcartTableViewCell" bundle:nil] instantiateWithOwner:nil options:nil];
        cell=arr.firstObject;
    }
    
    CartShop *c=_goods[indexPath.row];
    
    cell.titleLab.text=c.name;
    cell.priceLab.text=c.price;
    [cell.logoimageview setImageWithURL:[NSURL URLWithString:c.banner.URLEncodedString]];
    cell.numberLab.text=[NSString stringWithFormat:@"x%@",c.shopNum];
    cell.choiceImg.image=c.selected?[UIImage imageNamed:@"choice_ok.png"]:[UIImage imageNamed:@"choice_null.png"];
    cell.backgroundColor=tableView.backgroundColor;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}


#pragma mark - tableview代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CartShop *c=_goods[indexPath.row];
    c.selected=!c.selected;
    
    ShoppingcartTableViewCell *cell=(ShoppingcartTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.choiceImg.image=c.selected?[UIImage imageNamed:@"choice_ok.png"]:[UIImage imageNamed:@"choice_null.png"];
    
    BOOL noselected=YES;
    for (CartShop *c in _goods) {
        if (c.selected==YES) {
            noselected=NO;
            break;
        }
    }
    
    self.buyBtn.enabled=noselected?NO:YES;
    
    BOOL selectedall=YES;
    for (CartShop *c in _goods) {
        if (c.selected==NO) {
            selectedall=NO;
            break;
        }
    }
    [self.selectAllBtn setImage:selectedall?[UIImage imageNamed:@"choice_ok.png"]:[UIImage imageNamed:@"choice_null.png"]forState:UIControlStateNormal];
    [self refreshTotalPrice];
}

#pragma mark - 

- (IBAction)goback:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)querendingdan:(UIButton *)sender {
    QuerenDingdanController *queren=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"querendingdancontroller"];
    queren.totalstring=self.totalLab.text;
    queren.clearcart=YES;
    queren.goods=[NSMutableArray array];
    for (CartShop *c in _goods) {
        if (c.selected) {
            [queren.goods addObject:c];
        }
    }
    [self.navigationController pushViewController:queren animated:YES];
}

- (IBAction)selectAll:(UIButton *)sender {
    BOOL selectedall=YES;
    for (CartShop *c in _goods) {
        if (c.selected==NO) {
            selectedall=NO;
            break;
        }
    }
    
    
    for (CartShop *c in _goods) {
        c.selected=selectedall?NO:YES;
    }
    
    [self.tableview reloadData];
    [self refreshTotalPrice];
    
    self.buyBtn.enabled=!selectedall?YES:NO;
    [self.selectAllBtn setImage:!selectedall?[UIImage imageNamed:@"choice_ok.png"]:[UIImage imageNamed:@"choice_null.png"]forState:UIControlStateNormal];
}

- (IBAction)deleteShop:(UIButton *)sender {
    NSMutableString *cartid=[[NSMutableString alloc] init];
    NSMutableArray *temarray=[NSMutableArray array];
    for (CartShop *c in _goods) {
        if (c.selected) {
            [cartid appendFormat:@"%@,",c.cartID];
            [temarray addObject:c];
        }
    }
    if (temarray.count<1) {
        return;
    }
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    [MessageFormat POST:DeleteShoppingCart parameters:@{@"CartId":[cartid substringWithRange:NSMakeRange(0, cartid.length-1)],@"UserId":myapp.user.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        [_goods removeObjectsInArray:temarray];
        [self.tableview reloadData];
        [self refreshTotalPrice];
         [self.selectAllBtn setImage:[UIImage imageNamed:@"choice_null.png"]forState:UIControlStateNormal];
    } failure:nil incontroller:self view:self.view];
}
@end
