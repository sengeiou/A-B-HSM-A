//
//  AppDelegate.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "AppDelegate.h"
#import "ACloudLib.h"
#import "SMANavViewController.h"
#import "SMATabbarController.h"
#import "SMALocatiuonManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    self.manager = [[CLLocationManager alloc] init];
//    self.manager.delegate = self;
//    self.manager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
//    //    _manager.distanceFilter = 30; //控制定位服务更新频率。单位是“米”
//    [self.manager requestAlwaysAuthorization];  //调用了这句,就会弹出允许框了.
//    [self.manager requestWhenInUseAuthorization];
//    self.manager.pausesLocationUpdatesAutomatically = NO; //该模式是抵抗ios在后台杀死程序设置，iOS会根据当前手机使用状况会自动关闭某些应用程序的后台刷新，该语句申明不能够被暂停，但是不一定iOS系统在性能不佳的情况下强制结束应用刷新kCLAuthorizationStatusAuthorizedAlways
//    //        [CLLocationManager authorizationStatus] = kCLAuthorizationStatusAuthorizedAlways;
//    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
//    self.manager.allowsBackgroundLocationUpdates = YES;
//    self.manager.distanceFilter = kCLDistanceFilterNone;  //不需要移动都可以刷新
//    [self.manager startUpdatingLocation];
    self.applica = application;
    [SMALocatiuonManager sharedCoreBlueTool];
    
    // Override point for customization after application launch.
    [ACloudLib setMode:ACLoudLibModeRouter Region:ACLoudLibRegionChina];
    [ACloudLib setMajorDomain:@"lijunhu" majorDomainId:375]; //282
    
    //微信初始化
    [WXApi registerApp:@"wxdce35a17f98972c9" withDescription:@"demo 2.0"];
    
    //微博初始化
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"3736959518"];
    
    //facebook初始化
    [FBSDKLikeControl class];
    [FBSDKLoginButton class];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //twitter初始化
    [Fabric with:@[[Twitter class]]];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    NSArray *itemArr = @[SMALocalizedString(@"device_title"),SMALocalizedString(@"rank_title"),SMALocalizedString(@"setting_title"),SMALocalizedString(@"me_title")];
    if (![SMADefaultinfos getValueforKey:FIRSTLUN]) {
        SMAFirstLunViewController *firstLunVC = [[SMAFirstLunViewController alloc] init];
        self.window.rootViewController = firstLunVC;
    }
    else if ([SMAAccountTool userInfo].userID && ![[SMAAccountTool userInfo].userID isEqualToString:@""]) {
        
        SMATabbarController* controller = [MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
        controller.isLogin = YES;
        NSArray *arrControllers = controller.viewControllers;
        for (int i = 0; i < arrControllers.count; i ++) {
            SMANavViewController *nav = [arrControllers objectAtIndex:i];
            nav.tabBarItem.title = itemArr[i];
        }
        
//        SMANavViewController* controller = [MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAGenderViewController"];
//        controller.leftItemHidden = YES;
//        [UIApplication sharedApplication].keyWindow.rootViewController=controller;
        self.window.rootViewController = controller;
    }
    SMAUserInfo *info =[SMAAccountTool userInfo];
    info.watchUUID = nil;
//    [SMAAccountTool saveUser:info];
    [SmaBleMgr reunitonPeripheral:YES];//开启重连机制
    //首次打开APP，默认部分设置
    if (![SMADefaultinfos getValueforKey:FIRSTLUN]) {
        [SMADefaultinfos putKey:FIRSTLUN andValue:FIRSTLUN];
        [SMADefaultinfos putInt:SLEEPMONSET andValue:1];
        [SMADefaultinfos putInt:CALLSET andValue:0];
        [SMADefaultinfos putInt:SMSSET andValue:0];
        [SMADefaultinfos putInt:SCREENSET andValue:1];
        [SMADefaultinfos putInt:ANTILOSTSET andValue:0];
        [SMADefaultinfos putInt:VIBRATIONSET andValue:2];
        [SMADefaultinfos putInt:BACKLIGHTSET andValue:2];
        [SMADefaultinfos putKey:DFUUPDATE andValue:@"1"];
        [SMADefaultinfos putInt:LIFTBRIGHT andValue:1];
        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SM07"];
    }
    [SMADefaultinfos putKey:UPDATEDATE andValue:[NSDate date].yyyyMMddNoLineWithDate];
    //         真机测试时保存日志
    if ([[[UIDevice currentDevice] model] rangeOfString:@"simulator"].location) {
//       [self redirectNSLogToDocumentFolder];
    }
    [self startLocation];
//    [self GCDDemo1];
//    [self GCDDemo2];
//    _callCenter = [[CTCallCenter alloc] init];
//    _callCenter.callEventHandler=^(CTCall* call){
//        if([call.callState isEqualToString:CTCallStateDisconnected]){
//            NSLog(@"Call has been disconnected");
////           [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//             [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//        }
//        else if([call.callState isEqualToString:CTCallStateConnected]) {
//            NSLog(@"Callhasjustbeen connected");
//        } else if([call.callState isEqualToString:CTCallStateIncoming]) {
//            NSLog(@"Call is incoming");
////             [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
////            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
////            [[AVAudioSession sharedInstance] setActive:YES error:nil];
//             [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//             [[AVAudioSession sharedInstance] setActive:YES error:nil];
//        } else if([call.callState isEqualToString:CTCallStateDialing]) {
//            NSLog(@"Call is Dialing");
//        } else {
//            NSLog(@"Nothing is done");
//        }
//    };
#if EVOLVEO
            [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SMA-B2"];
#endif
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)GCDDemo1{
    // 创建串行队列
    // 参数1 : 队列的标示符
    // 参数2 : 队列的属性,决定了队列是串行的还是并行的 SERIAL : 串行
    dispatch_queue_t queue = dispatch_queue_create("ck", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 10; i++) {
        // 创建任务
        void (^task)() = ^{
            NSLog(@"%d %@",i, [NSThread currentThread]);
        };
        // 将任务添加到队列
        dispatch_async(queue, task);
    }
}

#pragma mark - 串行队列+同步任务
// 不开线程,因为任务是同步的,只在当前线程执行
// 有序,因为队列是串行的.还因为任务是同步的
- (void)GCDDemo2{
    // 创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("ck", DISPATCH_QUEUE_SERIAL);
    // 循环创建10个同步任务,将10个同步任务添加到串行队列中
    for (int i = 0; i < 10; i++) {
        // 创建任务
        void (^task)() = ^{
            NSLog(@"%d %@",i,[NSThread currentThread]);
        };
        // 将同步任务添加到串行队列
        dispatch_sync(queue, task);
    }
}

- (void)redirectNSLogToDocumentFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"Alarm.mp3" withExtension:Nil];
    
    //2.实例化播放器
    AVAudioPlayer *_player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    _player.volume = 0;
    //3.缓冲
    [_player prepareToPlay];
    [_player play];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)locationAction{
     [[SMALocatiuonManager sharedCoreBlueTool] startLocation];
}

- (void) endBackgroundTask{
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    __weak AppDelegate *weakSelf = self;
    
    dispatch_async(mainQueue, ^(void) {
        
        AppDelegate *strongSelf = weakSelf;
        
        if (strongSelf != nil){
            
            [self.applica endBackgroundTask:self.backgroundTaskIdentifier];
            self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
            
        }
        
    });
}

//- (void)requestBackgroundTask{
//    NSLog(@"requestBackgroundTask");
//    UIApplication*   app = [UIApplication sharedApplication];
//    //    __block    UIBackgroundTaskIdentifier bgTask;
//    _bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (_bgTask != UIBackgroundTaskInvalid)
//            {
//                _bgTask = UIBackgroundTaskInvalid;
//            }
//            [self requestBackgroundTask];
//        });
//    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (_bgTask != UIBackgroundTaskInvalid)
//            {
//                _bgTask = UIBackgroundTaskInvalid;
//            }
//            [self requestBackgroundTask];
//        });
//    });
//}

- (void)requestBackgroundTask{
      [self endBackgroundTask];
    self.backgroundTaskIdentifier= [self.applica beginBackgroundTaskWithExpirationHandler:^(void) {
        [self endBackgroundTask];
    }];

}

- (void)getCell{
    NSLog(@"获取电量");
      [SmaBleSend getElectric];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    self.backgroundTaskIdentifier=[application beginBackgroundTaskWithExpirationHandler:^(void) {
//         [self endBackgroundTask];
//    }];
    if (_backgroundTimer) {
        [_backgroundTimer invalidate];
        _backgroundTimer = nil;
    }
//    _backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getCell) userInfo:nil repeats:YES];

    
//    [[SMALocatiuonManager sharedCoreBlueTool] startLocation];
//    [self requestBackgroundTask];
//    [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(requestBackgroundTask) userInfo:nil repeats:NO];
//    self.manager = [[CLLocationManager alloc] init];
//    self.manager.delegate = self;
//    self.manager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
//    //    _manager.distanceFilter = 30; //控制定位服务更新频率。单位是“米”
//    [self.manager requestAlwaysAuthorization];  //调用了这句,就会弹出允许框了.
//    [self.manager requestWhenInUseAuthorization];
//    self.manager.pausesLocationUpdatesAutomatically = NO; //该模式是抵抗ios在后台杀死程序设置，iOS会根据当前手机使用状况会自动关闭某些应用程序的后台刷新，该语句申明不能够被暂停，但是不一定iOS系统在性能不佳的情况下强制结束应用刷新kCLAuthorizationStatusAuthorizedAlways
//    //        [CLLocationManager authorizationStatus] = kCLAuthorizationStatusAuthorizedAlways;
////    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
//      self.manager.allowsBackgroundLocationUpdates = YES;
//     self.manager.distanceFilter = kCLDistanceFilterNone;  //不需要移动都可以刷新
//     [self.manager startUpdatingLocation];
//    }

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation * currLocation = [locations lastObject];
    NSLog(@"locationManager");
    NSLog(@"---%@",[NSString stringWithFormat:@"%f",currLocation.coordinate.latitude]);
    
    NSLog(@"+++%@",[NSString stringWithFormat:@"%f",currLocation.coordinate.longitude]);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (_backgroundTimer) {
        [_backgroundTimer invalidate];
        _backgroundTimer = nil;
    }
//    [self endBackgroundTask];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

   }

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
//        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        [[SMAthirdPartyManager sharedManager] wbLoginFinishWithUserID:self.wbCurrentUserID accessToken:self.wbtoken];
//        if (wbtoken && wbCurrentUserID) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessed object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"［Weibo］" ,@"LOGINTYPE",wbCurrentUserID,@"OPENID",wbtoken,@"TOKEN", nil]];
//        }
//        else{
//             [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self userInfo:[NSDictionary dictionaryWithObject:@"［Weibo］" forKey:@"LOGINTYPE"]];
//        }
//        [MBProgressHUD showError:SMALocalizedString(@"")];
//        [alert show];
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
//        NSString *title = NSLocalizedString(@"支付结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
//        NSString *title = NSLocalizedString(@"邀请结果", nil);
//        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
    }else if([response isKindOfClass:WBShareMessageToContactResponse.class])
    {
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
        WBShareMessageToContactResponse* shareMessageToContactResponse = (WBShareMessageToContactResponse*)response;
        NSString* accessToken = [shareMessageToContactResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [shareMessageToContactResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
//        [alert show];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlString=[[url absoluteString] substringToIndex:2];
    if ([urlString isEqual:@"te"]) {
     return [TencentOAuth HandleOpenURL:url];
    }
    else if ([urlString isEqual:@"wx"]){
        return  [WXApi handleOpenURL:url delegate:[SMAthirdPartyManager sharedManager]];
    }
    else if ([urlString isEqualToString:@"fb"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    else if ([urlString isEqual:@"wb"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return 0;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *urlString=[[url absoluteString] substringToIndex:2];
    if ([urlString isEqual:@"te"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([urlString isEqual:@"wx"]){
        return  [WXApi handleOpenURL:url delegate:[SMAthirdPartyManager sharedManager]];
    }
    else if ([urlString isEqual:@"wb"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return 0;
}

- (void)startLocation{
//    [[SMALocatiuonManager sharedCoreBlueTool] startLocation];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyyMMddHHmmss"];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyyMMdd"];
//    SMADatabase *base = [[SMADatabase alloc] init];
//    NSMutableArray *locationArr = [base readLocationDataWithDate:[NSString stringWithFormat:@"%@000000",[dateFormatter stringFromDate:[NSDate date]]] toDate:[NSString stringWithFormat:@"%@235959",[dateFormatter stringFromDate:[NSDate date]]]];
//    NSLog(@"location ===%@",locationArr);
}
@end
