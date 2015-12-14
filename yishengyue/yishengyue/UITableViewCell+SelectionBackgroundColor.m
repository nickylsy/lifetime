//
//  UITableViewCell+SelectionBackgroundColor.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/27.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "UITableViewCell+SelectionBackgroundColor.h"

@implementation UITableViewCell (SelectionBackgroundColor)

-(void)setSelectionBackgoundColorClear
{
    UIView *view=[[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor=[UIColor clearColor];
    [self setSelectedBackgroundView:view];
}
@end
