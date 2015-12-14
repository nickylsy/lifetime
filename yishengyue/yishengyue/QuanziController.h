//
//  QuanziController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/25.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuanziController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *myreleaseBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIImageView *xingquImg;
@property (weak, nonatomic) IBOutlet UILabel *xingquLab;
@property (weak, nonatomic) IBOutlet UIImageView *gongzuoImg;
@property (weak, nonatomic) IBOutlet UILabel *gongzuoLab;
@property (weak, nonatomic) IBOutlet UIImageView *shangwuImg;
@property (weak, nonatomic) IBOutlet UILabel *shangwuLab;
@property (weak, nonatomic) IBOutlet UIView *xingquView;
@property (weak, nonatomic) IBOutlet UIView *gongzuoView;
@property (weak, nonatomic) IBOutlet UIView *shangwuView;
@property (weak, nonatomic) IBOutlet UIImageView *xingquBottomImg;
@property (weak, nonatomic) IBOutlet UIImageView *gongzuoBottomImg;
@property (weak, nonatomic) IBOutlet UIImageView *shangwuBottomImg;


- (IBAction)showmenu:(id)sender;
- (IBAction)addMessage:(UIButton *)sender;
- (IBAction)myReleaseList:(UIButton *)sender;
@end
