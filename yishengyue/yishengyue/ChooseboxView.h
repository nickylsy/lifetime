//
//  ChooseboxView.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/5.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseboxViewDelegate <NSObject>
- (void)configbox;
@end

@interface ChooseboxView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSMutableArray *boxes;
@property(nonatomic,retain)UITableView *tv;
@property(nonatomic,retain)id<ChooseboxViewDelegate>mydelagate;
@property(nonatomic,copy)void(^chooseboxblock)(int);

-(id)initWithFrame:(CGRect)frame items:(NSMutableArray *)items;
@end
