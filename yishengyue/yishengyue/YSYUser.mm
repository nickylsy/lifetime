//
//  YSYUser.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/2.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "YSYUser.h"
#import "NSDictionary+GetObjectBykey.h"


#define USERIDKEY @"UserId"
#define USERNAMEKEY @"UserName"
#define LOGOURLKEY @"LogoUrl"
#define SEXKEY @"Sex"
#define ROOMNUMKEY @"RoomNum"
#define IDCARDKEY @"IdCard"
#define HOBBYKEY @"Hobby"
#define CREATETIMEKEY @"CreateTime"
#define TELKEY @"Tel"
#define CODEKEY @"Code"
@implementation YSYUser

+(id)userWihtDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(id)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.ID=[dict[USERIDKEY] isEqual:[NSNull null]]?@"":dict[USERIDKEY];
        self.username=[dict[USERNAMEKEY] isEqual:[NSNull null]]?@"":dict[USERNAMEKEY];
        self.logoURLString=[dict[LOGOURLKEY] isEqual:[NSNull null]]?@"":dict[LOGOURLKEY];
        self.sex=[dict[SEXKEY] isEqual:[NSNull null]]?@"":dict[SEXKEY];
        if ([self.sex isEqualToString:@"1"]) {
            self.sex=@"男";
        }
        if ([self.sex isEqualToString:@"2"]) {
            self.sex=@"女";
        }
        self.roomNum=[dict[ROOMNUMKEY] isEqual:[NSNull null]]?@"":dict[ROOMNUMKEY];
        self.idCard=[dict[IDCARDKEY] isEqual:[NSNull null]]?@"":dict[IDCARDKEY];
        self.hobby=[dict[HOBBYKEY] isEqual:[NSNull null]]?@"":dict[HOBBYKEY];
        self.createtime=[dict[CREATETIMEKEY] isEqual:[NSNull null]]?@"":dict[CREATETIMEKEY];
        self.phoneNum=[dict[TELKEY] isEqual:[NSNull null]]?@"":dict[TELKEY];
        self.shareCode=[dict getObjectByKey:CODEKEY];
    }
    return self;
}

-(void)refreshWithDict:(NSDictionary *)dict
{
    if (dict) {
        self.username=dict[@"UserName"];
        self.logoURLString=dict[@"LogoUrl"];
        self.sex=dict[@"Sex"];
        if ([self.sex isEqualToString:@"1"]) {
            self.sex=@"男";
        }
        if ([self.sex isEqualToString:@"2"]) {
            self.sex=@"女";
        }
        self.roomNum=dict[@"RoomNum"];
        self.idCard=dict[@"IdCard"];
        self.hobby=dict[@"Hobby"];
    }
}

-(NSMutableArray *)toArray
{
    NSMutableArray *array=[NSMutableArray array];
    [array addObject:self.username];
    [array addObject:self.sex];
    [array addObject:self.phoneNum];
    [array addObject:self.roomNum];
    [array addObject:self.idCard];
    [array addObject:self.hobby];
    
    return array;
}
@end
