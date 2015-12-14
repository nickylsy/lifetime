//
//  MessageOfMessageCenter.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/28.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MessageOfMessageCenter.h"

#define CELL_TITLE @"tittle"
#define CELL_CONTENT @"message"
#define CELL_DATE @"CreateTime"
#define CELL_ISREAD @"isRead"
#define CELL_ID @"id"

@implementation MessageOfMessageCenter

+(id)messageWihtDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWihtDictionary:dict];
}

-(id)initWihtDictionary:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.title=[dict[CELL_TITLE] isEqual:[NSNull null]]?@"":dict[CELL_TITLE];
        self.content=[dict[CELL_CONTENT] isEqual:[NSNull null]]?@"":dict[CELL_CONTENT];
        self.date=[dict[CELL_DATE] isEqual:[NSNull null]]?@"":dict[CELL_DATE];
        NSString *isread=[dict[CELL_ISREAD] isEqual:[NSNull null]]?@"":dict[CELL_ISREAD];
        self.isRead=isread.boolValue;
        self.ID=[dict[CELL_ID] isEqual:[NSNull null]]?@"":dict[CELL_ID];
        self.selected=NO;
        self.cellheight=120.0;
    }
    return self;
}

@end
