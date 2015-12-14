//
//  CYHelpView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/19.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QUESTION_KEY @"Qus"
#define ANSWER_KEY @"Ans"

@interface CYHelpView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

-(void)setHelpInfo:(NSArray *)array;

@end
