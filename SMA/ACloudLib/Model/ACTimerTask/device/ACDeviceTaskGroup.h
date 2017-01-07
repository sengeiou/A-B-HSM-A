//
//  ACDeviceTaskGroup.h
//  ac-service-ios-Demo
//
//  Created by __zimu on 16/7/18.
//  Copyright © 2016年 OK. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ACDeviceTask;
@interface ACDeviceTaskGroup : NSObject
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *name;
//任务数组
@property (nonatomic, strong) NSArray<ACDeviceTask *> *tasks;

+ (instancetype)groupWithDict:(NSDictionary *)dict;
@end