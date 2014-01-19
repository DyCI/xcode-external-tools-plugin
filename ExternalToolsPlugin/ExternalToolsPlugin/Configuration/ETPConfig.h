//
// Created by Paul Taykalo on 1/17/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ETP_CONFIG_VERSION                    @"0.1"
#define ETP_CONFIG_DEFAULT_TOOL               @"External tools usage"
#define ETP_CONFIG_DEFAULT_TOOL_COMMAND_LINE  @"open \"https://github.com/DyCI/xcode-external-tools-plugin/wiki/External-tools-plugin#configuration\""

@interface ETPConfig : NSObject

@property(nonatomic, strong) NSArray * tools;
@property(nonatomic, strong) NSString * version;

+ (ETPConfig *)configWithJSONString:(NSString *)string;

/*
Returns base
 */
+ (ETPConfig *)defaultConfig;
+ (NSString *)defaultConfigJSONString;

@end