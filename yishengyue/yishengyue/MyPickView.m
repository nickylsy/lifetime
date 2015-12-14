//
//  MyPickView.m
//  yishengyue
//
//  Created by 华为-xtoucher on 15/9/18.
//  Copyright © 2015年 Xtoucher08. All rights reserved.
//

#import "MyPickView.h"

@implementation MyPickView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)Ok:(id)sender {
    if ([self.mydelegate respondsToSelector:@selector(updateString)]) {
        [self.mydelegate updateString];
    }
    [self cancel:nil];
}

- (IBAction)cancel:(id)sender {
    [self.mydelegate hidepicker];
}

@end
