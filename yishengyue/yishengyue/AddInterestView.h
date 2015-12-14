//
//  AddInterestView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/9/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface AddInterestView : UIView
@property (weak, nonatomic) IBOutlet UITextField *themeTxt;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UITextField *locationTxt;
@property (weak, nonatomic) IBOutlet UITextField *numberTxt;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *descTxt;
@property (weak, nonatomic) IBOutlet UIButton *releaseBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@end
