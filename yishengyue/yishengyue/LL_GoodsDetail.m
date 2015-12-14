//
//  LL_GoodsDetail.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/3.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "LL_GoodsDetail.h"


#define KEY_NAME @"Name"
#define KEY_PRICE @"Price"
#define KEY_IMAGES @"Pics"
#define KEY_CONTENT @"Content"
#define KEY_PHONENUM @"Tel"
#define KEY_USERNAME @"UserName"

@implementation LL_GoodsDetail
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
        self.userPhoneNum=dict[KEY_PHONENUM];
        self.username=dict[KEY_USERNAME];
    }
    
    return self;
}
@end
