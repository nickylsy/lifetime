//
//  ST_GoodsDetail.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/3.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "ST_GoodsDetail.h"
#import "NSDictionary+GetObjectBykey.h"

#define KEY_NAME @"Name"
#define KEY_PRICE @"DiscountPrice"
#define KEY_IMAGES @"BannerImg"
#define KEY_CONTENT @"Content"
#define KEY_TEL @"ServiceTel"

@implementation ST_GoodsDetail

+(id)detailWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(id)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.name=dict[KEY_NAME];
        self.price=[NSString stringWithFormat:@"￥%@",dict[KEY_PRICE]];
        self.content=dict[KEY_CONTENT];
        self.bannerImages=dict[KEY_IMAGES];
        self.phoneNumber=[dict getObjectByKey:KEY_TEL];
    }
    
    return self;
}
@end
