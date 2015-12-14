//
//  TuihuoController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/21.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuihuoController : UIViewController

@property(retain,nonatomic)NSDictionary *shopInfo;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *ruleLab;
@property (weak, nonatomic) IBOutlet UITextView *reasonTxt;
@property (weak, nonatomic) IBOutlet UITextView *descTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

- (IBAction)tuihuo:(UIButton *)sender;
@end
