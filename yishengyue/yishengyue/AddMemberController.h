//
//  AddMemberController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/4.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMemberController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *ageTxt;
@property (weak, nonatomic) IBOutlet UITextField *relationshipTxt;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITableViewCell *birthdayCell;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLab;

- (IBAction)add:(UIButton *)sender;
@end
