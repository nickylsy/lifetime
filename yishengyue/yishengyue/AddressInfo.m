//
//  AddressInfo.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/4.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "AddressInfo.h"

#define KEY_ID @"AddressId"
#define KEY_NAME @"Name"
#define KEY_PHONENUMBER @"Tel"
#define KEY_POSTALCODE @"PostalCode"
#define KEY_ADDRESS @"Address"

@implementation AddressInfo

+(id)addressinfoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(id)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.ID=[dict[KEY_ID] isEqual:[NSNull null]]?@"":dict[KEY_ID];
        self.name=[dict[KEY_NAME] isEqual:[NSNull null]]?@"":dict[KEY_NAME];
        self.phoneNum=[dict[KEY_PHONENUMBER] isEqual:[NSNull null]]?@"":dict[KEY_PHONENUMBER];
        self.postalcode=[dict[KEY_POSTALCODE] isEqual:[NSNull null]]?@"":dict[KEY_POSTALCODE];
        self.address=[dict[KEY_ADDRESS] isEqual:[NSNull null]]?@"":dict[KEY_ADDRESS];
    }
    
    return self;
}
@end
