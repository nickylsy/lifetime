//
//  AddWorkView.h
//  yishengyue
//
//  Created by 华为-xtoucher on 15/9/17.
//  Copyright © 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface AddWorkView : UIView

@property (weak, nonatomic) IBOutlet UIButton *releaseBtn;
@property (weak, nonatomic) IBOutlet UITextField *themeTxt;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *descTxt;

@end
