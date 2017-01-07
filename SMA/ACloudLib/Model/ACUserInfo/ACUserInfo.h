//
//  ACUserInfo.h
//  AbleCloudLib
//
//  Created by leverly on 15/7/10.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>

//  账号基本信息
@interface ACUserInfo : NSObject

// 用户ID
@property(nonatomic,assign) NSInteger userId;
// 手机号码
@property(nonatomic,copy) NSString *phone;
// 电子邮件地址
@property(nonatomic,copy) NSString *email;
// 用户昵称
@property(nonatomic,copy) NSString *nickName;
// 头像URL
@property (nonatomic, copy) NSString *iconURL;

+ (instancetype)userInfoWithDict:(NSDictionary *)dict;
@end

