//
//  Mydefine.h
//  AirboxConfig
//
//  Created by Xtoucher08 on 15/5/4.
//  Copyright (c) 2015年 Xtoucher08. All rights reserved.
//

#ifndef AirboxConfig_Mydefine_h
#define AirboxConfig_Mydefine_h


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]


#define COLLECTIONVIEW_CONTENTINEST_TOP 20.0

#define TABBAR_HEIGHT 48.0

#define TOOLBAR_HEIGHT 44.0

#define STATUSBAR_HEIGHT 20.0

#define SCREENWIDTH_5S 320.0

#define SCREENHEIGHT_5S 568.0

#define TITLEBAR_FONT_SIZE 18.0

#define MAIN_COLOR_VALUE 0x26c4b6

#define FONT_COLOR_VALUE 0x333333

#define AIRVALUE_REFRESH_TIME 180.0

#define NO_DATA_STRING @"--"

#define PHONECALL_SALEHOUSE @"tel://08258887878"

//#define APP_URL @"http://itunes.apple.com/lookup?id=1028962181"

#define APP_URL @"https://itunes.apple.com/us/app/yi-sheng-yue/id1028962181?mt=8&uo=4"

#endif
