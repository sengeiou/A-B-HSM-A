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
@end

