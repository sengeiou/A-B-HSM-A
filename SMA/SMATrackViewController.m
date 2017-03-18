//
//  SMATrackViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/22.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMATrackViewController.h"

@interface SMATrackViewController ()<MKMapViewDelegate>
{
    NSMutableArray *hrArr;
    NSMutableArray *runArr;
    SMAMKMapView *MKmapView;
    NSMutableArray *locationArr;
    SMATrackDetailView *trackview;
}
@property (nonatomic, strong) SMADatabase *dal;
@end

@implementation SMATrackViewController

- (SMADatabase *)dal{
    if (!_dal) {
        _dal = [[SMADatabase alloc] init];
    }
    return _dal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    hrArr = [self.dal readRunHearReatDataWithDate:[_runDic objectForKey:@"DATE"] startTime:[self convertToMin:[_runDic objectForKey:@"STARTTIME"]] endTime:[self convertToMin:[self.runDic objectForKey:@"ENDTIME"]] detail:YES];
    NSDictionary *dic = [self.dal readSummaryHreatReatWithDate:[_runDic objectForKey:@"DATE"]startTime:[self convertToMin:[_runDic objectForKey:@"STARTTIME"]] endTime:[self convertToMin:[self.runDic objectForKey:@"ENDTIME"]]];
    runArr = [self.dal readRunDetailDataWithDate:[_runDic objectForKey:@"DATE"] startTime:[self convertToMin:[_runDic objectForKey:@"STARTTIME"]] endTime:[self convertToMin:[self.runDic objectForKey:@"ENDTIME"]]];
    [self getFullDetailViewWithHrDic:dic];
    NSLog(@"gg===%@",hrArr);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    SMADatabase *base = [[SMADatabase alloc] init];
    locationArr = [base readLocationDataWithDate:[NSString stringWithFormat:@"%@%@%@00",[_runDic objectForKey:@"DATE"],[[[_runDic objectForKey:@"STARTTIME"] componentsSeparatedByString:@":"] firstObject],[[[_runDic objectForKey:@"STARTTIME"] componentsSeparatedByString:@":"] lastObject]] toDate:[NSString stringWithFormat:@"%@%@%@30",[_runDic objectForKey:@"DATE"],[[[_runDic objectForKey:@"ENDTIME"] componentsSeparatedByString:@":"] firstObject],[[[_runDic objectForKey:@"ENDTIME"] componentsSeparatedByString:@":"] lastObject]]];
}

- (void)createUI{
    
   MKmapView = [[SMAMKMapView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 300)];
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
//    mTap.numberOfTapsRequired = 1;
    [MKmapView addGestureRecognizer:mTap];
    [MKmapView drawOverlayWithPoints:[@[locationArr] mutableCopy]];
    [self.view addSubview:MKmapView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    trackview = [SMATrackDetailView initializeView];
    [trackview updateUIwithData:_runDic];
    [trackview tapPushBut:^(UIButton *pushBut) {
        NSLog(@"tapPush");
        SMARunHrViewController *runHRVC = [[SMARunHrViewController alloc] init];
        runHRVC.hrArr = hrArr;
        [self.navigationController pushViewController:runHRVC animated:YES];
    }];
    [trackview tapGesture:^(BOOL gesture) {
        if (gesture) {
            [UIView animateWithDuration:0.5 animations:^{
                MKmapView.frame = CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 104);
            }];
        }
        else{
            [UIView animateWithDuration:0.5 animations:^{
                 MKmapView.frame = CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 300);
            }];
        }

    }];
    [self.view addSubview:trackview];
   
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
        [trackview tapAction:nil];
}

- (void)getFullDetailViewWithHrDic:(NSDictionary *)dictionary{
    int runTime = [self convertToMin:[_runDic objectForKey:@"ENDTIME"]] - [self convertToMin:[_runDic objectForKey:@"STARTTIME"]];
    [_runDic setObject:[self putPaceWithStep:[[_runDic objectForKey:@"ENDSTEP"] intValue] - [[_runDic objectForKey:@"STARTSTEP"] intValue] duration:[self convertToMin:[_runDic objectForKey:@"ENDTIME"]] - [self convertToMin:[_runDic objectForKey:@"STARTTIME"]]] forKey:@"PACE"];
    [_runDic setObject:[NSString stringWithFormat:@"%@%d:%@%d:00",runTime/60 < 10 ? @"0":@"",runTime/60,runTime%60 < 10 ? @"0":@"",runTime%60] forKey:@"RUNTIME"];
    [_runDic setObject:[self putHrWithReat:[NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"avgHR"] intValue]]] forKey:@"AVGHR"];
    [_runDic setObject:[self putHrWithReat:[dictionary objectForKey:@"maxHR"]] forKey:@"MAXHR"];
    
}

- (int)convertToMin:(NSString *)time{
    return [[[time componentsSeparatedByString:@":"] firstObject] intValue] * 60 + [[[time componentsSeparatedByString:@":"] lastObject] intValue];
}

- (NSMutableAttributedString *)putPaceWithStep:(int)step duration:(int)time{
     SMAUserInfo *user = [SMAAccountTool userInfo];
    float distance = [SMACalculate countKMWithHeigh:user.userHeight.intValue step:step];
   NSString *paceStr = nil;
     NSString *unitStr = nil;
    if (user.unit.intValue) {
        int minute = time/[SMACalculate convertToMile:distance];
        paceStr = [NSString stringWithFormat:@"%d’%@%d‘’",minute/60,minute%60 < 10 ? @"0":@"",minute%60];
        if (time == 0 || distance == 0) {
            paceStr = @"0’00’’";
        }
       unitStr = SMALocalizedString(@"device_RU_pace_brUnit");
       
    }
    else{
        int minute = time/distance;
        paceStr = [NSString stringWithFormat:@"%d’%@%d’’",minute/60,minute%60 < 10 ? @"0":@"",minute%60];
        if (time == 0 || distance == 0) {
            paceStr = @"0’00’’";
        }
        unitStr = SMALocalizedString(@"device_RU_pace_meUnit");
    }
    
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(19)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(14)};
    NSMutableAttributedString *perAttStr = [[NSMutableAttributedString alloc] initWithString:paceStr attributes:disDic];
    NSAttributedString *unitAtt = [[NSAttributedString alloc] initWithString:unitStr attributes:unitDic];
    [perAttStr appendAttributedString:unitAtt];
    return perAttStr;
}

- (NSMutableAttributedString *)putHrWithReat:(NSString *)hr {
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(19)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(14)};
    NSMutableAttributedString *perAttStr = [[NSMutableAttributedString alloc] initWithString:hr ? hr:@"0" attributes:disDic];
    NSAttributedString *unitAtt = [[NSAttributedString alloc] initWithString:@"bpm" attributes:unitDic];
    [perAttStr appendAttributedString:unitAtt];
    return perAttStr;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
