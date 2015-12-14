//
//  AlipayAccount.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AlipayAccount.h"

#define ALIPAYID @"AlipayId"
#define ACCOUNT @"Account"
#define USERNAME @"UserName"

@implementation AlipayAccount

+(id)accountWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(id)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.alipayID=[dict[ALIPAYID] isEqual:[NSNull null]]?@"":dict[ALIPAYID];
        self.username=[dict[USERNAME] isEqual:[NSNull null]]?@"":dict[USERNAME];
        self.account=[dict[ACCOUNT] isEqual:[NSNull null]]?@"":dict[ACCOUNT];
    }
    
    return self;
}
@end
