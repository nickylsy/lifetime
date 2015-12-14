//
//  Airbox.m
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "Airbox.h"

@implementation Airbox

+(id)boxWithName:(NSString *)name ID:(NSString *)ID
{
    return [[self alloc] initWithName:name ID:ID];
}

-(id)initWithName:(NSString *)name ID:(NSString *)ID
{
    if (self=[super init]) {
        self.name = name;
        self.ID   = ID;
        self.devices=[NSMutableArray array];
    }
    return self;
}

@end
