//
//  ACloudLib.h
//  ACloudLib
//
//  Created by zhourx5211 on 14/12/8.
//  Copyright (c) 2014年 zcloud. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ACLoudLibConst.h"

#define kACloudLibVersion @"1.5.0"

typedef NS_ENUM(NSUInteger, ACLoudLibMode) {
    //测试环境
    ACLoudLibModeTest,
    //正式环境
    ACLoudLibModeRouter,
};

typedef NS_ENUM(NSUInteger, ACLoudLibRegion) {
    //中国
    ACLoudLibRegionChina,
    //东南亚
    ACLoudLibRegionSouthEastAsia,
    //欧洲
    ACLoudLibRegionCentralEurope,
    //美洲
    ACLoudLibRegionNorthAmerica,
};

@class ACMsg, ACDeviceMsg;
@interface ACloudLib : NSObject

///  获取当前SDK版本
+ (NSString *)getVersion;

///  手动修改RouterAddress方法
+ (void)setRouterAddress:(NSString *)router;

/**
 设置调试本地UDS服务的局域网服务地址
 
 例如：192.168.1.101:8080
 
 @param address  本地服务地址
 */
+ (void)setLocalUDSAddress:(NSString *)address;

/**
  初始化方法, 设置开发环境和地区
 
  测试环境使用如下地址:
  [ACloudLib setMode:ACLoudLibModeTest Region:ACLoudLibRegionChina];
 
  正式环境使用如下地址:
  [ACloudLib setMode:ACLoudLibModeRouter Region:ACLoudLibRegionChina];(中国地区, 其他地区请自行选择)
 
  @param mode   开发环境
  @param region 开发地区
 */
+ (void)setMode:(ACLoudLibMode)mode Region:(ACLoudLibRegion)region;

///  初始化方法, 设置企业级开发环境
///
///  @param majorDomain   企业主域
///  @param majorDomainId 主域id
+ (void)setMajorDomain:(NSString *)majorDomain majorDomainId:(NSInteger)majorDomainId;

///  获取当前host地址
+ (NSString *)getHost;
+ (NSString *)getHttpsHost;
+ (NSString *)getPushHost;

///  获取当前主域名
+ (NSString *)getMajorDomain;
+ (NSInteger)getMajorDomainId;

///  设置全局网络操作超时时间, 如不设置, 默认是60s
+ (void)setHttpRequestTimeout:(NSString *)timeout;
+ (NSString *)getHttpRequestTimeout;

/**
  发送消息到服务, 这里一般指发送给UDS服务
 
  Sample Code:
  当前UDS部署的子域是:`test`, 对应的服务名称是: `userService`, 方法名称是`searchUser`, 参数为`userId`, 则对应的示例代码:
 
     ACMsg *msg = [ACMsg msgWithName:@"searchUser"];
     [msg put:@"uid" value:userId];
 
     [ACloudLib sendToService:@"test"
                  serviceName:@"userService"
                      version:1
                          msg:msg
                     callback:^(ACMsg *responseMsg, NSError *error) {
                         //TODO...
     }];
 
  @param subDomain 子域名称, 一般指UDS部署的对应子域, 如果是主域级别的, 则填写`nil`
  @param name      UDS服务名称, 具体名称需到控制台查询
  @param version   UDS版本信息, 具体信息需到控制台查询
  @param msg       发送的具体操作指令
  @param callback  UDS回调
 */
+ (void)sendToService:(NSString *)subDomain
          serviceName:(NSString *)name
              version:(NSInteger)version
                  msg:(ACMsg *)msg
             callback:(void (^)(ACMsg *responseMsg, NSError *error))callback;

///  用户与设备进行局域网通讯
///
///  @param timeout          设备响应超时时常
///  @param physicalDeviceId 设备的物理id, 可通过`findDeviceTimeout:SudDomainId:callback`接口获取局域网设备信息列表
///  @param msg              发送给设备的消息指令
///  @param callback         设备的响应回调
+ (void)sendToLocalDevice:(NSTimeInterval)timeout
         physicalDeviceId:(NSString *)physicalDeviceId
                      msg:(ACDeviceMsg *)msg
                 callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback;

///  局域网发现设备
///
///  @param timeout  超时时间
///  @param callback 返回的设备列表
-(void)findDeviceTimeout:(NSInteger )timeout
                callback:(void(^)(NSArray * localDeviceList))callback;

#pragma mark - 自定义打印开关
/** 设置是否打印sdk的log信息, 默认NO(不打印log).
 @param yesOrNo 设置为YES,SDK 会输出log信息可供调试参考. 除非特殊需要，否则发布产品时需改回NO.
 @return void.
 */
+ (void)setLogEnabled:(BOOL)yesOrNo;
+ (BOOL)logEnable;


#pragma mark - Deprecated
-(void)findDeviceTimeout:(NSInteger )timeout
             SudDomainId:(NSInteger)subDomainId
                callback:(void(^)(NSArray * localDeviceList))callback ACDeprecated("请使用findDeviceTimeout:callback");

+ (void)sendToLocalDevice:(NSTimeInterval)timeout
                 deviceId:(NSInteger)deviceId
                      msg:(ACDeviceMsg *)msg
                 callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback ACDeprecated("请使用sendToLocalDevice:physicalDeviceId:msg:callback方法");


@end