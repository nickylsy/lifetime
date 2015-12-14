//
//  IntroduceController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/5/26.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "IntroduceController.h"
#import "MessageFormat.h"
#import "MRImgShowView.h"
#import "NSString+URLEncoding.h"
#import "Mydefine.h"

@interface IntroduceController ()
{
    NSMutableData *_requestdata;
}
@end

@implementation IntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    self.pagecontrol.currentPageIndicatorTintColor=UIColorFromRGB(MAIN_COLOR_VALUE);
    self.pagecontrol.pageIndicatorTintColor=[UIColor grayColor];
    

    self.view.backgroundColor=[UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeindnex:) name:@"changepage" object:nil];
    
}

-(void)initcontent
{
    [MessageFormat POST:_poststring parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array=[responseObject objectForKey:@"data"];
        NSMutableArray *pics=[NSMutableArray array];
        for (NSString *string in array) {
            [pics addObject:string.URLEncodedString];
        }
        MRImgShowView *imgShowView = [[MRImgShowView alloc]
                                      initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)
                                      withSourceData:pics
                                      withIndex:0];
        
        // 解决谦让
        [imgShowView requireDoubleGestureRecognizer:[[self.view gestureRecognizers] lastObject]];
        imgShowView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:imgShowView];
        [self.view bringSubviewToFront:self.pagecontrol];
        [self.view bringSubviewToFront:self.backBtn];
        
        self.pagecontrol.numberOfPages=array.count;
        self.pagecontrol.currentPage=0;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
    } incontroller:self view:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)changeindnex:(NSNotification *)notification
{
    NSNumber *number=notification.userInfo[@"index"];
    self.pagecontrol.currentPage=number.intValue;
}


- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
