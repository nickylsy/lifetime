//
//  AddShopController.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/7/4.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//


#define REFRESH_SHOPLIST @"refreshmyshoplist"
#import <UIKit/UIKit.h>
@class GCPlaceholderTextView;

@interface AddShopController : UIViewController
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *shopDetailTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *picScrollview;
@property (weak, nonatomic) IBOutlet UITextField *shopTitleTxt;
@property (weak, nonatomic) IBOutlet UITextField *shopPriceTxt;
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (IBAction)cancel:(id)sender;
- (IBAction)releaseShop:(id)sender;
@end
