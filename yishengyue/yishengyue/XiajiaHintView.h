//
//  XiajiaHintView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface XiajiaHintView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *BeizhuTxt;

@property(copy,nonatomic)void(^cancelBlock)();
@property(copy,nonatomic)void(^OKBlock)(NSString *);

- (IBAction)cancel:(id)sender;
- (IBAction)OK:(id)sender;
@end
