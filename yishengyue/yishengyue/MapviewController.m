//
//  MapController.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/24.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "MapviewController.h"
#import "BMapKit.h"
#import "Mydefine.h"
#import "NSString+URLEncoding.h"

@interface MapviewController()<BMKMapViewDelegate,UIAlertViewDelegate>

@property(strong,nonatomic)BMKMapView *mapView;

@end

@implementation MapviewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
 
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-STATUSBAR_HEIGHT)];
    [self.mapView showMapScaleBar];
    [self.view addSubview:self.mapView];
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(16, 30, 40, 40)];
    backBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [backBtn setImage:[UIImage imageNamed:@"back_black.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 30.525946;
    coor.longitude = 105.600379;
    annotation.coordinate = coor;
    annotation.title = @"|";
    [_mapView addAnnotation:annotation];
    
    [_mapView setCenterCoordinate:coor];
    [_mapView setZoomLevel:13];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}


#pragma mark-
-(void)goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)guide
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.urlstring URLEncodedString]]];
}

-(void)phonecall
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否拨打售房中心电话"delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
}

#pragma mark-

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        
        CGFloat labelheight=36;
        CGFloat paopaoheight=50;
        CGFloat paopaowidth=151;
        CGFloat fengeHeight=20.0;
        CGFloat fengeWidth=1.0;
        
        
        UIView *customview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, paopaowidth, paopaoheight)];
        
        UIView *topview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, paopaowidth, labelheight)];
        topview.backgroundColor=UIColorFromRGB(0x4d4d4d);
        topview.layer.masksToBounds=YES;
        topview.layer.cornerRadius=5.0;
        [customview addSubview:topview];
        
        UILabel *leftLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, (paopaowidth-fengeWidth)/2, labelheight)];
        leftLab.text=@"拨打电话";
        leftLab.textColor=[UIColor whiteColor];
        leftLab.textAlignment=NSTextAlignmentCenter;
        leftLab.font=[UIFont systemFontOfSize:13.0];
        [topview addSubview:leftLab];
        
        UITapGestureRecognizer *lefttap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phonecall)];
        leftLab.userInteractionEnabled=YES;
        [leftLab addGestureRecognizer:lefttap];
        
        
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake((paopaowidth-fengeWidth)/2, (labelheight-fengeHeight)/2, fengeWidth, fengeHeight)];
        imageview.backgroundColor=leftLab.textColor;
        [topview addSubview:imageview];
        
        UILabel *rightLab=[[UILabel alloc] initWithFrame:CGRectMake((paopaowidth+fengeWidth)/2, 0, (paopaowidth-fengeWidth)/2, labelheight)];
        rightLab.textAlignment=NSTextAlignmentCenter;
        rightLab.textColor=leftLab.textColor;
        rightLab.text=@"开始导航";
        rightLab.font=leftLab.font;
        [topview addSubview:rightLab];
        
        UITapGestureRecognizer *righttap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guide)];
        rightLab.userInteractionEnabled=YES;
        [rightLab addGestureRecognizer:righttap];
        
        UIImageView *paopaobottom=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, paopaoheight-labelheight)];
        paopaobottom.center=CGPointMake(paopaowidth/2, labelheight+(paopaoheight-labelheight)/2);
        paopaobottom.image=[UIImage imageNamed:@"qipao_bottom.png"];
        [customview addSubview:paopaobottom];
        
        BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:customview];
    
        newAnnotationView.paopaoView=paopao;
        
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
#pragma mark - UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PHONECALL_SALEHOUSE]];
    }
    [alertView removeFromSuperview];
    alertView=nil;
}
@end
