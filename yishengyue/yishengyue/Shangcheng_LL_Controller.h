//
//  Shangcheng_LL_Controller.h
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/29.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Shangcheng_LL_Controller : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
