//
//  BoxhomepageController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/6/11.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxhomepageController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *circleview;

@property (weak, nonatomic) IBOutlet UILabel *pm25NumLab;
@property (weak, nonatomic) IBOutlet UIImageView *pm25NumImg;
@property (weak, nonatomic) IBOutlet UILabel *pm25Lab;
@property (weak, nonatomic) IBOutlet UIImageView *pm25ColorImg;

@property (weak, nonatomic) IBOutlet UILabel *jiaquanNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *jiaquanNumImg;
@property (weak, nonatomic) IBOutlet UILabel *jiaquanLab;
@property (weak, nonatomic) IBOutlet UIImageView *jiaquanColorImg;

@property (weak, nonatomic) IBOutlet UILabel *shiduNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *shiduNumImg;
@property (weak, nonatomic) IBOutlet UILabel *shiduLab;
@property (weak, nonatomic) IBOutlet UIImageView *shiduColorImg;

@property (weak, nonatomic) IBOutlet UILabel *wenduNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *wenduNumImg;
@property (weak, nonatomic) IBOutlet UILabel *wenduLab;
@property (weak, nonatomic) IBOutlet UIImageView *wenduColorImg;


@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *chooseboxImg;

@property (weak, nonatomic) IBOutlet UILabel *outsideWenduNumLab;
@property (weak, nonatomic) IBOutlet UILabel *outsidePM25NumLab;
@property (weak, nonatomic) IBOutlet UILabel *outsideShiduNumLab;

@property (weak, nonatomic) IBOutlet UIImageView *tianqiLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *tianqiLab;
@property (weak, nonatomic) IBOutlet UIView *titleBar;
@property (weak, nonatomic) IBOutlet UIView *outsideTianqiView;
@property (weak, nonatomic) IBOutlet UIView *outsideAirvalueView;

- (IBAction)gotoHomepage:(id)sender;
- (IBAction)showMenu:(id)sender;

- (IBAction)debindbox:(id)sender;
-(void)changebox:(int)boxindex;

@end
