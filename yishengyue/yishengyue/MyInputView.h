//
//  MyInputView.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/14.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInputView : UIView
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *hintLab;

@property (copy,nonatomic)void(^dismisscallback)(NSString *);

-(id)initWithCoder:(NSCoder *)aDecoder;
- (IBAction)ok:(id)sender;
- (IBAction)cancel:(id)sender;


@end
