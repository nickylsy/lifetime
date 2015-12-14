//
//  MyPickView.h
//  yishengyue
//
//  Created by 华为-xtoucher on 15/9/18.
//  Copyright © 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyPickViewDelegate <NSObject>

-(void)hidepicker;
-(void)updateString;

@end

@interface MyPickView : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (retain, nonatomic) id<MyPickViewDelegate> mydelegate;

- (IBAction)Ok:(id)sender;
- (IBAction)cancel:(id)sender;
@end
