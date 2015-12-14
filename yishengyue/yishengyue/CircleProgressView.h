//
//  CircleProgressView.h
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleShapeLayer;

@interface CircleProgressView : UIControl

@property(nonatomic,assign)BOOL isjiaquan;
@property (nonatomic) NSTimeInterval elapsedTime;

@property (nonatomic,copy)NSString *hintstring;

@property (nonatomic) NSTimeInterval timeLimit;

@property (nonatomic, retain) NSString *status;

@property (assign, nonatomic, readonly) double percent;

@property (nonatomic, retain) CircleShapeLayer *progressLayer;
@property (retain, nonatomic) UILabel *progressLabel;

@property (retain, nonatomic) UILabel *levelLabel;
@property (retain, nonatomic) UIImageView *levelImg;

-(void)updatelevelWithLevelstring:(NSString *)string image:(UIImage *)image color:(UIColor *)color;

@end
