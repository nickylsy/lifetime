//
//  DES3Util.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/8/7.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface DES3Util : NSObject {
    
}

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;

@end
