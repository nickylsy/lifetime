//
//  HomeFuncView.m
//  yishengyue
//
//  Created by Xtoucher08 on 15/6/16.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#import "HomeFuncView.h"
#import "Mydefine.h"

@implementation HomeFuncView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=UIColorFromRGB(MAIN_COLOR_VALUE);
        
        CGFloat fengewidth=1.0;
        
        CGFloat itemwidth=(frame.size.width-fengewidth*2)/3;
        CGFloat itemheight=(frame.size.height-fengewidth)/2;
        
        _introduce=[HomeFuncItem itemWithFrame:CGRectMake(0, 0, itemwidth, itemheight) image:[UIImage imageNamed:@"home_introduce.png"] Highlightedimage:[UIImage imageNamed:@"home_introduce_selected.png"] text:@"品牌介绍"];
        [_introduce.btn addTarget:self action:@selector(introducemethod) forControlEvents:UIControlEventTouchUpInside];
        _introduce.tag=1;
        [self addSubview:_introduce];
        
        UITapGestureRecognizer *introduceTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(introducemethod)];
        _introduce.userInteractionEnabled=YES;
        [_introduce addGestureRecognizer:introduceTap];
        
        _quanjing=[HomeFuncItem itemWithFrame:CGRectMake(itemwidth+fengewidth, 0, itemwidth, itemheight) image:[UIImage imageNamed:@"home_quanjing.png"] Highlightedimage:[UIImage imageNamed:@"home_quanjing_selected.png"] text:@"全景景观"];
        [_quanjing.btn addTarget:self action:@selector(quanjingmethod) forControlEvents:UIControlEventTouchUpInside];
        _quanjing.tag=4;
        [self addSubview:_quanjing];
        
        UITapGestureRecognizer *quanjingTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quanjingmethod)];
        _quanjing.userInteractionEnabled=YES;
        [_quanjing addGestureRecognizer:quanjingTap];
        
        _jingpin=[HomeFuncItem itemWithFrame:CGRectMake((itemwidth+fengewidth)*2, 0, itemwidth, itemheight) image:[UIImage imageNamed:@"home_jingpin.png"] Highlightedimage:[UIImage imageNamed:@"home_jingpin_selected.png"] text:@"精品户型"];
        [_jingpin.btn addTarget:self action:@selector(jingpinmethod) forControlEvents:UIControlEventTouchUpInside];
        _jingpin.tag=5;
        [self addSubview:_jingpin];
        
        UITapGestureRecognizer *jingpinTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jingpinmethod)];
        _jingpin.userInteractionEnabled=YES;
        [_jingpin addGestureRecognizer:jingpinTap];
        
//        _kanfang=[HomeFuncItem itemWithFrame:CGRectMake(0, itemheight+fengewidth, itemwidth, itemheight) image:[UIImage imageNamed:@"home_kanfang.png"] Highlightedimage:[UIImage imageNamed:@"home_kanfang_selected.png"] text:@"360°看房"];
//        [_kanfang.btn addTarget:self action:@selector(kanfangmethod) forControlEvents:UIControlEventTouchUpInside];
//        _kanfang.tag=2;
//        [self addSubview:_kanfang];
//        
//        UITapGestureRecognizer *kanfangTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kanfangmethod)];
//        _kanfang.userInteractionEnabled=YES;
//        [_kanfang addGestureRecognizer:kanfangTap];
//        
//        
//        _map=[HomeFuncItem itemWithFrame:CGRectMake(itemwidth+fengewidth, itemheight+fengewidth, itemwidth, itemheight) image:[UIImage imageNamed:@"home_map.png"] Highlightedimage:[UIImage imageNamed:@"home_map_selected.png"] text:@"楼盘地图"];
//        [_map.btn addTarget:self action:@selector(mapmethod) forControlEvents:UIControlEventTouchUpInside];
//        _map.tag=3;
//        [self addSubview:_map];
//        
//        UITapGestureRecognizer *mapTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapmethod)];
//        _map.userInteractionEnabled=YES;
//        [_map addGestureRecognizer:mapTap];
//        
//        _messagecenter=[HomeFuncItem itemWithFrame:CGRectMake((itemwidth+fengewidth)*2, itemheight+fengewidth, itemwidth, itemheight) image:[UIImage imageNamed:@"home_messagecenter.png"] Highlightedimage:[UIImage imageNamed:@"home_messagecenter_selected.png"] text:@"消息中心"];
//        [_messagecenter.btn addTarget:self action:@selector(messagecentermethod) forControlEvents:UIControlEventTouchUpInside];
//        _messagecenter.tag=6;
//        [self addSubview:_messagecenter];
//        
//        UITapGestureRecognizer *messagecenterTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messagecentermethod)];
//        _messagecenter.userInteractionEnabled=YES;
//        [_messagecenter addGestureRecognizer:messagecenterTap];
        
        _kanfang=[HomeFuncItem itemWithFrame:CGRectMake((itemwidth+fengewidth)*2, itemheight+fengewidth, itemwidth, itemheight) image:[UIImage imageNamed:@"func_building.png"] Highlightedimage:[UIImage imageNamed:@"func_building.png"] text:@"功能建设中"];
//        [_kanfang.btn addTarget:self action:@selector(kanfangmethod) forControlEvents:UIControlEventTouchUpInside];
        _kanfang.tag=2;
        _kanfang.btn.imageEdgeInsets=UIEdgeInsetsMake(4, 4, 4, 4);
        [self addSubview:_kanfang];
        
        
        _map=[HomeFuncItem itemWithFrame:CGRectMake(0, itemheight+fengewidth, itemwidth, itemheight) image:[UIImage imageNamed:@"home_map.png"] Highlightedimage:[UIImage imageNamed:@"home_map_selected.png"] text:@"楼盘地图"];
        [_map.btn addTarget:self action:@selector(mapmethod) forControlEvents:UIControlEventTouchUpInside];
        _map.tag=3;
        [self addSubview:_map];
        
        UITapGestureRecognizer *mapTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapmethod)];
        _map.userInteractionEnabled=YES;
        [_map addGestureRecognizer:mapTap];
        
        _messagecenter=[HomeFuncItem itemWithFrame:CGRectMake(itemwidth+fengewidth, itemheight+fengewidth, itemwidth, itemheight) image:[UIImage imageNamed:@"home_messagecenter.png"] Highlightedimage:[UIImage imageNamed:@"home_messagecenter_selected.png"] text:@"消息中心"];
        [_messagecenter.btn addTarget:self action:@selector(messagecentermethod) forControlEvents:UIControlEventTouchUpInside];
        _messagecenter.tag=6;
        [self addSubview:_messagecenter];
        
        UITapGestureRecognizer *messagecenterTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messagecentermethod)];
        _messagecenter.userInteractionEnabled=YES;
        [_messagecenter addGestureRecognizer:messagecenterTap];

        
    }
    return self;
}

-(void)introducemethod
{
    if (self.introduceblock) {
        self.introduceblock((int)_introduce.tag);
    }
}
-(void)quanjingmethod
{
    if (self.introduceblock) {
        self.introduceblock((int)_quanjing.tag);
    }
}
-(void)jingpinmethod
{
    if (self.introduceblock) {
        self.introduceblock((int)_jingpin.tag);
    }
}
-(void)kanfangmethod
{
    if (self.kanfangblock) {
        self.kanfangblock((int)_kanfang.tag);
    }
}
-(void)mapmethod
{
    if (self.mapblock) {
        self.mapblock((int)_map.tag);
    }
}
-(void)messagecentermethod
{
    if (self.messagecenterblock) {
        self.messagecenterblock((int)_messagecenter.tag);
    }
}
@end
