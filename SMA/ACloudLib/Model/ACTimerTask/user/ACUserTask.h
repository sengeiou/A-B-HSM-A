//
//  ACUserTask.h
//  ac-service-ios-Demo
//
//  Created by __zimu on 16/7/16.
//  Copyright © 2016年 OK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ACUserTaskStatus) {
    ACUserTaskStatusClose,
    ACUserTaskStatusOpen,
};

@class ACUserCommand;
@class ACTimeRule;
@interface ACUserTask : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) ACTimeRule *timeRule;
@property (nonatomic, strong) ACUserCommand *command;

@property (nonatomic, copy, readonly) NSString *createTime;
@property (nonatomic, copy, readonly) NSString *modifyTime;
@property (nonatomic, copy, readonly) NSString *ownerId;
@property (nonatomic, copy, readonly) NSString *ownerType;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, assign, readonly) NSInteger taskId;
@property (nonatomic, assign, readonly) ACUserTaskStatus status;

- (instancetype)init NS_UNAVAILABLE;
///  生成一条发送给uds的用户定时任务
///
///  @param name     定时任务名称
///  @param desc     任务简介
///  @param timeRule 任务的执行时间
///  @param command  发送给UDS的任务指令
///
///  @return 任务对象实例
- (instancetype)initWithName:(NSString *)name
                        desc:(NSString *)desc
                    timeRule:(ACTimeRule *)timeRule
                     command:(ACUserCommand *)command;

+ (instancetype)taskWithDict:(NSDictionary *)dict;



- (NSData *)marshal;
- (NSDictionary *)toJSON;

@end
