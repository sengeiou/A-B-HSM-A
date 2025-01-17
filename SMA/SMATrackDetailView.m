//
//  SMATrackDetailView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/22.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMATrackDetailView.h"

@implementation SMATrackDetailView
{
    UILabel *timeLab;
    UILabel *timeTitLab;
    UILabel *disLab;
    UILabel *perLab;
    UILabel *paceLab;
    UILabel *calLab;
    UILabel *stepLab;
    UILabel *hrLab;
    UILabel *avgLab;
    UILabel *maxLab;
    UIButton *hrTapBut;
    BOOL hidden;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [SmaColor colorWithHexString:@"#AEB5C3" alpha:1];
        ([[SMADefaultinfos getValueforKey:BANDDEVELIVE]  isEqualToString:@"SMA-B2"] || [[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B3"]) ? [self createB2UI]:[self createUI];
    }
    return self;
}

+ (instancetype)initializeView{
    SMATrackDetailView *trackView = [[self alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 300)];
    return trackView;
}

- (void)createUI{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGR];
    
    UIView *runTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 44)];
    runTimeView.backgroundColor = [SmaColor colorWithHexString:@"#5691FF" alpha:1];
    [self addSubview:runTimeView];
    
    CGSize fontSize = [@"00:00:000" sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(20)}];
    timeLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width - 10 - fontSize.width, 0, fontSize.width, 44)];
    timeLab.textColor = [UIColor whiteColor];
    timeLab.font = FontGothamLight(20);
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.text = @"00:00:00";
    
    timeTitLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetMinX(timeLab.frame) - 10, 44)];
    timeTitLab.textColor = [UIColor whiteColor];
    timeTitLab.font = FontGothamLight(16);
    timeTitLab.text = SMALocalizedString(@"device_RU_lunTime");
    
    [runTimeView addSubview:timeLab];
    [runTimeView addSubview:timeTitLab];
    
    //路程
    UIView *disView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(runTimeView.frame), MainScreen.size.width/2 - 0.5, 70)];
    disView.backgroundColor = [UIColor whiteColor];
    [self addSubview:disView];
    
    UIImageView *disIma = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 26)];
    disIma.image = [UIImage imageNamed:@"icon_distance"];
    disIma.center = CGPointMake(disIma.center.x, disView.frame.size.height/2);
    
    disLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(disIma.frame) + 8, 0, CGRectGetWidth(disView.frame) - CGRectGetMaxX(disIma.frame) - 16, 26)];
    disLab.textAlignment = NSTextAlignmentCenter;
    disLab.center = CGPointMake(disLab.center.x, CGRectGetHeight(disView.frame)/2 - 10);
    
    UILabel *disTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(disIma.frame) + 8, CGRectGetMaxY(disLab.frame) , CGRectGetWidth(disView.frame) - CGRectGetMaxX(disIma.frame) - 16, 26)];
    disTitLab.textAlignment = NSTextAlignmentCenter;
    disTitLab.font = FontGothamLight(14);
    disTitLab.text = SMALocalizedString(@"device_SP_sumDista");
    disTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [disView addSubview:disIma];
    [disView addSubview:disLab];
    [disView addSubview:disTitLab];
    
    //时速
    UIView *perView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(disView.frame) + 1, CGRectGetMaxY(runTimeView.frame), MainScreen.size.width/2 - 0.5, 70)];
    perView.backgroundColor = [UIColor whiteColor];
    [self addSubview:perView];
    
    UIImageView *perIma = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 21, 25)];
    perIma.image = [UIImage imageNamed:@"icon_speed"];
    perIma.center = CGPointMake(perIma.center.x, perView.frame.size.height/2);
    
    perLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(perIma.frame) + 8, 0, CGRectGetWidth(perView.frame) - CGRectGetMaxX(perIma.frame) -16, 26)];
    perLab.textAlignment = NSTextAlignmentCenter;
    perLab.center = CGPointMake(perLab.center.x, CGRectGetHeight(perView.frame)/2 - 10);
    
    UILabel *perTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(perIma.frame) + 8, CGRectGetMaxY(perLab.frame) , CGRectGetWidth(perView.frame) - CGRectGetMaxX(perIma.frame) +- 16, 26)];
    perTitLab.textAlignment = NSTextAlignmentCenter;
    perTitLab.font = FontGothamLight(14);
    perTitLab.text = SMALocalizedString(@"device_RU_per");
    perTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [perView addSubview:perIma];
    [perView addSubview:perLab];
    [perView addSubview:perTitLab];
    
    //配速
    UIView *paceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(disView.frame) + 1, MainScreen.size.width/2 - 0.5, 70)];
    paceView.backgroundColor = [UIColor whiteColor];
    [self addSubview:paceView];
    
    UIImageView *paceIma = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 30, 30)];
    paceIma.image = [UIImage imageNamed:@"icon_pace"];
    paceIma.center = CGPointMake(paceIma.center.x, paceView.frame.size.height/2);
    
    paceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paceIma.frame) + 4, 0, CGRectGetWidth(paceView.frame) - CGRectGetMaxX(paceIma.frame) - 8, 26)];
    paceLab.textAlignment = NSTextAlignmentCenter;
    paceLab.center = CGPointMake(paceLab.center.x, CGRectGetHeight(paceView.frame)/2 - 10);
    
    UILabel *paceTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paceIma.frame) + 8, CGRectGetMaxY(paceLab.frame) , CGRectGetWidth(paceView.frame) - CGRectGetMaxX(paceIma.frame) - 16, 26)];
    paceTitLab.textAlignment = NSTextAlignmentCenter;
    paceTitLab.font = FontGothamLight(14);
    paceTitLab.text = SMALocalizedString(@"device_RU_pace");
    paceTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [paceView addSubview:paceIma];
    [paceView addSubview:paceLab];
    [paceView addSubview:paceTitLab];
    
    //卡路里
    UIView *calView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paceView.frame) + 1, CGRectGetMaxY(disView.frame) + 1, MainScreen.size.width/2 - 0.5, 70)];
    calView.backgroundColor = [UIColor whiteColor];
    [self addSubview:calView];
    
    UIImageView *calIma = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 23, 26)];
    calIma.image = [UIImage imageNamed:@"icon_cal"];
    calIma.center = CGPointMake(calIma.center.x, calView.frame.size.height/2);
    
    calLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(calIma.frame) + 8, 0, CGRectGetWidth(calView.frame) - CGRectGetMaxX(calIma.frame) -
                                                       16, 26)];
    calLab.textAlignment = NSTextAlignmentCenter;
    calLab.center = CGPointMake(calLab.center.x, CGRectGetHeight(calView.frame)/2 - 10);
    
    UILabel *calTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(calIma.frame) + 8, CGRectGetMaxY(calLab.frame) , CGRectGetWidth(calView.frame) - CGRectGetMaxX(calIma.frame) - 16, 26)];
    calTitLab.textAlignment = NSTextAlignmentCenter;
    calTitLab.font = FontGothamLight(14);
    calTitLab.text = SMALocalizedString(@"device_SP_cal");
    calTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [calView addSubview:calIma];
    [calView addSubview:calLab];
    [calView addSubview:calTitLab];
    
    //心率
    UIView *hrTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(calView.frame), MainScreen.size.width, 44)];
    hrTimeView.backgroundColor = [SmaColor colorWithHexString:@"#FF568A" alpha:1];
    [self addSubview:hrTimeView];
    
    hrTapBut = [UIButton buttonWithType:UIButtonTypeCustom];
    hrTapBut.frame = CGRectMake(0, 0,  MainScreen.size.width, 44);
    
    [hrTimeView addSubview:hrTapBut];
    
    UIImageView *indexIma = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreen.size.width - 20, 12, 12, 20)];
    indexIma.image = [UIImage imageNamed:@"icon_next"];
    //    [hrTimeView addSubview:indexIma];
    
    CGSize fontSize2 = [@"228 bpm" sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(20)}];
    hrLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width - 20 - fontSize2.width, 0, fontSize2.width, 44)];
    hrLab.textColor = [UIColor whiteColor];
    hrLab.font = FontGothamLight(20);
    hrLab.textAlignment = NSTextAlignmentRight;
    hrLab.text = @"228 bpm";
    
    UILabel *hrTitLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetMinX(hrLab.frame) - 10, 44)];
    hrTitLab.textColor = [UIColor whiteColor];
    hrTitLab.font = FontGothamLight(16);
    hrTitLab.text = SMALocalizedString(@"device_RU_lastHR");
    
    [hrTimeView addSubview:hrLab];
    [hrTimeView addSubview:hrTitLab];
    
    //平均心率
    UIView *avgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hrTimeView.frame), MainScreen.size.width/2 - 0.5, 70)];
    avgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:avgView];
    
    UIImageView *avgIma = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, 32, 32)];
    avgIma.image = [UIImage imageNamed:@"icon_heart"];
    avgIma.center = CGPointMake(avgIma.center.x, avgView.frame.size.height/2);
    
    avgLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avgIma.frame) + 8, 0, CGRectGetWidth(avgView.frame) - CGRectGetMaxX(avgIma.frame) - 16, 26)];
    avgLab.textAlignment = NSTextAlignmentCenter;
    avgLab.center = CGPointMake(avgLab.center.x, CGRectGetHeight(avgView.frame)/2 - 10);
    
    UILabel *avgTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avgIma.frame) + 8, CGRectGetMaxY(avgLab.frame) , CGRectGetWidth(avgView.frame) - CGRectGetMaxX(avgIma.frame) - 16, 26)];
    avgTitLab.textAlignment = NSTextAlignmentCenter;
    avgTitLab.font = FontGothamLight(14);
    avgTitLab.text = SMALocalizedString(@"device_HR_mean");
    avgTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [avgView addSubview:avgIma];
    [avgView addSubview:avgLab];
    [avgView addSubview:avgTitLab];
    
    //最大心率
    UIView *maxView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avgView.frame) + 1, CGRectGetMaxY(hrTimeView.frame) , MainScreen.size.width/2 - 0.5, 70)];
    maxView.backgroundColor = [UIColor whiteColor];
    [self addSubview:maxView];
    
    UIImageView *maxIma = [[UIImageView alloc] initWithFrame:CGRectMake(5.5, 0, 32, 32)];
    maxIma.image = [UIImage imageNamed:@"icon_heart_big"];
    maxIma.center = CGPointMake(maxIma.center.x, maxView.frame.size.height/2);
    
    maxLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maxIma.frame) + 8, 0, CGRectGetWidth(maxView.frame) - CGRectGetMaxX(maxIma.frame) - 16, 26)];
    maxLab.textAlignment = NSTextAlignmentCenter;
    maxLab.center = CGPointMake(maxLab.center.x, CGRectGetHeight(maxView.frame)/2 - 10);
    
    UILabel *maxTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maxIma.frame) + 8, CGRectGetMaxY(maxLab.frame) , CGRectGetWidth(maxView.frame) - CGRectGetMaxX(maxIma.frame) - 16, 26)];
    maxTitLab.textAlignment = NSTextAlignmentCenter;
    maxTitLab.font = FontGothamLight(14);
    maxTitLab.text = SMALocalizedString(@"device_HR_max");
    maxTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [maxView addSubview:maxIma];
    [maxView addSubview:maxLab];
    [maxView addSubview:maxTitLab];
    
    CGFloat viewHight = CGRectGetHeight(runTimeView.frame) + CGRectGetHeight(disView.frame) + CGRectGetHeight(perView.frame) + CGRectGetHeight(hrTimeView.frame) + CGRectGetHeight(avgView.frame);
    self.frame = CGRectMake(self.frame.origin.x, MainScreen.size.height - viewHight - 64, self.frame.size.width, CGRectGetHeight(runTimeView.frame) + CGRectGetHeight(disView.frame) + CGRectGetHeight(perView.frame) + CGRectGetHeight(hrTimeView.frame) + CGRectGetHeight(avgView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.frame));
}

- (void)createB2UI{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGR];
    
    UIView *runTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 44)];
    runTimeView.backgroundColor = [SmaColor colorWithHexString:@"#5691FF" alpha:1];
    [self addSubview:runTimeView];
    
    CGSize fontSize = [@"00:00:000" sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(20)}];
    timeLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width - 10 - fontSize.width, 0, fontSize.width, 44)];
    timeLab.textColor = [UIColor whiteColor];
    timeLab.font = FontGothamLight(20);
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.text = @"00:00:00";
    
    timeTitLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetMinX(timeLab.frame) - 10, 44)];
    timeTitLab.textColor = [UIColor whiteColor];
    timeTitLab.font = FontGothamLight(16);
    timeTitLab.text = SMALocalizedString(@"device_RU_lunTime");
    
    [runTimeView addSubview:timeLab];
    [runTimeView addSubview:timeTitLab];
    
    //路程
    UIView *disView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(runTimeView.frame), MainScreen.size.width/2 - 0.5, 52)];
    disView.backgroundColor = [UIColor whiteColor];
    [self addSubview:disView];
    
    UIImageView *disIma = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 26)];
    disIma.image = [UIImage imageNamed:@"icon_distance"];
    disIma.center = CGPointMake(disIma.center.x, disView.frame.size.height/2);
    
    disLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(disIma.frame) + 8, 0, CGRectGetWidth(disView.frame) - CGRectGetMaxX(disIma.frame) - 16, 26)];
    disLab.textAlignment = NSTextAlignmentCenter;
    disLab.center = CGPointMake(disLab.center.x, CGRectGetHeight(disView.frame)/2 - 10);
    
    UILabel *disTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(disIma.frame) + 8, CGRectGetMaxY(disLab.frame) , CGRectGetWidth(disView.frame) - CGRectGetMaxX(disIma.frame) - 16, 26)];
    disTitLab.textAlignment = NSTextAlignmentCenter;
    disTitLab.font = FontGothamLight(14);
    disTitLab.text = SMALocalizedString(@"device_SP_sumDista");
    disTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [disView addSubview:disIma];
    [disView addSubview:disLab];
    [disView addSubview:disTitLab];
    
    //热量
    UIView *perView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(disView.frame) + 1, CGRectGetMaxY(runTimeView.frame), MainScreen.size.width/2 - 0.5, 52)];
    perView.backgroundColor = [UIColor whiteColor];
    [self addSubview:perView];
    
    UIImageView *perIma = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 21, 25)];
    perIma.image = [UIImage imageNamed:@"icon_cal"];
    perIma.center = CGPointMake(perIma.center.x, perView.frame.size.height/2);
    
    perLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(perIma.frame) + 8, 0, CGRectGetWidth(perView.frame) - CGRectGetMaxX(perIma.frame) -16, 26)];
    perLab.textAlignment = NSTextAlignmentCenter;
    perLab.center = CGPointMake(perLab.center.x, CGRectGetHeight(perView.frame)/2 - 10);
    
    UILabel *perTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(perIma.frame) + 8, CGRectGetMaxY(perLab.frame) , CGRectGetWidth(perView.frame) - CGRectGetMaxX(perIma.frame) +- 16, 26)];
    perTitLab.textAlignment = NSTextAlignmentCenter;
    perTitLab.font = FontGothamLight(14);
    perTitLab.text = SMALocalizedString(@"device_SP_heat");
    perTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [perView addSubview:perIma];
    [perView addSubview:perLab];
    [perView addSubview:perTitLab];
    
    //配速
    UIView *paceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(disView.frame) + 1, MainScreen.size.width/2 - 0.5, 52)];
    paceView.backgroundColor = [UIColor whiteColor];
    [self addSubview:paceView];
    
    UIImageView *paceIma = [[UIImageView alloc] initWithFrame:CGRectMake(5.5, 0, 30, 30)];
    paceIma.image = [UIImage imageNamed:@"icon_pace"];
    paceIma.center = CGPointMake(paceIma.center.x, paceView.frame.size.height/2);
    
    paceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paceIma.frame) + 4, 0, CGRectGetWidth(paceView.frame) - CGRectGetMaxX(paceIma.frame) - 8, 26)];
    paceLab.textAlignment = NSTextAlignmentCenter;
    paceLab.center = CGPointMake(paceLab.center.x, CGRectGetHeight(paceView.frame)/2 - 10);
    
    UILabel *paceTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paceIma.frame) + 8, CGRectGetMaxY(paceLab.frame) , CGRectGetWidth(paceView.frame) - CGRectGetMaxX(paceIma.frame) - 16, 26)];
    paceTitLab.textAlignment = NSTextAlignmentCenter;
    paceTitLab.font = FontGothamLight(14);
    paceTitLab.text = SMALocalizedString(@"device_RU_pace");
    paceTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [paceView addSubview:paceIma];
    [paceView addSubview:paceLab];
    [paceView addSubview:paceTitLab];
    
    //步频
    UIView *calView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paceView.frame) + 1, CGRectGetMaxY(disView.frame) + 1, MainScreen.size.width/2 - 0.5, 52)];
    calView.backgroundColor = [UIColor whiteColor];
    [self addSubview:calView];
    
    UIImageView *calIma = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 30, 30)];
    calIma.image = [UIImage imageNamed:@"icon_spm"];
    calIma.center = CGPointMake(calIma.center.x, calView.frame.size.height/2);
    
    calLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(calIma.frame) + 8, 0, CGRectGetWidth(calView.frame) - CGRectGetMaxX(calIma.frame) -
                                                       16, 26)];
    calLab.textAlignment = NSTextAlignmentCenter;
    calLab.center = CGPointMake(calLab.center.x, CGRectGetHeight(calView.frame)/2 - 10);
    
    UILabel *calTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(calIma.frame) + 8, CGRectGetMaxY(calLab.frame) , CGRectGetWidth(calView.frame) - CGRectGetMaxX(calIma.frame) - 16, 26)];
    calTitLab.textAlignment = NSTextAlignmentCenter;
    calTitLab.font = FontGothamLight(14);
    calTitLab.text = SMALocalizedString(@"device_RU_stride");
    calTitLab.adjustsFontSizeToFitWidth = YES;
    calTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [calView addSubview:calIma];
    [calView addSubview:calLab];
    [calView addSubview:calTitLab];
    
    //步数
    UIView *stepView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(paceView.frame) + 1, MainScreen.size.width/2 - 0.5, 52)];
    stepView.backgroundColor = [UIColor whiteColor];
    [self addSubview:stepView];
    
    UIImageView *stepIma = [[UIImageView alloc] initWithFrame:CGRectMake(5.5, 0, 30, 30)];
    stepIma.image = [UIImage imageNamed:@"icon_step"];
    stepIma.center = CGPointMake(paceIma.center.x, stepView.frame.size.height/2);
    
    stepLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(paceIma.frame) + 4, 0, CGRectGetWidth(stepView.frame) - CGRectGetMaxX(paceIma.frame) - 8, 26)];
    stepLab.textAlignment = NSTextAlignmentCenter;
    stepLab.center = CGPointMake(stepLab.center.x, CGRectGetHeight(stepView.frame)/2 - 10);
    
    UILabel *stepTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stepIma.frame) + 8, CGRectGetMaxY(stepLab.frame) , CGRectGetWidth(stepView.frame) - CGRectGetMaxX(paceIma.frame) - 16, 26)];
    stepTitLab.textAlignment = NSTextAlignmentCenter;
    stepTitLab.font = FontGothamLight(14);
    stepTitLab.text = SMALocalizedString(@"device_RU_step");
    stepTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [stepView addSubview:stepIma];
    [stepView addSubview:stepLab];
    [stepView addSubview:stepTitLab];
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stepView.frame) + 1, CGRectGetMaxY(calView.frame) + 1, MainScreen.size.width/2 - 0.5, 52)];
    moreView.backgroundColor = [UIColor whiteColor];
    [self addSubview:moreView];
    
    //心率
    UIView *hrTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(stepView.frame), MainScreen.size.width, 44)];
    hrTimeView.backgroundColor = [SmaColor colorWithHexString:@"#FF568A" alpha:1];
    [self addSubview:hrTimeView];
    
    hrTapBut = [UIButton buttonWithType:UIButtonTypeCustom];
    hrTapBut.frame = CGRectMake(0, 0,  MainScreen.size.width, 44);
    
    [hrTimeView addSubview:hrTapBut];
    
    UIImageView *indexIma = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreen.size.width - 20, 12, 12, 20)];
    indexIma.image = [UIImage imageNamed:@"icon_next"];
    //    [hrTimeView addSubview:indexIma];
    
    CGSize fontSize2 = [@"228 bpm" sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(20)}];
    hrLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width - 20 - fontSize2.width, 0, fontSize2.width, 44)];
    hrLab.textColor = [UIColor whiteColor];
    hrLab.font = FontGothamLight(20);
    hrLab.textAlignment = NSTextAlignmentRight;
    hrLab.text = @"228 bpm";
    
    UILabel *hrTitLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetMinX(hrLab.frame) - 10, 44)];
    hrTitLab.textColor = [UIColor whiteColor];
    hrTitLab.font = FontGothamLight(16);
    hrTitLab.text = SMALocalizedString(@"device_RU_lastHR");
    
    [hrTimeView addSubview:hrLab];
    [hrTimeView addSubview:hrTitLab];
    
    //平均心率
    UIView *avgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hrTimeView.frame), MainScreen.size.width/2 - 0.5, 55)];
    avgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:avgView];
    
    UIImageView *avgIma = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, 30, 30)];
    avgIma.image = [UIImage imageNamed:@"icon_heart"];
    avgIma.center = CGPointMake(avgIma.center.x, avgView.frame.size.height/2);
    
    avgLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avgIma.frame) + 8, 0, CGRectGetWidth(avgView.frame) - CGRectGetMaxX(avgIma.frame) - 16, 26)];
    avgLab.textAlignment = NSTextAlignmentCenter;
    avgLab.center = CGPointMake(avgLab.center.x, CGRectGetHeight(avgView.frame)/2 - 10);
    
    UILabel *avgTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avgIma.frame) + 8, CGRectGetMaxY(avgLab.frame) , CGRectGetWidth(avgView.frame) - CGRectGetMaxX(avgIma.frame) - 16, 26)];
    avgTitLab.textAlignment = NSTextAlignmentCenter;
    avgTitLab.font = FontGothamLight(14);
    avgTitLab.text = SMALocalizedString(@"device_HR_mean");
    avgTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [avgView addSubview:avgIma];
    [avgView addSubview:avgLab];
    [avgView addSubview:avgTitLab];
    
    //最大心率
    UIView *maxView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avgView.frame) + 1, CGRectGetMaxY(hrTimeView.frame) , MainScreen.size.width/2 - 0.5, 55)];
    maxView.backgroundColor = [UIColor whiteColor];
    [self addSubview:maxView];
    
    UIImageView *maxIma = [[UIImageView alloc] initWithFrame:CGRectMake(5.5, 0, 32, 32)];
    maxIma.image = [UIImage imageNamed:@"icon_heart_big"];
    maxIma.center = CGPointMake(maxIma.center.x, maxView.frame.size.height/2);
    
    maxLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maxIma.frame) + 8, 0, CGRectGetWidth(maxView.frame) - CGRectGetMaxX(maxIma.frame) - 16, 26)];
    maxLab.textAlignment = NSTextAlignmentCenter;
    maxLab.center = CGPointMake(maxLab.center.x, CGRectGetHeight(maxView.frame)/2 - 10);
    
    UILabel *maxTitLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maxIma.frame) + 8, CGRectGetMaxY(maxLab.frame) , CGRectGetWidth(maxView.frame) - CGRectGetMaxX(maxIma.frame) - 16, 26)];
    maxTitLab.textAlignment = NSTextAlignmentCenter;
    maxTitLab.font = FontGothamLight(14);
    maxTitLab.text = SMALocalizedString(@"device_HR_max");
    maxTitLab.textColor = [SmaColor colorWithHexString:@"#596877" alpha:1];
    [maxView addSubview:maxIma];
    [maxView addSubview:maxLab];
    [maxView addSubview:maxTitLab];
    
    CGFloat viewHight = CGRectGetHeight(runTimeView.frame) + CGRectGetHeight(disView.frame) + CGRectGetHeight(perView.frame) + CGRectGetHeight(hrTimeView.frame) + CGRectGetHeight(avgView.frame) + CGRectGetHeight(stepView.frame);
    self.frame = CGRectMake(self.frame.origin.x, MainScreen.size.height - viewHight - 64, self.frame.size.width, CGRectGetHeight(runTimeView.frame) + CGRectGetHeight(disView.frame) + CGRectGetHeight(perView.frame) + CGRectGetHeight(hrTimeView.frame) + CGRectGetHeight(avgView.frame) + CGRectGetHeight(stepView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.frame));
}

- (void)tapAction:(UITapGestureRecognizer *)sender{
    hidden = !hidden;
    _blgestureBock(hidden);
    if (hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height - 44);
            NSLog(@"+++%@",NSStringFromCGRect(self.frame));
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)updateUIwithData:(NSMutableDictionary *)dic{
    timeLab.text = dic[@"RUNTIME"];
    disLab.attributedText = dic[@"DISTANCE"];
    perLab.attributedText = ([[SMADefaultinfos getValueforKey:BANDDEVELIVE]  isEqualToString:@"SMA-B2"] || [[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B3"]) ? dic[@"CAL"]:dic[@"PER"];
    paceLab.attributedText = dic[@"PACE"];
    hrLab.attributedText = dic[@"REAT"];
    avgLab.attributedText = dic[@"AVGHR"];
    maxLab.attributedText = dic[@"MAXHR"];
    int steps = [dic[@"ENDSTEP"] intValue] - [dic[@"STARTSTEP"] intValue];
    stepLab.attributedText = [self putHrWithReat:[NSString stringWithFormat:@"%d",steps] unit:steps > 1 ? SMALocalizedString(@"device_SP_steps"):SMALocalizedString(@"device_SP_step")];
    float times = [dic[@"PRECISEEND"] doubleValue] - [dic[@"PRECISESTART"] doubleValue];
    float stride = steps/(times/1000/60);
    NSString *strideStr = [SMACalculate notRounding:stride afterPoint:0];
    calLab.attributedText = ([[SMADefaultinfos getValueforKey:BANDDEVELIVE]  isEqualToString:@"SMA-B2"] || [[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B3"]) ? [self putHrWithReat:strideStr unit:@"spm"] : dic[@"CAL"];
}


- (void)tapPushBut:(pushAction)action{
    _block = action;
    //  [hrTapBut addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSMutableAttributedString *)putHrWithReat:(NSString *)hr unit:(NSString *)unit{
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(19)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(14)};
    NSMutableAttributedString *perAttStr = [[NSMutableAttributedString alloc] initWithString:hr ? hr:@"0" attributes:disDic];
    NSAttributedString *unitAtt = [[NSAttributedString alloc] initWithString:unit attributes:unitDic];
    [perAttStr appendAttributedString:unitAtt];
    return perAttStr;
}

- (void)pushAction:(UIButton *)sender{
    _block(sender);
}

- (void)tapGesture:(gestureAction)action{
    _blgestureBock = action;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
