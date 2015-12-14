//
//  Airbox.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Airbox : NSObject

@property (nonatomic,copy  ) NSString       *name;
@property (nonatomic,copy  ) NSString       *ID;
@property (nonatomic,retain) NSMutableArray *devices;

+(id)boxWithName:(NSString *)name ID:(NSString *)ID;
-(id)initWithName:(NSString *)name ID:(NSString *)ID;

@end
