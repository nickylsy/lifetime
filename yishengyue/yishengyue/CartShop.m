//
//  CartShop.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/4.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "CartShop.h"

#define KEY_CARTID @"CartId"
#define KEY_SHOPID @"ShopId"
#define KEY_SHOPNUMBER @"ShopNum"
#define KEY_NAME @"Name"
#define KEY_PRICE @"DiscountPrice"
#define KEY_BANNER @"Banner"

@implementation CartShop

+(id)cartshopWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(id)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.cartID=dict[KEY_CARTID];
        self.shopID=dict[KEY_SHOPID];
        self.shopNum=dict[KEY_SHOPNUMBER];
        self.name=dict[KEY_NAME];
        self.price=[NSString stringWithFormat:@"￥%@",dict[KEY_PRICE]];
        self.banner=dict[KEY_BANNER];
        self.selected=NO;
    }
    return self;
}
@end
