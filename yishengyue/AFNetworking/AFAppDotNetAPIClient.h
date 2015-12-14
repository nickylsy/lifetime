// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "NSString+URLEncoding.h"

//static NSString * const AFAppDotNetAPIBaseURLString = @"http://sandbox.xtoucher.com:89";
static NSString * const AFAppDotNetAPIBaseURLString = @"http://box.stang.cn";


#define ShopList @"/ShopApi/ShopApi/ShopList" //获取商品列表
#define EditAddress @"/ShopApi/ShopApi/EditAddress"//编辑收货地址
#define SaveAddress @"/ShopApi/ShopApi/SaveAddress"//新增收货地址
#define AddFamily @"/Api/Login/AddFamily"//添加家庭信息接口
#define SaveMessage @"/NeighborShop/NeighborShop/SaveMessage"//发布商品接口
#define AddressList @"/ShopApi/ShopApi/AddressList"//获取收货地址列表
#define EditFamily @"/Api/Login/EditFamily"//编辑单个家庭信息接口
#define MySingleNeighborShop @"/NeighborShop/NeighborShop/MySingleNeighborShop"//获取我发布的单个商品详情信息
#define EditNeighborShop @"/NeighborShop/NeighborShop/EditNeighborShop"//编辑单个我发布的商品
#define DeleteFamily @"/Api/Login/DeleteFamily"//删除单个家庭信息接口
#define CompleteUser @"/Api/Login/CompleteUser"//更新个人资料接口
#define SingleShop @"/ShopApi/ShopApi/SingleShop"//获取商品详情
#define SaveShoppingCart @"/ShopApi/ShopApi/SaveShoppingCart"//加入购物车
#define MessageCenter @"/Api/WisdomFamily/MessageCenter"//获取消息中心接口
#define SavePic @"/Api/Login/SavePic"//上传头像接口
#define Login @"/Api/Login/Login"//登录接口
#define FamilyList @"/Api/Login/FamilyList"//获取家庭信息（列表）接口
#define SingleNeighborShop @"/NeighborShop/NeighborShop/SingleNeighborShop"//获取商品详情接口
#define ReadMessage @"/Api/WisdomFamily/ReadMessage"//阅读消息中心（单条）接口
#define NeighborShopListByUserId @"/NeighborShop/NeighborShop/NeighborShopListByUserId"//获取我发布的商品列表
#define DeleteNeighborShop @"/NeighborShop/NeighborShop/DeleteNeighborShop"//下架我发布的商品
#define AddressData @"/ShopApi/ShopApi/AddressData"//确认订单(收货信息)
#define CreateOrder @"/ShopApi/ShopApi/CreateOrder"//创建订单
#define FamilyList @"/Api/Login/FamilyList"//获取家庭信息（列表）接口
#define Register @"/Api/Login/Register"//注册接口
#define ValidateMessage @"/Api/Login/ValidateMessage"//校验验证码接口
#define SendMessage @"/Api/Login/SendMessage"//获取验证码接口
#define NeighborShopList @"/NeighborShop/NeighborShop/NeighborShopList"//获取邻里生活商品列表接口
#define SortList @"/ShopApi/ShopApi/SortList"//获取商品分类
#define ShopList @"/ShopApi/ShopApi/ShopList"//获取我发布的商品列表
#define ShoppingCartList @"/ShopApi/ShopApi/ShoppingCartList"//获取购物车列表
#define DeleteShoppingCart @"/ShopApi/ShopApi/DeleteShoppingCart"//删除购物车
#define SingleAddress @"/ShopApi/ShopApi/SingleAddress"//获取单个收货地址信息
#define DeleteAddress @"/ShopApi/ShopApi/DeleteAddress"//删除收货地址
#define DiscountList @"/Api/Share/DiscountList"//优惠获利列表接口
#define EstateList @"/Api/Share/EstateList"//查阅获利列表接口
#define GetAlipayList @"/Api/AlipayAccount/GetAlipayList"//获取支付宝账号接口
#define ReferDraw @"/Api/Share/ReferDraw"//提交申请提现接口
#define AddAccount @"/Api/AlipayAccount/AddAccount"//添加支付宝账号接口
#define DeleteAlipay @"/Api/AlipayAccount/DeleteAlipay"//删除支付宝账号接口
#define MyIncome @"/Api/Share/MyIncome"//我的收益接口
#define DrawData @"/Api/Share/DrawData"//申请提现页面数据接口
#define MyBill @"/Api/Share/MyBill"//我的账单接口
#define EditMessage @"/Api/Login/EditMessage"//忘记密码获取验证码
#define EditRegister @"/Api/Login/EditRegister"//忘记密修改密码
#define MyOrderList @"/ShopApi/ShopApi/MyOrderList"//我的订单接口
#define CheckVersion @"/Api/Login/CheckVersion"//检查版本号接口
#define GetShareRoles @"/Api/Share/GetShareRoles"//获取房产分享规则接口
#define CompleteOrder @"/ShopApi/ShopApi/CompleteOrder"//确认收货
#define CancleOrder @"/ShopApi/ShopApi/CancleOrder"//取消订单
#define OrderDetail @"/ShopApi/ShopApi/OrderDetail"//查询订单详情
#define TuiList @"/ShopApi/ShopApi/TuiList"//我的退货订单接口
#define ReturnOrder @"/ShopApi/ShopApi/ReturnOrder"//申请退还货
#define OffNeighborShop @"/NeighborShop/NeighborShop/OffNeighborShop"//查看单个下架商品详情
#define ShopUrl @"/Api/Share/ShopUrl"//生态商城分享地址
#define ShopShareSucess @"/Api/Share/ShopShareSucess"//生态商城分享成功
#define ShareSucess @"/Api/Share/ShareSucess"//分享房产成功接口
#define BrokenLine @"/Api/Share/BrokenLine"//用分享商品购买曲线图数据
#define MallProfit @"/Api/Share/MallProfit"//用户分享获利列表
#define sharelist @"/Api/Share/sharelist"//用户分享商品列表
#define DelShare @"/Api/Share/DelShare"//用户删除分享的商品
#define interes @"/Neighborhood/Neighborhood/interes"//获取兴趣圈子的分类
#define intereslist @"/Neighborhood/Neighborhood/intereslist"//获取兴趣圈子的分类下的信息列表
#define peradd @"/Neighborhood/Neighborhood/peradd"//邻里圈子用户发布信息
#define Singleinteres @"/Neighborhood/Neighborhood/Singleinteres"//获取圈子发布信息详情
#define persingle @"/Neighborhood/Neighborhood/persingle"//用户发布信息的详情
#define wblist @"/Neighborhood/Neighborhood/wblist"//工作圈子和商务圈子的列表
#define perlist @"/Neighborhood/Neighborhood/perlist"//用户发布信息的列表
#define delsingle @"/Neighborhood/Neighborhood/delsingle"//用户删除发的布信息

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClientWithURLString:(NSString *)urlstring;
+ (instancetype)sharedClient;
@end
