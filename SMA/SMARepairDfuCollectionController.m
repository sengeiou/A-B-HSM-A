//
//  SMARepairDfuCollectionController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/3/7.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMARepairDfuCollectionController.h"

@interface SMARepairDfuCollectionController ()
{
    NSMutableArray *imageArr;
    NSMutableArray *nameArr;
}
@end

@implementation SMARepairDfuCollectionController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const sectionHeaderIdentifier = @"SectionHeader";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMARepairDfuCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMAReoaurDfuReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self initializeMethod];
    self.title = SMALocalizedString(@"me_repairDfu");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)initializeMethod{
    nameArr = [NSMutableArray array];
    imageArr = [NSMutableArray array];
    
    SmaAnalysisWebServiceTool *tool = [[SmaAnalysisWebServiceTool alloc] init];
    if (self.repairFont) {
        [tool acloudDfuFileWithFirmwareType:firmware_smaProducts callBack:^(NSArray *finish, NSError *error) {
            for (int i = 0; i < finish.count; i++) {
                NSDictionary *firmareDic = finish[i];
                if ([firmareDic[@"filename"] rangeOfString:@"(1)"].location != NSNotFound && [firmareDic[@"filename"] hasPrefix:@"a"]) {
                    NSMutableDictionary *objectDic = [firmareDic[@"extendAttrs"][@"objectData"] mutableCopy];
                    [objectDic setObject:firmareDic[@"downloadUrl"] forKey:@"downloadUrl"];
                    [imageArr addObject:objectDic];
                }
            }
            [self.collectionView reloadData];
        }];
    }
    else{
        [tool acloudDfuFileWithFirmwareType:firmware_smaProducts callBack:^(NSArray *finish, NSError *error) {
            for (int i = 0; i < finish.count; i++) {
                NSDictionary *firmareDic = finish[i];
                if ([firmareDic[@"filename"] rangeOfString:@"(1)"].location != NSNotFound) {
                    NSMutableDictionary *objectDic = [firmareDic[@"extendAttrs"][@"objectData"] mutableCopy];
                    [objectDic setObject:firmareDic[@"downloadUrl"] forKey:@"downloadUrl"];
                    [imageArr addObject:objectDic];
                }
            }
            [self.collectionView reloadData];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    SmaBleMgr.repairDfu = NO;
    SmaBleMgr.repairFont = NO;
    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-Q2"]) {
        SmaBleMgr.scanNameArr = @[@"SMA-Q2"];
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]){
        SmaBleMgr.scanNameArr = @[@"SM07"];
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A1"]){
        SmaBleMgr.scanNameArr = @[@"SMA-A1"];
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A2"]){
        SmaBleMgr.scanNameArr = @[@"SMA-A2"];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SMARepairDfuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        cell.topShow = YES;
    }
    cell.titleLab.text = [imageArr objectAtIndex:indexPath.row][@"product_name"];
    cell.imageUrl = [imageArr objectAtIndex:indexPath.row][@"downloadUrl"];
    cell.bottomShow = YES;
    if (indexPath.row%3 == 0) {
        cell.rightShow = YES;
    }
    if (indexPath.row%3 == 1) {
        cell.rightShow = YES;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SMAReoaurDfuReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderIdentifier forIndexPath:indexPath];
    headerView.titleLab1.text = SMALocalizedString(@"me_repairSelect");
    return headerView;
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 20)/3;
    return CGSizeMake(width, 125);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 44);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SMARepairTableViewController *repairDeviceVC = [[SMARepairTableViewController alloc] init];
    
    repairDeviceVC.deviceName = [[imageArr objectAtIndex:indexPath.row] objectForKey:@"firmware_prefix"];
    repairDeviceVC.bleCustom = [[imageArr objectAtIndex:indexPath.row] objectForKey:@"firmware_prefix"];
    repairDeviceVC.dfuName = [[imageArr objectAtIndex:indexPath.row] objectForKey:@"dfu_name"];
    
    //    if (indexPath.row == 0) {
    //        repairDeviceVC.deviceName = @"SMA-A1";
    //        repairDeviceVC.bleCustom = @"SmartCare";
    //        repairDeviceVC.dfuName = @"DfuTarg";
    //    }
    //    if (indexPath.row == 1) {
    //        repairDeviceVC.deviceName = @"SMA-A2";
    //        repairDeviceVC.bleCustom = @"SmartCare";
    //        repairDeviceVC.dfuName = @"DfuTarg";
    //    }
    //    if (indexPath.row == 2) {
    //    repairDeviceVC.deviceName = @"SM07";
    //    repairDeviceVC.bleCustom = @"SmartCare";
    //        repairDeviceVC.dfuName = @"DfuTarg";
    //    }
    //    else{
    //        repairDeviceVC.deviceName = @"SMA-Q2";
    //        repairDeviceVC.bleCustom = @"SmartCare";
    //        repairDeviceVC.dfuName = @"Dfu10B10";
    //    }
    if (_repairFont) {
        SmaBleMgr.repairFont = YES;
    }
    else{
        SmaBleMgr.repairDfu = YES;
    }
    repairDeviceVC.repairFont = _repairFont;
    [self.navigationController pushViewController:repairDeviceVC animated:YES];
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
