//
//  DatePickView.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "DatePickView.h"

@implementation DatePickView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.timeFormatString=@"yyyy-MM-dd";
}
- (IBAction)Ok:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:self.timeFormatString];
    NSString *datestring = [dateFormatter stringFromDate:self.picker.date];
    [self.mydelegate updateTime:datestring];
    [self cancel:nil];
}

- (IBAction)cancel:(id)sender {
    [self.mydelegate hidepicker];
}
@end
