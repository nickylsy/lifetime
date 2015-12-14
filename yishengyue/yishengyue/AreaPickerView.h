//
//  AreaPickerView.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/1.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZAreaPickerView;

@protocol AreaPickerViewDelegate <NSObject>

-(void)hidepicker;
-(void)updateAreaWithProvice:(NSString *)province City:(NSString *)city Area:(NSString *)area;

@end

@interface AreaPickerView : UIView

@property(nonatomic,retain)id<AreaPickerViewDelegate>mydelegate;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (retain, nonatomic) HZAreaPickerView *hzareapicker;

- (IBAction)cancel:(id)sender;
- (IBAction)ok:(id)sender;
@end
