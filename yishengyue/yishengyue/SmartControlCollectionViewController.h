//
//  SmartControlCollectionViewController.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/4/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Airbox;
@class HintView;


@interface SmartControlCollectionViewController : UICollectionViewController<UITextFieldDelegate,NSXMLParserDelegate>
{
    HintView *_helphint;
}
@property (weak, nonatomic) IBOutlet UIButton * helpBtn;
@property (weak, nonatomic) IBOutlet UIButton * backBtn;
//@property (retain,nonatomic)Airbox            * currentbox;
//@property (copy,nonatomic)NSString            * username;

- (IBAction)goback:(id)sender;
- (IBAction)showHelpMsg:(id)sender;
@end
