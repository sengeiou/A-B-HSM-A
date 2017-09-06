//
//  BLConnect.m
//  SMABLTEXT
//
//  Created by 有限公司 深圳市 on 15/12/28.
//  Copyright © 2015年 SmaLife. All rights reserved.
//

#import "BLConnect.h"

@interface BLConnect ()
@property (nonatomic, strong) NSTimer *reunionTimer;
@property (nonatomic, assign)BOOL firstInitilize;
@end

@implementation BLConnect
@synthesize peripherals,cameraIndex;
/*********** 蓝牙单例公共对象构建  begin ***********/
// 用来保存唯一的单例对象
static id _instace;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedCoreBlueTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
        [_instace initilize];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}

-(void)initilize
{
    SmaBleSend.delegate = self;
    self.firstInitilize = YES;
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"Alarm.mp3" withExtension:Nil];
    
    //2.实例化播放器
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    _player.volume = 1.0;
    //3.缓冲
    [_player prepareToPlay];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    //    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self getSystemVolumSlider];
}

- (UISlider*)getSystemVolumSlider{
    static UISlider * volumeViewSlider = nil;
    if (volumeViewSlider == nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(10, 50, 200, 4)];
        for (UIView* newView in volumeView.subviews) {
            if ([newView.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)newView;
                break;
            }
        }
    }
    return volumeViewSlider;
}

- (void)openCamera{
    if (_picker) {
        [_picker removeFromParentViewController];
        _picker = nil;
    }
    __block UIImagePickerControllerSourceType sourceType ;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        //        [SmaBleSend setBLcomera:YES];
        if (!_picker) {
            _picker = [[UIImagePickerController alloc] init];//初始化
            _picker.delegate = self;
            _picker.allowsEditing = YES;//设置可编辑
        }
        _picker.sourceType = sourceType;
        [app.window.rootViewController presentViewController:_picker animated:YES completion:^{
            
        }];
    }
    else{
        [MBProgressHUD showError:SMALocalizedString(@"me_no_photograph")];
    }
}

- (SMAUserInfo *)user{
    _user = [SMAAccountTool userInfo];//为了能获取个人资料最新资料
    return _user;
}

- (void)setScanNameArr:(NSArray *)scanNameArr{
    _scanNameArr = scanNameArr;
    SMAUserInfo *user = [SMAAccountTool userInfo];
    // user.scnaName = scanName;
    user.scnaNameArr = scanNameArr;
    [SMAAccountTool saveUser:user];
}

- (BOOL)checkBLConnectState{
    if (self.user.watchUUID) {
        if (self.peripheral.state == CBPeripheralStateConnected) {
            if (_syncing) {
                [MBProgressHUD showError:SMALocalizedString(@"device_SP_syncWait")];
                return NO;
            }
            return YES;
        }
        else{
            [MBProgressHUD showError:SMALocalizedString(@"aler_conFirst")];
        }
    }
    else{
        [MBProgressHUD showError:SMALocalizedString(@"aler_bandDevice")];
    }
    return NO;
}

//查找蓝牙设备
- (void)scanBL:(int)time{
    if (self.mgr) {
        self.mgr = nil;
    }
    if (!self.mgr) {
        NSLog(@"wgerijopehijp +++++0000000000000000000000");
        if (_firstInitilize) {
            self.mgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
            
            self.firstInitilize = NO;
        }
        else{
            self.mgr =  [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey:@NO}];
        }
    }
    [self stopSearch];
    if (time) {
        self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerFireScan) userInfo:nil repeats:YES];
    }
}

//开启设备重连机制
- (void)reunitonPeripheral:(BOOL)open{
    if (open) {
        if (self.user.watchUUID) {
            if (!self.peripheral && self.peripheral.state != CBPeripheralStateConnected) {
                [self scanBL:0];
            }
            if (!_reunionTimer) {
                _reunionTimer = [NSTimer scheduledTimerWithTimeInterval:12 target:self selector:@selector(reunionTimer:) userInfo:nil repeats:YES];
            }
        }
    }
    else{
        [self stopSearch];
        if (_reunionTimer) {
            [_reunionTimer invalidate];
            _reunionTimer = nil;
        }
    }
}

- (void)reunionTimer:(id)sender{
    NSLog(@"fwefwefwergrg==== %d  %ld",SmaDfuManager.dfuMode,(long)self.peripheral.state);
    self.mgr.delegate = self;//确保DFU升级后重设代理以确保通讯正常
    if (self.peripheral.state != CBPeripheralStateConnected && !SmaDfuManager.dfuMode && !_repairDfu && !_repairFont) {
        if (self.user.watchUUID && ![self.user.watchUUID isEqualToString:@""] ) {
            NSArray *allPer = [SmaBleMgr.mgr retrievePeripheralsWithIdentifiers:@[[[NSUUID alloc] initWithUUIDString:self.user.watchUUID]]];
            NSLog(@"2222222222wgrgg---==%@  %@",allPer, _user.watchUUID);
            [self connectBl:[allPer firstObject]];
        }
        //        NSArray *SystemArr = [SmaBleMgr.mgr retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"],[CBUUID UUIDWithString:@"00001530-1212-EFDE-1523-785FEABCD123"]]];
        //        NSLog(@"重连系统连接设备====%@  %@",SystemArr,self.user.watchUUID);
        //        if (SystemArr.count > 0) {
        //            [SystemArr enumerateObjectsUsingBlock:^(CBPeripheral *obj, NSUInteger idx, BOOL *stop) {
        //                if ([obj.identifier.UUIDString isEqual:self.user.watchUUID]) {
        //                    NSLog(@"重连系统设备");
        //                    [self connectBl:obj];
        //                }
        //                else{
        //                    [self stopSearch];
        //                    [self scanBL:0];
        //                }
        //            }];
        //        }
        //        else{
        //            NSLog(@"外部搜索设备");
        //            [self stopSearch];
        //            [self scanBL:0];
        //        }
    }
    else if(SmaDfuManager.dfuMode || _repairDfu){
        
        NSArray *SystemArr1 = [SmaBleMgr.mgr retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"],[CBUUID UUIDWithString:@"00001530-1212-EFDE-1523-785FEABCD123"]]];
        NSLog(@"重连系统连接设备====%@  %@",SystemArr1,self.user.watchUUID);
        
        if (SystemArr1.count > 0) {
            [SystemArr1 enumerateObjectsUsingBlock:^(CBPeripheral *obj, NSUInteger idx, BOOL *stop) {
                if ([obj.identifier.UUIDString isEqual:self.user.watchUUID]) {
                    //                            NSLog(@"重连系统设备");
                    [self connectBl:obj];
                    
                }
                //                        else{
                //                            [self stopSearch];
                //                            [self scanBL:0];
                //                        }
            }];
        }
        else{
            NSLog(@"外部搜索设备");
            //                    [self stopSearch];
            //                    [self scanBL:0];
        }
        
        [self.peripherals removeAllObjects];
        self.peripherals = nil;
        NSArray *SystemArr = [SmaBleMgr.mgr retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"00001530-1212-EFDE-1523-785FEABCD123"]]];
        NSArray *allPer = [SmaBleMgr.mgr retrievePeripheralsWithIdentifiers:@[[[NSUUID alloc] initWithUUIDString:@"00001530-1212-EFDE-1523-785FEABCD123"]]];
        NSLog(@"fwgwggh===%@ \n SystemArr %@",allPer,SystemArr);
        if (SystemArr.count > 0) {
            [SmaDfuManager performDFUwithManager:self.mgr periphral:[SystemArr firstObject]];
            [SmaBleMgr reunitonPeripheral:NO];
        }
        else{
            [self performSelector:@selector(scanPerformDFU) withObject:nil afterDelay:3.5f];
        }
    }
    //    else if (_repairDfu && _repairFont){
    //
    //    }
}

- (void)scanPerformDFU{
    NSLog(@"scanPerformDFU====");
    [self.mgr scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"00001530-1212-EFDE-1523-785FEABCD123"],[CBUUID UUIDWithString:@"7905F431-B5CE-4E99-A40F-4B1E122D00D0"]] options:nil];
}

//停止搜索
- (void)stopSearch{
    NSLog(@"停止搜索");
    [self.mgr stopScan];
    if (self.scanTimer) {
        [self.scanTimer invalidate];
        self.scanTimer = nil;
        //        [self.peripherals removeAllObjects];
        //        self.peripherals = nil;
        //        self.sortedArray = nil;
    }
}

//连接设备
- (void)connectBl:(CBPeripheral *)peripheral{
    if (peripheral) {
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        SmaBleSend.p = peripheral;
        [self.mgr connectPeripheral:self.peripheral options:nil];
    }
}

//断开链接
- (void)disconnectBl{
    if (self.peripheral) {
        [self.mgr cancelPeripheralConnection:self.peripheral];
    }
}

//设备更新状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"初始化中，请稍后……");
            break;
        case CBCentralManagerStateResetting:
            NSLog( @"设备不支持状态，过会请重试……");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"设备未授权状态，过会请重试……");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"设备未授权状态，过会请重试……");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"尚未打开蓝牙，请在设置中打开……");
            if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleDisconnected:)]){
                [self.BLdelegate bleDisconnected:@"蓝牙关闭"];
            }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            NSLog( @"蓝牙已经成功开启，正在扫描蓝牙接口……");
            if (self.user.watchUUID && ![self.user.watchUUID isEqualToString:@""] && !_repairDfu &&!_repairFont) {
                NSArray *allPer = [SmaBleMgr.mgr retrievePeripheralsWithIdentifiers:@[[[NSUUID alloc] initWithUUIDString:self.user.watchUUID]]];
                NSLog(@"222221111222222222wgrgg---==%@  %@",allPer, _user.watchUUID);
                [self connectBl:[allPer firstObject]];
            }
            else if(_repairFont && !SmaDfuManager.dfuMode){
                NSArray *SystemArr = [SmaBleMgr.mgr retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"]]];
                //                if
            }
            else{
                [self.peripherals removeAllObjects];
                self.peripherals = nil;
                [self.mgr scanForPeripheralsWithServices:nil options:nil];
            }
            //            NSArray *SystemArr = [SmaBleMgr.mgr retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"],[CBUUID UUIDWithString:@"00001530-1212-EFDE-1523-785FEABCD123"]]];
            //            NSLog(@"扫描系统连接设备====%@",SystemArr);
            //            __block int blNum = 0;
            //            if (SystemArr.count > 0) {
            //                [SystemArr enumerateObjectsUsingBlock:^(CBPeripheral *obj, NSUInteger idx, BOOL *stop) {
            //                    blNum ++;
            //                    if ([obj.identifier.UUIDString isEqual:self.user.watchUUID]) {
            //                        NSLog(@"重连系统设备");
            //                        [self connectBl:obj];
            //                        blNum --;
            //                    }
            //                    else{
            //                        NSLog(@"搜索外部设备 = %d",blNum);
            //                        if (blNum == SystemArr.count) {
            //                            [self.peripherals removeAllObjects];
            //                            self.peripherals = nil;
            //                            [self.mgr scanForPeripheralsWithServices:nil options:nil];
            //                        }
            //                    }
            //                }];
            //            }
            //            else{
            //                NSLog(@"扫描外部搜索设备");
            //                [self.peripherals removeAllObjects];
            //                self.peripherals = nil;
            //                [self.mgr scanForPeripheralsWithServices:nil options:nil];
            //            }
        }
            break;
        default:
            break;
    }
}

//发现周边蓝牙设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"搜索设备UUID：%@  记录UUID：%@  scanName: %@  %@",peripheral.identifier.UUIDString,self.user.watchUUID,self.scanNameArr,peripheral.services);
    if (self.user.watchUUID && !_repairDfu && !_repairFont) {
        if ([self.user.watchUUID isEqualToString:peripheral.identifier.UUIDString]) {
            [self connectBl:peripheral];
        }
        if (SmaDfuManager.dfuMode) {
            [SmaDfuManager performDFUwithManager:self.mgr periphral:peripheral];
        }
    }
    else if (_repairFont && _repairDfu){
        if (SmaDfuManager.dfuMode) {
            [SmaDfuManager performDFUwithManager:self.mgr periphral:peripheral];
            return;
        }
        Byte *testByte = (Byte *)[(NSData *)[advertisementData objectForKey:@"kCBAdvDataManufacturerData"] bytes];
        NSData *data = (NSData *)[advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
        NSString *str;
        if (data) {
            Byte byteFont[[data length] - 2];
            memcpy(&byteFont, &testByte[2], [data length] - 2);
            str = [[NSString alloc] initWithData:[NSData dataWithBytes:byteFont length:[data length] - 2] encoding:kCFStringEncodingUTF8];
            NSLog(@"字库修复连接设备 %@  %@  %s  %@",[NSData dataWithBytes:byteFont length:[data length] - 2],str,byteFont,advertisementData);
        }
        if ( RSSI.intValue > -43 && [str isEqualToString:@"FixFont"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self connectBl:peripheral];
            });
        }
    }
    else if (SmaDfuManager.dfuMode){
        [SmaDfuManager performDFUwithManager:self.mgr periphral:peripheral];
    }
    //    else if(_repairDfu){
    //
    //    }
    else{
        if ([self.scanNameArr containsObject:peripheral.name] && RSSI.intValue < 0) {
            NSLog(@"搜索出来的设备  %@  %d",peripheral,RSSI.intValue);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!peripherals) {
                    peripherals = [NSMutableArray array];
                }
                ScannedPeripheral* sensor = [ScannedPeripheral initWithPeripheral:peripheral rssi:RSSI.intValue UUID:peripheral.identifier.UUIDString];
                if (![peripherals containsObject:sensor])
                {
                    [peripherals addObject:sensor];
                }
                else
                {
                    sensor = [peripherals objectAtIndex:[peripherals indexOfObject:sensor]];
                    sensor.RSSI = RSSI.intValue;
                }
                _sortedArray = [peripherals sortedArrayUsingComparator:^NSComparisonResult(ScannedPeripheral *obj1, ScannedPeripheral *obj2){
                    if (obj1.RSSI > obj2.RSSI){
                        return NSOrderedAscending;
                    }
                    if (obj1.RSSI  < obj2.RSSI ){
                        return NSOrderedDescending;
                    }
                    return NSOrderedSame;
                }];
                NSLog(@"排序后的数组：%@",self.user);
                if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(reloadView)]) {
                    [self.BLdelegate reloadView];
                }
            });
        }
        //        else{
        //            if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(reloadView)]) {
        //                [self.BLdelegate reloadView];
        //            }
        //        }
    }
    if (SmaDfuManager.dfuMode) {
        NSLog(@"fwggpghohp===%@",peripheral.name);
    }
    if (SmaDfuManager.dfuMode && [peripheral.name isEqualToString:@"Dfu10B10"]) {
        //        [self stopSearch];
        //        [self connectBl:peripheral];
    }
    
}

//连接上蓝牙后调用
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接上蓝牙后调用 %@",self.peripheral);
    [self stopSearch];
    [self.peripheral discoverServices:nil];
}

//发现设备服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"发现设备服务");
    for (int i=0; i < peripheral.services.count; i++) {
        CBService *s = [peripheral.services objectAtIndex:i];
        NSLog(@"fwgwhh===%@",s.UUID.UUIDString);
        if ([s.UUID.UUIDString isEqualToString:@"00001530-1212-EFDE-1523-785FEABCD123"]) {
            
            //通过通知中心发送通知
            //            [SmaDfuManager OTAnotPeripheralWithMgr:self.mgr peripheral:peripheral];
        }
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(blediDWriteValueForCharacteristicError:)]) {
        [self.BLdelegate blediDWriteValueForCharacteristicError:error];
    }
    if (error && error.code == 8) {
        [SmaBusinessTool setSerialNum];
    }
    NSLog(@"didWriteValueForCharacteristic  %@",error);
}

//发现到特定蓝牙特征时调用
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"发现到特定蓝牙特征时调用");
    if (self.characteristics) {
        [self.characteristics removeAllObjects];
        self.characteristics = nil;
    }
    [SMADefaultinfos putKey:SMACUSTOM andValue:@""];
    self.characteristics = [NSMutableArray array];
    for (CBCharacteristic * characteristic in service.characteristics) {
        NSLog(@"%@===+%@",characteristic.UUID.UUIDString,self.user);
        [self.characteristics addObject:characteristic.UUID.UUIDString];
        if ([characteristic.UUID.UUIDString isEqualToString:@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            SmaBleSend.Write = characteristic;
            SMAUserInfo *user = [SMAAccountTool userInfo];
            if (user.watchUUID && !_repairFont && !_repairDfu && !SmaDfuManager.dfuMode) {
                [SmaBusinessTool setSerialNum];
                [SmaBleSend setHighSpeed:YES];
                self.bandDevice = YES;
                [SmaBleSend LoginUserWithUserID:user.userID];
            }
            if (SmaDfuManager.dfuMode || _repairDfu) {
                [SmaBleSend setOTAstate];
            }
            else if (!user.watchUUID && !_repairFont && !_repairDfu){
                [SmaBusinessTool setSerialNum];
                self.bandDevice = NO;
                [SmaBleSend bindUserWithUserID:user.userID];
                if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleBindState:)]){
                    [self.BLdelegate bleBindState:0];
                }
            }
        }
        else if ([characteristic.UUID.UUIDString isEqualToString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            /* 监听蓝牙返回的情况 */
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        else if ([characteristic.UUID.UUIDString isEqualToString:@"2A29"]){
            [self.peripheral readValueForCharacteristic:characteristic];
        }
        
    }
    if (_repairFont && _repairDfu) {
        NSLog(@"进入XMODE模式");
        SmaBleSend.isUPDateSwitch = NO;
        [self performSelector:@selector(getXmodem) withObject:nil afterDelay:3];
    }
    SMAUserInfo *user = [SMAAccountTool userInfo];
    user.scnaName = peripheral.name;
    [SMAAccountTool saveUser:user];
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleDidConnect)] && !SmaDfuManager.dfuMode){
        [self.BLdelegate bleDidConnect];
    }
}

- (void)getXmodem{
    SmaBleSend.isUPDateFont = YES;
    [SmaBleSend enterXmodem];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接问题 %@",error);
    SMALocatiuonManager *loca =  [SMALocatiuonManager sharedCoreBlueTool];
    loca.allowLocation = NO;
    loca.gatherLocation = NO;
    [loca stopLocation];
    SMADatabase *db = [[SMADatabase alloc] init];
    if (loca.firstRunDic) {
        [db deleteLocationFromTime:[loca.firstRunDic objectForKey:@"DATE"] finish:^(id finish) {
            
        }];
        loca.firstRunDic = nil;
    }
    
    if ([SMAAccountTool userInfo].watchUUID && ![[SMAAccountTool userInfo].watchUUID isEqualToString:@""]  && !SmaDfuManager.dfuMode && !_repairDfu && !_dfuUpdate && !_repairFont) {
        [self connectBl:peripheral];
    }
    
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleDisconnected:)]){
        [self.BLdelegate bleDisconnected:error.localizedDescription];
    }
    
}

-(void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID.UUIDString isEqualToString:@"2A29"]){
        NSData *data = characteristic.value;
        NSString *customStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [SMADefaultinfos putKey:SMACUSTOM andValue:customStr];
    }
    //    NSLog(@"fwggghhhh===%@",characteristic.value);
    [SmaBleSend handleResponseValue:characteristic];
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleDidUpdateValue:)]) {
        [self.BLdelegate bleDidUpdateValue:characteristic];
    }
}

- (void)timerFireMethod{
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(reloadView)]) {
        //        [self.BLdelegate reloadView];
    }
}

- (void)timerFireScan{
    NSLog(@"超时停止搜索");
    [self.mgr stopScan];
    if (self.scanTimer) {
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
    //   [self.peripherals removeAllObjects];
    //   self.peripherals = nil;
    //    _sortedArray = [peripherals sortedArrayUsingComparator:^NSComparisonResult(ScannedPeripheral *obj1, ScannedPeripheral *obj2){
    //        if (obj1.RSSI > obj2.RSSI){
    //            return NSOrderedAscending;
    //        }
    //        if (obj1.RSSI  < obj2.RSSI ){
    //            return NSOrderedDescending;
    //        }
    //        return NSOrderedSame;
    //    }];
    //    NSLog(@"排序后的数组：%@",_sortedArray);
    //
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(searchTimeOut)]) {
        [self.BLdelegate searchTimeOut];
    }
    //    [self.mgr scanForPeripheralsWithServices:nil options:nil];
    //    [self.peripherals removeAllObjects];
}

#pragma mark ********SamCoreBlueToolDelegate*******
- (void)bleDataParsingWithMode:(SMA_INFO_MODE)mode dataArr:(NSMutableArray *)array Checkout:(BOOL)check{
    NSLog(@"mac---%d",array.count);
    SMADatabase *dal = [[SMADatabase alloc] init];
    switch (mode) {
        case BAND:
            if([array[0] intValue])//绑定成功
            {
                SMAUserInfo *user = [SMAAccountTool userInfo];
                user.watchUUID = self.peripheral.identifier.UUIDString;
                [SMAAccountTool saveUser:user];
                [SmaBleSend LoginUserWithUserID:self.user.userID];
                //                _bandDevice = YES;
                if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleBindState:)]){
                    [self.BLdelegate bleBindState:1];
                }
            }
            else{
                _bandDevice = NO;
                if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleBindState:)]){
                    [self.BLdelegate bleBindState:2];
                }
            }
            break;
        case LOGIN:
            if([array[0] intValue])//登录成功，
            {
                _syncing = NO;
                [self firstSet:_bandDevice];
                _bandDevice = YES;
            }
            else{
                
            }
            break;
        case MAC:
        {
            [SMADefaultinfos putKey:DEVICEMAC andValue:[array firstObject]];
            SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
            if ([SMADefaultinfos getValueforKey:DEVICEMAC] && ![[SMADefaultinfos getValueforKey:DEVICEMAC] isEqualToString:@""] && ![[SMADefaultinfos getValueforKey:DEVICEMAC] isEqualToString:@"04:03:00:00:00:00"] && ![[SMADefaultinfos getValueforKey:DEVICEMAC] isEqualToString:@"4:3:0:0:0:0"] && ![[SMADefaultinfos getValueforKey:DEVICEMAC]isEqualToString:@"00:00:00:00:00:00"] && ![[SMADefaultinfos getValueforKey:DEVICEMAC] isEqualToString:@"0:0:0:0:0:0"] && ![[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM02"] && ![[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM04"]) {
                [webservice acloudCheckMACtoWeChat:[SMADefaultinfos getValueforKey:DEVICEMAC] callBack:^(NSString *mac,NSError *error) {
                    NSLog(@"%@ claaback==%@",mac,error);
                }];
            }
        }
            break;
        case ELECTRIC:
            break;
        case VERSION:
        {
            SMAUserInfo *user = [SMAAccountTool userInfo];
            user.watchVersion = [array firstObject];
            [SMAAccountTool saveUser:user];
        }
            break;
        case CUFFSPORTDATA:
            /****
             静坐开始 10
             步行开始 11
             跑步开始 12
             运动模式开始  20 -> 32
             运动中数据    21 -> 33
             运动模式结束  2F -> 47
             *****/
            if (![[[array firstObject] objectForKey:@"NODATA"] isEqualToString:@"NODATA"]) {
                //                SmaAnalysisWebServiceTool *webTool = [[SmaAnalysisWebServiceTool alloc] init];
                //                [webTool acloudSetScore:[[[array lastObject] objectForKey:@"STEP"] intValue]];
                [dal insertSportDataArr: [self clearUpSportData:array] finish:^(id finish) {
                    //
                }];
            }
            [SmaBleSend requestCuffHRData];
            break;
        case CUFFSLEEPDATA:
            if (![[[array firstObject] objectForKey:@"NODATA"] isEqualToString:@"NODATA"]) {
                [dal insertSleepDataArr: [self clearUpSleepData:array] finish:^(id finish) {
                    
                }];
            }
            self.syncing = NO;
            break;
        case CUFFHEARTRATE:
            if (![[[array firstObject] objectForKey:@"NODATA"] isEqualToString:@"NODATA"]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    [dal insertHRDataArr:[self clearUpHRData:array] finish:^(id finish) {
                        //上传运动步数到排行榜
                    }];
                    SMADatabase *dal = [[SMADatabase alloc] init];
                    NSMutableArray *spArr = [dal readSportDataWithDate:[NSDate date].yyyyMMddNoLineWithDate toDate:[NSDate date].yyyyMMddNoLineWithDate];
                    int step = [[[spArr firstObject] objectForKey:@"STEP"] intValue];
                    SmaAnalysisWebServiceTool *webTool = [[SmaAnalysisWebServiceTool alloc] init];
                    NSDictionary *hisDic = [SMADefaultinfos getValueforKey:RUNKSTEP];
                    if ([[hisDic objectForKey:@"RUNKDATE"] isEqualToString:[[spArr firstObject] objectForKey:@"DATE"]]) {
                        if (step > [[hisDic objectForKey:@"RUNKSTEP"] intValue]){
                            NSDictionary *runStep = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",step],@"RUNKSTEP",[NSDate date].yyyyMMddNoLineWithDate,@"RUNKDATE", nil];
                            [SMADefaultinfos putKey:RUNKSTEP andValue:runStep];
                            [webTool acloudSetScore:step];
                        }
                    }
                    else{
                        NSDictionary *runStep = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",step],@"RUNKSTEP",[NSDate date].yyyyMMddNoLineWithDate,@"RUNKDATE", nil];
                        [SMADefaultinfos putKey:RUNKSTEP andValue:runStep];
                        [webTool acloudSetScore:step];
                    }
                    [webTool acloudSyncAllDataWithAccount:[SMAAccountTool userInfo].userID callBack:^(id finish) {
                        
                    }];
                });
            }
            [SmaBleSend requestCuffSleepData];
            break;
        case RUNMODE:
            NSLog(@"riunfjwfiow===%@",array);
            if (array.count == 1 && [[[array firstObject] objectForKey:@"MODE"] intValue] == 34) {//代表运动中数据（用于激活定位后台，区别于下拉刷新中的运动数据）
                SMALocatiuonManager *loca =  [SMALocatiuonManager sharedCoreBlueTool];
                loca.runStepDic = [array firstObject];
                loca.gatherLocation = YES;
                return;
            }
            if ([[[array firstObject] objectForKey:@"MODE"] intValue] == 32) {
                SMALocatiuonManager *loca =  [SMALocatiuonManager sharedCoreBlueTool];
                loca.runStepDic = [array firstObject];
                loca.gatherLocation = YES;
                loca.allowLocation = YES;
                loca.firstRunDic = [array firstObject];
                [[SMALocatiuonManager sharedCoreBlueTool] startLocation];
            }
            else if ([[[array firstObject] objectForKey:@"MODE"] intValue] == 47){
                SMALocatiuonManager *loca =  [SMALocatiuonManager sharedCoreBlueTool];
                loca.runStepDic = [array firstObject];
                loca.gatherLocation = YES;
                [[SMALocatiuonManager sharedCoreBlueTool] stopLocation];
            }
            break;
        case NOTIFICATION:
            if ([[array firstObject] intValue] == 96) {
                [SmaBleSend getCuffCalarmClockList];
            }
            if ([[array firstObject] intValue] == 97) {
                [SmaBleSend getGoal];
            }
            if ([[array firstObject] intValue] == 100) {
                [SmaBleSend getLongTime];
            }
            if ([[array firstObject] intValue] == 103) {
                //                self.cameraIndex = @"1";
                [self openCamera];
            }
            break;
        case ALARMCLOCK:
            NSLog(@"(((***  == %@",array);
            if (![[array firstObject] isKindOfClass:[NSDictionary class]]) {
                array = [[[array reverseObjectEnumerator] allObjects] mutableCopy];
                [dal deleteAllClockWithAccount:[SMAAccountTool userInfo].userID Callback:^(BOOL result) {
                    
                }];
                for (SmaAlarmInfo *info in array) {
                    info.isWeb = @"0";
                    info.aid = nil;
                    if (!info.tagname) {
                        info.tagname = @"";
                    }
                    NSLog(@"fwgiojo  n =%@",info.tagname);
                    [dal insertClockInfo:info account:[SMAAccountTool userInfo].userID callback:^(BOOL result) {
                        
                    }];
                }
            }
            else{
                [dal deleteAllClockWithAccount:[SMAAccountTool userInfo].userID Callback:^(BOOL result) {
                    
                }];
            }
            break;
        case GOALCALLBACK:{
            SMAUserInfo *user = [SMAAccountTool userInfo];
            if ([[array firstObject] isKindOfClass:[NSString class]]) {
                user.userGoal = [array firstObject];
                [SMAAccountTool saveUser:user];
            }
        }
            break;
        case LONGTIMEBACK:{
            SmaSeatInfo *seat = [SMAAccountTool seatInfo];
            if (!seat) {
                seat = [[SmaSeatInfo alloc] init];
                seat.isOpen = @"1";
                seat.repeatWeek = @"124";
                seat.beginTime0 = @"8";
                seat.endTime0 = @"21";
                seat.isOpen0 = @"0";
                seat.beginTime1 = @"9";
                seat.endTime1 = @"22";
                seat.isOpen1 = @"0";
                seat.seatValue = @"30";
                seat.stepValue = @"30";
            }
            if (![[array firstObject] isKindOfClass:[NSDictionary class]]) {
                SmaSeatInfo *info = (SmaSeatInfo *)[array firstObject];
                seat.isOpen = info.isOpen;
                seat.repeatWeek = info.repeatWeek;
                seat.beginTime0 = info.beginTime0.intValue >= 25 ? seat.beginTime0:info.beginTime0;
                seat.endTime0 = info.endTime0.intValue >= 25 ? seat.endTime0:info.endTime0;
                seat.isOpen0 = info.isOpen0;
                seat.beginTime1 = info.beginTime1.intValue >= 25 ? seat.beginTime1:info.beginTime1;;
                seat.endTime1 = info.endTime1.intValue >= 25 ? seat.endTime1:info.endTime1;
                seat.isOpen1 = info.isOpen1;
                seat.seatValue = info.seatValue;
                seat.stepValue = info.stepValue;
            }
            [SMAAccountTool saveSeat:seat];
        }
            break;
        case FINDPHONE:
            if ([[array firstObject] intValue] >= 1) {
                [self getSystemVolumSlider].value = 1.0f;
                [_player play];
            }
            else{
                [_player stop];
            }
            break;
        case BOTTONSTYPE:
        {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if ([[array firstObject] intValue] == 1) {
                if (_picker) {
                    [_picker takePicture];
                }
            }
            else if([[array firstObject] intValue] == 2){
                if (_picker) {
                    [app.window.rootViewController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }
            }        }
            break;
        case BLUTDRUCK:
//            if (![[[array firstObject] objectForKey:@"NODATA"] isEqualToString:@"NODATA"]) {
//                [dal insertbp];
//            }
            break;
        default:
            break;
    }
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bledidDisposeMode:dataArr:)]){
        [self.BLdelegate bledidDisposeMode:mode dataArr:array];
    }
}
- (void)sendIdentifier:(int)identifier{
    NSLog(@"identifier  %d %ld",identifier,SmaBleSend.serialNum);
    _sendIdentifier = identifier;
}

- (void)sendBLETimeOutWithMode:(SMA_INFO_MODE)mode{
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(sendBLETimeOutWithMode:)]){
        [self.BLdelegate sendBLETimeOutWithMode:mode];
    }
}

- (void)updateProgress:(float)pregress{
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleUpdateProgress:)]){
        [self.BLdelegate bleUpdateProgress:pregress];
    }
}
- (void)updateProgressEnd:(BOOL)success{
    if (self.BLdelegate && [self.BLdelegate respondsToSelector:@selector(bleUpdateProgressEnd:)]){
        [self.BLdelegate bleUpdateProgressEnd:success];
    }
}

- (void)firstSet:(BOOL)band{
    [SmaBleSend setSystemTime];
    [SmaBleSend setDefendLose:[SMADefaultinfos getIntValueforKey:ANTILOSTSET]];
    [SmaBleSend setSleepAIDS:[SMADefaultinfos getIntValueforKey:SLEEPMONSET]];
    [SmaBleSend setphonespark:[SMADefaultinfos getIntValueforKey:CALLSET]];
    [SmaBleSend setSmspark:[SMADefaultinfos getIntValueforKey:SMSSET]];
    [SmaBleSend setStepNumber:self.user.userGoal.intValue];
    [SmaBleSend setUserMnerberInfoWithHeight:self.user.userHeight.intValue weight:self.user.userWeigh.intValue sex:self.user.userSex.intValue age:self.user.userAge.intValue];
    SmaNoDisInfo *disInfo = [[SmaNoDisInfo alloc] init];
    disInfo.isOpen = [NSString stringWithFormat:@"%d",[[SMADefaultinfos getValueforKey:NODISTRUBSET] intValue]];
    disInfo.beginTime1 = @"0";
    disInfo.endTime1 = @"1439";
    disInfo.isOpen1 = @"1";
    [SmaBleSend setNoDisInfo:disInfo];
    
    [SmaBleSend setBacklight:[SMADefaultinfos getIntValueforKey:BACKLIGHTSET]];
    SmaVibrationInfo *vibration = [[SmaVibrationInfo alloc] init];
    vibration.type = @"5";
    vibration.freq = [NSString stringWithFormat:@"%d",[SMADefaultinfos getIntValueforKey:VIBRATIONSET]];
    [SmaBleSend setVibration:vibration];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
    if ([preferredLang isEqualToString:@"zh"]) {
        [SmaBleSend setLanguage:0];
    }
    else if ([preferredLang isEqualToString:@"es"]) {
        [SmaBleSend setLanguage:5];
    }
    else if ([preferredLang isEqualToString:@"it"]) {
        [SmaBleSend setLanguage:6];
    }
    else if ([preferredLang isEqualToString:@"ko"]) {
        [SmaBleSend setLanguage:7];
    }
    
    else if ([preferredLang isEqualToString:@"ru"]) {
        [SmaBleSend setLanguage:4];
    }
    else{
        [SmaBleSend setLanguage:1];
    }
    
    
    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"] || [[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-Q2"] || [[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B2"]) {
        [SmaBleSend setVertical:[SMADefaultinfos getIntValueforKey:SCREENSET]];
        //获取系统是24小时制或者12小时制
        NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
        NSRange containsA = [formatStringForHours rangeOfString:@"a"];
        BOOL hasAMPM = containsA.location != NSNotFound;
        [SmaBleSend setHourly:hasAMPM];
    }
    
    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B2"]) {
        [SmaBleSend setLiftBright:[SMADefaultinfos getIntValueforKey:LIFTBRIGHT]];
    }
    
    [SmaBleSend setBritishSystem:[SMADefaultinfos getIntValueforKey:BRITISHSYSTEM]];
    
    SmaHRHisInfo *HRInfo = [SMAAccountTool HRHisInfo];
    if (!HRInfo) {
        HRInfo = [[SmaHRHisInfo alloc] init];
        HRInfo.isopen0 = [NSString stringWithFormat:@"%d",1];
        HRInfo.dayFlags=@"127";//每天
        HRInfo.isopen=[NSString stringWithFormat:@"%d",1];
        HRInfo.tagname=@"30";
        HRInfo.beginhour0 = @"0";
        HRInfo.endhour0 = @"23";
        [SMAAccountTool saveHRHis:HRInfo];
    }
    SmaSeatInfo *setInfo = [SMAAccountTool seatInfo];
    
    SMADatabase *smaDal = [[SMADatabase alloc] init];
    NSMutableArray *alarmArr = [smaDal selectClockList];
    NSMutableArray *colockArry=[NSMutableArray array];
    int aid=0;
    for (int i=0; i<alarmArr.count; i++) {
        SmaAlarmInfo *info=(SmaAlarmInfo *)alarmArr[i];
        if([info.isOpen intValue]>0)
        {
            info.aid=[NSString stringWithFormat:@"%d",aid];
            [colockArry addObject:info];
            aid++;
        }
    }
    
    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-R1"] && band){
        if (setInfo){
            [SmaBleSend seatLongTimeInfoV2:setInfo];
        }
        [SmaBleSend setHRWithHR:HRInfo];
        [SmaBleSend setClockInfoV2:alarmArr];
        [SmaBleSend setPhoneSystemState:2];
    }else if (![[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-R1"]){
        if (setInfo){
            [SmaBleSend seatLongTimeInfoV2:setInfo];
        }
        [SmaBleSend setHRWithHR:HRInfo];
        [SmaBleSend setClockInfoV2:colockArry];
    }
    else{
        [SmaBleSend setPhoneSystemState:2];
        [SmaBleSend getCuffCalarmClockList];
        [SmaBleSend getLongTime];
        [SmaBleSend getGoal];
    }
    
    [SmaBleSend getElectric];
    [SmaBleSend getBLVersion];
    [SmaBleSend getBLmac];
    [SmaBleSend setPairAncs];
}

static double spInterval;
static bool isSpMode;
- (NSMutableArray *)clearUpSportData:(NSMutableArray *)dataArr{
    NSMutableArray *sp_arr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i ++) {
        NSMutableDictionary *spDic = [(NSDictionary *)dataArr[i] mutableCopy];
        [spDic setObject:SmaBleMgr.peripheral.name forKey:@"INDEX"];
        [spDic setObject:@"0" forKey:@"WEB"];
        [spDic setObject:[SMAAccountTool userInfo].userID forKey:@"USERID"];
        [sp_arr addObject:spDic];
        //        spInterval = nowInterval;
        if (i == dataArr.count - 1) {
            spInterval = 0;
        }
        
    }
    return sp_arr;
}

- (NSMutableArray *)clearUpSleepData:(NSMutableArray *)dataArr{
    NSMutableArray *sl_arr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i ++) {
        NSMutableDictionary *slDic = [(NSDictionary *)dataArr[i] mutableCopy];
        [slDic setObject:[SMADefaultinfos getValueforKey:BANDDEVELIVE] forKey:@"INDEX"];
        [slDic setObject:@"0" forKey:@"WEB"];
        [slDic setObject:@"1" forKey:@"WEAR"];
        [slDic setObject:[SMAAccountTool userInfo].userID forKey:@"USERID"];
        [sl_arr addObject:slDic];
    }
    return sl_arr;
}

- (NSMutableArray *)clearUpBPData:(NSMutableArray *)dataArr{
    NSMutableArray *sl_arr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i ++) {
        NSMutableDictionary *slDic = [(NSDictionary *)dataArr[i] mutableCopy];
        [slDic setObject:[SMADefaultinfos getValueforKey:BANDDEVELIVE] forKey:@"INDEX"];
        [slDic setObject:@"0" forKey:@"WEB"];
        [slDic setObject:[SMAAccountTool userInfo].userID forKey:@"USERID"];
        [sl_arr addObject:slDic];
    }
    return sl_arr;
}

static double hrInterval;
static bool ishrMode;
- (NSMutableArray *)clearUpHRData:(NSMutableArray *)dataArr{
    NSMutableArray *hr_arr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i ++) {
        NSMutableDictionary *hrDic = [(NSDictionary *)dataArr[i] mutableCopy];
        [hrDic setObject:SmaBleMgr.peripheral.name forKey:@"INDEX"];
        [hrDic setObject:@"0" forKey:@"WEB"];
        [hrDic setObject:[SMAAccountTool userInfo].userID forKey:@"USERID"];
        double nowInterval = [SMADateDaultionfos msecIntervalSince1970Withdate:[hrDic objectForKey:@"DATE"] timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [hr_arr addObject:hrDic];
        hrInterval = nowInterval;
        if (i == dataArr.count - 1) {
            hrInterval = 0;
        }
        
    }
    return hr_arr;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    __block UIImage* image;
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"fwgwgg-----%@",NSStringFromCGSize(image.size));
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [SmaBleSend setBLcomera:NO];
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [SmaBleSend setBLcomera:NO];
    [app.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
