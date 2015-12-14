//
//  MessageCenterController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/27.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MessageCenterController.h"
#import "AFAppDotNetAPIClient.h"
#import "MessageCenterCell.h"
#import "NSString+URLEncoding.h"
#import "MessageOfMessageCenter.h"
#import "Mydefine.h"
#import "AppDelegate.h"

@interface MessageCenterController ()<UITableViewDataSource,UITableViewDelegate>
{
//    NSMutableArray *_datas;
    AppDelegate *_myapp;
}

@end

@implementation MessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myapp=[UIApplication sharedApplication].delegate;
    self.tableview.backgroundColor=UIColorFromRGB(0xF7F7F7);
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableview.contentInset=UIEdgeInsetsMake(10, 0, 10, 0);
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.automaticallyAdjustsScrollViewInsets=NO;
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

- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---UITableViewDataSource---

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myapp.messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCenterCell *cell=[tableView dequeueReusableCellWithIdentifier:@"messagecentercell"];
    if (cell==nil) {
        cell=[[UINib nibWithNibName:@"MessageCenterCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    }
    
    MessageOfMessageCenter *message=_myapp.messages[indexPath.row];
    cell.titleLab.text=message.title;
    cell.contentLab.text=message.content;
    cell.dateLab.text=message.date;
    cell.readedImg.image=message.isRead?[UIImage imageNamed:@"messagecenter_dian_yidu.png"]:[UIImage imageNamed:@"messagecenter_dian.png"];
    cell.backgroundColor=tableView.backgroundColor;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageOfMessageCenter *message=_myapp.messages[indexPath.row];
    return message.cellheight;
}

#pragma mark ---UITableViewDelegate---

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageOfMessageCenter *message=_myapp.messages[indexPath.row];
    message.selected=!message.selected;
    message.isRead=YES;
    
    if (_myapp.user) {
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:_myapp.user.ID forKey:@"UserId"];
        [dict setObject:message.ID forKey:@"Id"];
        [[AFAppDotNetAPIClient sharedClient] POST:ReadMessage parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.debugDescription);
        }];
    }
    
    if (message.selected) {//根据内容确定高度
        MessageCenterCell *cell=(MessageCenterCell *)[tableView cellForRowAtIndexPath:indexPath];
//        CGSize size = CGSizeMake(cell.contentLab.frame.size.width,10000);  //设置宽高，其中高为允许的最大高度
//        CGSize labelsize = [message.content sizeWithFont:cell.contentLab.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize labelsize=[cell.contentLab sizeThatFits:CGSizeMake(cell.contentLab.frame.size.width, MAXFLOAT)];

        message.cellheight+=labelsize.height>40.0?labelsize.height-40.0:0.0;
    }else
    {
        message.cellheight=120.0;
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
