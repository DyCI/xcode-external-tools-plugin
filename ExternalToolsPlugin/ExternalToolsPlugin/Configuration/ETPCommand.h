//
// Created by Paul Taykalo on 1/17/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ETPInputType) {
    ETPInputTypeNone,
    ETPInputTypeJson,
};

@interface ETPCommand : NSObject

@property(nonatomic, strong) NSString * commandLine;
@property(nonatomic, assign) ETPInputType inputType;

@end