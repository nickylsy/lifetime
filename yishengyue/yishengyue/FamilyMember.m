//
//  FamilyMember.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "FamilyMember.h"

@implementation FamilyMember

+(id)memberWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(id)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.ID=[dict[@"FamilyId"] isEqual:[NSNull null]]?@"":dict[@"FamilyId"];
        self.name=[dict[@"Name"] isEqual:[NSNull null]]?@"":dict[@"Name"];
        self.birthday=[dict[@"Birthday"] isEqual:[NSNull null]]?@"":dict[@"Birthday"];
        self.age=[dict[@"Age"] isEqual:[NSNull null]]?@"":dict[@"Age"];
        self.relationship=[dict[@"Relationship"] isEqual:[NSNull null]]?@"":dict[@"Relationship"];
        self.phoneNum=[dict[@"Tel"] isEqual:[NSNull null]]?@"":dict[@"Tel"];
        self.selected=NO;
    }
    return self;
}

-(void)updateWithDict:(NSDictionary *)dict
{
    self.ID=[dict[@"FamilyId"] isEqual:[NSNull null]]?@"":dict[@"FamilyId"];
    self.name=[dict[@"Name"] isEqual:[NSNull null]]?@"":dict[@"Name"];
    self.birthday=[dict[@"Birthday"] isEqual:[NSNull null]]?@"":dict[@"Birthday"];
    self.age=[dict[@"Age"] isEqual:[NSNull null]]?@"":dict[@"Age"];
    self.relationship=[dict[@"Relationship"] isEqual:[NSNull null]]?@"":dict[@"Relationship"];
    self.phoneNum=[dict[@"Tel"] isEqual:[NSNull null]]?@"":dict[@"Tel"];
}
@end
