//
//  FamilyController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/4.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyController : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *backBtn;


- (IBAction)addFamilymember:(id)sender;
- (IBAction)goback:(id)sender;
@end
