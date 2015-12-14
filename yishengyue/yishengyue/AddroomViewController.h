//
//  AddroomViewController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMSegmentedControl;
@class SMVerticalSegmentedControl;

@interface AddroomViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet HMSegmentedControl           * roomTab;
@property (retain, nonatomic) IBOutlet SMVerticalSegmentedControl * goodsTab;
@property (weak, nonatomic) IBOutlet UIWebView                    * webview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem              * shoppingcartBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem              * listBtn;

- (IBAction)goback:(id)sender;

@end
