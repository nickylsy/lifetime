//
//  ST_Goods.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/3.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ST_Goods.h"

#define KEY_ID @"ShopId"
#define KEY_NAME @"Name"
#define KEY_PRICE @"DiscountPrice"
#define KEY_BANNER @"Banner"

@implementation ST_Goods

+(id)goodWihtDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(id)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.ID=dict[KEY_ID];
        self.name=dict[KEY_NAME];
        self.price=[NSString stringWithFormat:@"￥%@",dict[KEY_PRICE]];
        self.banner=dict[KEY_BANNER];
    }
    
    return self;
}
@end
