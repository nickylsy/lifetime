//
//  Fenlei.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/4.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "Fenlei.h"

#define KEY_ID @"id"
#define KEY_NAME @"SortName"

@implementation Fenlei

+(id)fenleiWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(id)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.ID=dict[KEY_ID];
        self.name=dict[KEY_NAME];
    }
    return self;
}

@end
