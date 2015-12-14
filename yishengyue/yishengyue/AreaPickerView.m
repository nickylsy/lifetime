//
//  AreaPickerView.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/1.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AreaPickerView.h"
#import "HZAreaPickerView.h"

@interface AreaPickerView()<HZAreaPickerDelegate>

@end
@implementation AreaPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    self.hzareapicker=[[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    [self.hzareapicker showInView:self.pickerView];
}

- (IBAction)cancel:(id)sender {
    [self.mydelegate hidepicker];
}

- (IBAction)ok:(id)sender {
    HZLocation *location= self.hzareapicker.locate;
    [self.mydelegate updateAreaWithProvice:location.state City:location.city Area:location.district];
//    [self.mydelegate updateArea:[NSString stringWithFormat:@"%@%@%@",location.state,location.city,location.district]];
    [self cancel:nil];
}
@end
