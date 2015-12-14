//
//  FamilyController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/4.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "FamilyController.h"
#import "AddMemberController.h"
#import "FamilyMember.h"
#import "AppDelegate.h"
#import "FamilyCell.h"
#import "AFAppDotNetAPIClient.h"
#import "EditMemberController.h"
#import "MessageFormat.h"
#import "Mydefine.h"

#define FAMILYMEMBER_CELL @"familycell"

@interface FamilyController ()<FamilyCellDelegate>
{
    NSMutableArray *_members;
}
@end

@implementation FamilyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=UIColorFromRGB(0xececec);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *myapp=[UIApplication sharedApplication].delegate;
    _members=myapp.familymembers;
    [self.tableView reloadData];
}

- (IBAction)addFamilymember:(id)sender {
    AddMemberController *add=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"addmembercontroller"];
    [self.navigationController pushViewController:add animated:YES];
}

- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _members.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FamilyMember *member=_members[indexPath.row];
    if (member.selected) {
        return 170.0;
    }
    return 130.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FamilyCell *cell = [tableView dequeueReusableCellWithIdentifier:FAMILYMEMBER_CELL];
    if (cell==nil) {
        cell=[[UINib nibWithNibName:@"FamilyCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    }
    
    // Configure the cell...
    FamilyMember *member=_members[indexPath.row];
    
    cell.contentView.backgroundColor=tableView.backgroundColor;
    cell.nameLab.text=member.name;
    cell.birthdayLab.text=member.birthday;
    cell.ageLab.text=member.age;
    cell.relationshipLab.text=member.relationship;
    cell.phoneLab.text=member.phoneNum;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.mydelegate=self;
    cell.editView.hidden=!member.selected;

    
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FamilyMember *nowmember=_members[indexPath.row];
    nowmember.selected=!nowmember.selected;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - FamilyCell代理方法

-(void)editMember:(FamilyCell *)cell
{
    NSIndexPath *indexpath=[self.tableView indexPathForCell:cell];
    EditMemberController *edit=[[UIStoryboard storyboardWithName:@"Autolayout" bundle:nil] instantiateViewControllerWithIdentifier:@"editmembercontroller"];
    edit.member=_members[indexpath.row];
    [self.navigationController pushViewController:edit animated:YES];
}

-(void)deleteMember:(FamilyCell *)cell
{
    NSIndexPath *indexpath=[self.tableView indexPathForCell:cell];
    FamilyMember *m=_members[indexpath.row];
    
    [MessageFormat POST:DeleteFamily parameters:@{@"FamilyId":m.ID} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *statuscode=responseObject[@"code"];
        [MessageFormat hintWithMessage:responseObject[@"message"] inview:self.view completion:^(){
            if (statuscode.intValue==0) {
                [_members removeObjectAtIndex:indexpath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self view:self.view];
}
@end
