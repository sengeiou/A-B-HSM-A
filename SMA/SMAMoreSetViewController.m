//
//  SMAMoreSetViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/5.
//  Copyright © 2016年 SMA. All rights reserved.
//
#import "SMACenterAlerView.h"
#import "SMAMoreSetViewController.h"

@interface SMAMoreSetViewController ()<cenAlerButDelegate>
{
    NSArray *titleArr;
    SMAUserInfo *user;
    
    UIButton *laoutLab;
}
@end

@implementation SMAMoreSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self createUI];
    [self initializeMethod];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)initializeMethod{
    self.title = SMALocalizedString(@"me_more_set");
    user = [SMAAccountTool userInfo];
    titleArr = @[@[SMALocalizedString(@"me_perso_unit")],[SMADefaultinfos getIntValueforKey:THIRDLOGIN] ? @[SMALocalizedString(@"me_set_version"),SMALocalizedString(@"me_set_feedback")]:@[SMALocalizedString(@"me_set_version"),SMALocalizedString(@"login_findPass"),SMALocalizedString(@"me_set_feedback")],@[/*SMALocalizedString(@"me_repairDfu"),SMALocalizedString(@"字库修复"),*/SMALocalizedString(@"me_set_about")]];
}

- (void)createUI{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    laoutLab = [UIButton buttonWithType:UIButtonTypeCustom];
    laoutLab.frame = CGRectMake(20, MainScreen.size.height - 64 - 80, MainScreen.size.width - 40, 44);
    laoutLab.layer.cornerRadius = 22;
    laoutLab.titleLabel.textAlignment = NSTextAlignmentCenter;
    [laoutLab setTitle:SMALocalizedString(@"me_signOut") forState:UIControlStateNormal];
    [laoutLab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    laoutLab.backgroundColor = [SmaColor colorWithHexString:@"#7EBFF9" alpha:1];
    laoutLab.layer.masksToBounds = YES;
    [laoutLab addTarget:self action:@selector(lououtSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:laoutLab];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titleArr[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MORESETCELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MORESETCELL"];
    }
    cell.textLabel.font = FontGothamLight(16);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [titleArr[indexPath.section] objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = FontGothamLight(14);
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = user.unit.intValue ? SMALocalizedString(@"me_perso_british"):SMALocalizedString(@"me_perso_metric");
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSArray *unitArr = @[SMALocalizedString(@"me_perso_metric"),SMALocalizedString(@"me_perso_british")];
        __block NSInteger selectRow = user.unit.integerValue;
        SMACenterTabView *timeTab = [[SMACenterTabView alloc] initWithMessages:unitArr selectMessage:unitArr[selectRow] selName:@"icon_selected"];
        [timeTab tabViewDidSelectRow:^(NSIndexPath *indexPath) {
            user.unit = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            [SMADefaultinfos putInt:BRITISHSYSTEM andValue:user.unit.intValue];
            [SmaBleSend setBritishSystem:[SMADefaultinfos getIntValueforKey:BRITISHSYSTEM]];
            cell.detailTextLabel.text = unitArr[indexPath.row];
            [SMAAccountTool saveUser:user];
            SmaAnalysisWebServiceTool *webService = [[SmaAnalysisWebServiceTool alloc] init];
            [webService acloudPutUserifnfo:user success:^(NSString *success) {
                
            } failure:^(NSError *error) {
                
            }];

        }];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:timeTab];
    }
    
    if (indexPath.section == 1 && indexPath.row == 1 && ![SMADefaultinfos getIntValueforKey:THIRDLOGIN]){
        [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAChangePassViewController"] animated:YES];
    }
    else if (indexPath.section == 1 && (indexPath.row == ([SMADefaultinfos getIntValueforKey:THIRDLOGIN] ? 1:2))){
         [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAOpinion_ViewController"] animated:YES];
    }
//     else if (indexPath.section == 2 && indexPath.row == 0){
//         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//         layout.scrollDirection = UICollectionViewScrollDirectionVertical;
////         layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 10)/3, ([UIScreen mainScreen].bounds.size.width - 10)/3);
////         layout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 20);
////         layout.mar
//         [self.navigationController pushViewController:[[SMARepairDfuCollectionController alloc] initWithCollectionViewLayout:layout] animated:YES];
//     }
    else if (indexPath.section == 2 && indexPath.row == 0){
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        SMARepairDfuCollectionController *repairVC = [[SMARepairDfuCollectionController alloc] initWithCollectionViewLayout:layout];
//        repairVC.repairFont = YES;
//        [self.navigationController pushViewController:repairVC animated:YES];
        
        
//        SMADfuViewController *dfuVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"SMADfuViewController"];
//        dfuVC.epairPeripheral = SmaBleMgr.peripheral;
//        dfuVC.repairBleCustom = [NSString stringWithFormat:@"%@_%@",SmaBleMgr.peripheral.name,[SMADefaultinfos getValueforKey:SMACUSTOM]];
//        dfuVC.repairDeviceName = [NSString stringWithFormat:@"%@_%@",SmaBleMgr.peripheral.name,[SMADefaultinfos getValueforKey:SMACUSTOM]];
//        SmaBleMgr.repairFont = YES;
//        [self.navigationController pushViewController:dfuVC animated:YES];

        
         [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAAboutUsViewController"] animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 2){
        [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAAboutUsViewController"] animated:YES];
    }
}


- (void)lououtSelect{
    
    SMACenterAlerView *cenAler = [[SMACenterAlerView alloc] initWithMessage: SMALocalizedString(@"me_signOut_remind") buttons:@[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"me_signOut_confirm")]];
    cenAler.delegate = self;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:cenAler];
    
}

#pragma mark ***********cenAlerButDelegate
- (void)centerAlerView:(SMACenterAlerView *)alerView didAlerBut:(UIButton *)button{
    if (button.tag == 102) {
        SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
        //        SMAUserInfo *user = [SMAAccountTool userInfo];
        [webservice acloudSyncAllDataWithAccount:user.userID callBack:^(id finish) {
            
        }];
        [webservice logOutSuccess:^(bool result) {
            
        }];
        user.userID = @"";
        user.watchUUID = nil;
        [SMAAccountTool saveUser:user];
        UINavigationController *loginNav = [MainStoryBoard instantiateViewControllerWithIdentifier:@"ViewController"];
        [UIApplication sharedApplication].keyWindow.rootViewController=loginNav;
    }
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
