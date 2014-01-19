//
// Created by Paul Taykalo on 1/17/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ETPConfig : NSObject

@property(nonatomic, strong) NSArray * tools;
@property(nonatomic, strong) NSString * version;

+ (ETPConfig *)configWithJSONString:(NSString *)string;

@end