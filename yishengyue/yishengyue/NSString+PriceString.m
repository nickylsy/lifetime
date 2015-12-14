//
//  NSString+PriceString.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/20.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "NSString+PriceString.h"

@implementation NSString (PriceString)
+(instancetype)priceStringWithPrice:(NSString *)price
{
    return [self stringWithFormat:@"￥%@",price];
}
@end
