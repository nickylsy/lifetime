//
//  ControlButton.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/7.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlButton : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *ID;

+(id)buttonWithName:(NSString *)name ID:(NSString *)ID;
-(id)initWithName:(NSString *)name ID:(NSString *)ID;

@end
