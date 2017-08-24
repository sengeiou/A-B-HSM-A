//
//  AppDelegate.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAFirstLunViewController.h"
#import "SMAthirdPartyLoginTool.h"
//#import "WeiboSDK.h"
#import <CoreLocation/CoreLocation.h>
//#import <CoreTelephony/CTCall.h>
//#import <CoreTelephony/CTCallCenter.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITextView *textview;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (nonatomic, strong) CLLocationManager *manager;
@property (strong, nonatomic) UIApplication *applica;

@property (nonatomic, strong) NSTimer *backgroundTimer;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier bgTask;
//@property(nonatomic,strong)CTCallCenter *callCenter;  //必须在这里声明，要不不会回调block
@end

