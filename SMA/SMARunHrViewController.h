//
//  SMARunHrViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/24.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScattView.h"
#import "SMASportStypeView.h"
@interface SMARunHrViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *hrArr;
@property (nonatomic, strong) NSMutableDictionary *runDic;
@end
