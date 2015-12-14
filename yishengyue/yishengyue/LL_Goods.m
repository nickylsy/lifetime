//
//  LL_Goods.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/3.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "LL_Goods.h"
#import "NSDictionary+GetObjectBykey.h"

#define KEY_ID @"NeighborId"
#define KEY_USERID @"UserId"
#define KEY_NAME @"Name"
#define KEY_PRICE @"Price"
#define KEY_TIME @"CreateTime"
#define KEY_PIC @"Pic"

@implementation LL_Goods

+(id)goodsWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(id)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.ID=[dict getObjectByKey:KEY_ID];//dict[KEY_ID];
        self.userID=[dict getObjectByKey:KEY_USERID];//dict[KEY_USERID];
        self.name=[dict getObjectByKey:KEY_NAME];//dict[KEY_NAME];
        self.price=[NSString stringWithFormat:@"￥%@",[dict getObjectByKey:KEY_PRICE]];//dict[KEY_PRICE]];
        self.createTime=[dict getObjectByKey:KEY_TIME];//dict[KEY_TIME];
        self.pic=[dict getObjectByKey:KEY_PIC];//dict[KEY_PIC];
    }
    return self;
}
@end
