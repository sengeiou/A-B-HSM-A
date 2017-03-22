//
//  SMARunHrViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/24.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMARunHrViewController.h"

@interface SMARunHrViewController ()

@end

@implementation SMARunHrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUI{
//    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568 - 64) style:UITableViewStyleGrouped];
//    tab.delegate = self;
//    tab.dataSource = self;
//    [self.view addSubview:tab];
    
//    ScattView *scatView = [[ScattView alloc] initWithFrame:CGRectMake(10, 70, 300, 400)];
//    scatView.backgroundColor = [UIColor greenColor];
////    scatView.delegate = self;
//    scatView.HRdataArr = [NSMutableArray array];
//    scatView.YgiveLsat = YES;//隐藏Y轴数据最后一位
//    scatView.DrawMode = CPTGraphScatterPlot;
//    scatView.lineColors = @[[CPTColor whiteColor]];
//    scatView.poinColors = [CPTColor whiteColor];
//    scatView.identifiers = @[@""];  //随便定义
//    sca`tView.showLegend = NO;
//    scatView.xCoordinateDecimal = -1;
//    scatView.hideYAxisLabels = NO;
//    scatView.barOffset = 1.0;
////    scatView.showBarGoap = _showBarGoap;
////    scatView.barIntermeNumber = _barIntermeNumber;
//    scatView.allowsUserInteraction = YES;
//    scatView.hideYAxisLabels = YES;
//    scatView.plotAreaFramePaddingLeft = 0;
////    scatView.xRangeLength = _xRangeLength;
////    scatView.selectColor = self.selectColor;
//    scatView.ylabelLocation = 30;
//    scatView.yAxisTexts = @[@"60",@"80",@"90",@"114",@"140",@"168"];
//    scatView.xMajorIntervalLength = @"1";
//    scatView.yValues = @[@[@"",@"92",@"85",@"124",@"76",@"143",@"86",@"101",@"88",@"86",@"109",@"89"]];
//    scatView.xAxisTexts = @[@"92",@"85",@"124",@"76",@"143",@"86",@"101",@"88",@"86",@"109",@"89"];
//    [self.view addSubview:scatView];
//    [scatView initGraph];
    
    SMASportStypeView *stypeView = [[SMASportStypeView alloc] initWithFrame:CGRectMake(10, 70, 300, 400)];
    stypeView.colors = @[[SmaColor colorWithHexString:@"#ed7220" alpha:1],[SmaColor colorWithHexString:@"#ffb017" alpha:1],[SmaColor colorWithHexString:@"#36cd27" alpha:1],[SmaColor colorWithHexString:@"#16dbb4" alpha:1],[SmaColor colorWithHexString:@"#2e81ed" alpha:1]];
    stypeView.leftTits = @[@"168",@"140",@"114",@"90",@"80",@"60"];
    stypeView.YleftTits = @[SMALocalizedString(@"剧烈运动"),SMALocalizedString(@"无氧运动"),SMALocalizedString(@"有氧运动"),SMALocalizedString(@"燃烧脂肪"),SMALocalizedString(@"热身阶段")];
    stypeView.rightTits = @[@"100%",@"90%",@"80%",@"70%",@"60%",@"50%"];
    stypeView.XbottomTits = @[SMALocalizedString(@"开始时间"),SMALocalizedString(@"结束时间")];
    stypeView.hrDatas = _hrArr;
    [self.view addSubview:stypeView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _hrArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"time: %@",[NSString stringWithFormat:@"%D:%D",[[_hrArr[indexPath.row] objectForKey:@"TIME"] intValue]/60,[[_hrArr[indexPath.row] objectForKey:@"TIME"] intValue]%60]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ bpm",[_hrArr[indexPath.row] objectForKey:@"REAT"]];
    
    return cell;
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
