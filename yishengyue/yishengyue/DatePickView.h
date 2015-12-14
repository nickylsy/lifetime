//
//  DatePickView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickViewDelegate <NSObject>

-(void)hidepicker;
-(void)updateTime:(NSString *)timestring;

@end

@interface DatePickView : UIView

@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@property (retain, nonatomic) id<DatePickViewDelegate> mydelegate;
@property (copy,nonatomic)NSString *timeFormatString;

- (IBAction)Ok:(id)sender;
- (IBAction)cancel:(id)sender;
@end
