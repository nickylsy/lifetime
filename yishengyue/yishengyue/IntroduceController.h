//
//  IntroduceController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/26.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroduceController : UIViewController

@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (copy,nonatomic)NSString *poststring;

- (IBAction)goback:(id)sender;

-(void)initcontent;

@end
