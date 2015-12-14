//
//  TVControlViewController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/22.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Device;

@interface TVControlViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,NSXMLParserDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (retain,nonatomic)Device                    * currentdevice;

@property (weak, nonatomic) IBOutlet UIButton         * okbtn;
@property (weak, nonatomic) IBOutlet UIView           * navBar;
@property (weak, nonatomic) IBOutlet UICollectionView * collectionView;

- (IBAction)goback:(id)sender;
- (IBAction)addButton:(id)sender;
- (IBAction)control:(UIButton *)sender;

@end
