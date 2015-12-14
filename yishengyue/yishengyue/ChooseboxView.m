//
//  ChooseboxView.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ChooseboxView.h"
#import "Airbox.h"
#define TOPJIAN_HEIGHT 10.0

@implementation ChooseboxView


-(id)initWithFrame:(CGRect)frame items:(NSMutableArray *)items
{
    if (self=[super initWithFrame:frame]) {
        self.boxes=items;
        
        UIImageView *topjian=[[UIImageView alloc] init];
        topjian.bounds=CGRectMake(0, 0, TOPJIAN_HEIGHT*1.5, TOPJIAN_HEIGHT);
        topjian.center=CGPointMake( frame.size.width/2, TOPJIAN_HEIGHT/2);
        topjian.backgroundColor=[UIColor clearColor];
        topjian.image=[UIImage imageNamed:@"hinttop.png"];
        [self addSubview:topjian];
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, TOPJIAN_HEIGHT, frame.size.width, frame.size.height-TOPJIAN_HEIGHT)];
        view.backgroundColor=[UIColor blackColor];
        [self addSubview:view];
        
        self.tv=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height-TOPJIAN_HEIGHT)];
        self.tv.dataSource=self;
        self.tv.delegate=self;
        self.tv.bounces=NO;
        self.tv.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.tv.backgroundColor=[UIColor blackColor];
        self.tv.contentInset=UIEdgeInsetsMake(10, 0, 0, 0);
        [view addSubview:self.tv];
//        [self setExtraCellLineHidden:self.tv];
        
//        UIButton *addboxBtn=[[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width/20, view.frame.size.height-35, view.frame.size.width*9/10, 30.0)];
//        [addboxBtn setTitle:@"配置其他盒子" forState:UIControlStateNormal];
//        addboxBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];
//        addboxBtn.backgroundColor=[UIColor darkGrayColor];
//        addboxBtn.layer.masksToBounds=YES;
//        addboxBtn.layer.cornerRadius=5.0;
//        [addboxBtn addTarget:self.mydelagate action:@selector(configbox) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:addboxBtn];
        
        self.alpha=0.8;
        self.backgroundColor=[UIColor clearColor];
        view.layer.masksToBounds=YES;
        view.layer.cornerRadius=10.0;
    }
    return self;
}


/****tableview数据源方法*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.boxes.count<1) 
//        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    else
//        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    return self.boxes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const chooseviewreuseIdentifier=@"boxlistcell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:chooseviewreuseIdentifier];
    if (cell==nil) {
               cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chooseviewreuseIdentifier];
    }
    Airbox *box=self.boxes[indexPath.row];
    cell.textLabel.text=box.name;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font=[UIFont systemFontOfSize:18.0];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.backgroundColor=self.backgroundColor;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}


/****tableview代理方法*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.chooseboxblock) {
        self.chooseboxblock((int)indexPath.row);
    }
}
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}
@end
