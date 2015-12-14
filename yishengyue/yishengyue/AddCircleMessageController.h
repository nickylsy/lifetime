//
//  AddCircleMassageController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/9/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCircleMessageController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *tabBar;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property(retain,nonatomic)NSArray<NSDictionary *>* typeList;
- (IBAction)goback:(UIButton *)sender;
@end
