//
//  GerenEditController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/3.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GerenEditController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImg;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *touxiangLab;
@property (weak, nonatomic) IBOutlet UIView *touxiangView;
- (IBAction)goback:(UIButton *)sender;
- (IBAction)complete:(id)sender;

@end
